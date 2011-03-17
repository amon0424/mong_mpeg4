 /******************************************************************************
  *                                                                            *
  *  This file is part of XviD, a free MPEG-4 video encoder/decoder            *
  *                                                                            *
  *  XviD is an implementation of a part of one or more MPEG-4 Video tools     *
  *  as specified in ISO/IEC 14496-2 standard.  Those intending to use this    *
  *  software module in hardware or software products are advised that its     *
  *  use may infringe existing patents or copyrights, and any such use         *
  *  would be at such party's own risk.  The original developer of this        *
  *  software module and his/her company, and subsequent editors and their     *
  *  companies, will have no liability for use of this software or             *
  *  modifications or derivatives thereof.                                     *
  *                                                                            *
  *  XviD is free software; you can redistribute it and/or modify it           *
  *  under the terms of the GNU General Public License as published by         *
  *  the Free Software Foundation; either version 2 of the License, or         *
  *  (at your option) any later version.                                       *
  *                                                                            *
  *  XviD is distributed in the hope that it will be useful, but               *
  *  WITHOUT ANY WARRANTY; without even the implied warranty of                *
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             *
  *  GNU General Public License for more details.                              *
  *                                                                            *
  *  You should have received a copy of the GNU General Public License         *
  *  along with this program; if not, write to the Free Software               *
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA  *
  *                                                                            *
  ******************************************************************************/

 /******************************************************************************
  *                                                                            *
  *  timer.c, some timing functions                                            *
  *                                                                            *
  *  Copyright (C) 2001 - Michael Militzer <isibaar@xvid.org>                  *
  *                                                                            *
  *  For more information visit the XviD homepage: http://www.xvid.org         *
  *                                                                            *
  ******************************************************************************/

 /******************************************************************************
  *                                                                            *
  *  Revision history:                                                         *
  *
  *  26.03.2002 interlacing timer added
  *  21.12.2001 edges error fixed
  *  17.11.2001 small clean up (Isibaar)                                       *
  *  13.11.2001	inlined rdtsc call and moved to portab.h (Isibaar)             *
  *  02.11.2001 initial version (Isibaar)                                      *
  *                                                                            *
  ******************************************************************************/

#include <stdio.h>
#include "timer.h"
#include "time.h"

#if defined(_PROFILING_)

static __inline int64
read_counter()
{
    return clock() * 1000 / CLOCKS_PER_SEC;
}

struct ts
{
    int64   current;
    int64   global;
    int64   overall;
    int64   idct;
    int64   iquant;
    int64   comp;
    int64   edges;
    int64   conv;
    int64   trans;
    int64   prediction;
    int64   coding;
};

struct ts t;

// set everything to zero //
void
init_timer()
{
    /* initialize timer counts */
    memset((void *) &t, 0, sizeof(t));
}

void
cleanup_timer()
{
}

void
start_timer()
{
    t.current = read_counter();
}

void
start_global_timer()
{
    t.global = read_counter();
}

void
stop_idct_timer()
{
    t.idct += (read_counter() - t.current);
}

void
stop_iquant_timer()
{
    t.iquant += (read_counter() - t.current);
}

void
stop_comp_timer()
{
    t.comp += (read_counter() - t.current);
}

void
stop_edges_timer()
{
    t.edges += (read_counter() - t.current);
}

void
stop_conv_timer()
{
    t.conv += (read_counter() - t.current);
}

void
stop_transfer_timer()
{
    t.trans += (read_counter() - t.current);
}

void
stop_prediction_timer()
{
    t.prediction += (read_counter() - t.current);
}

void
stop_coding_timer()
{
    t.coding += (read_counter() - t.current);
}

void
stop_global_timer()
{
    t.overall += (read_counter() - t.global);
}

/*
    write log file with some timer information
*/
void
write_timer()
{
    float   total_ticks;
    float   idct_per, iquant_per, comp_per, edges_per;
    float   conv_per, trans_per, pred_per, cod_per, measured;
    int64   sum_ticks = 0;

    // only write log file every 50 processed frames //
    total_ticks = (t.overall < 1)? 1 : (float) t.overall;

    idct_per =
        (float) (((float) ((float) t.idct / total_ticks)) * 100.0);
    iquant_per =
        (float) (((float) ((float) t.iquant / total_ticks)) * 100.0);
    comp_per =
        (float) (((float) ((float) t.comp / total_ticks)) * 100.0);
    edges_per =
        (float) (((float) ((float) t.edges / total_ticks)) * 100.0);
    conv_per =
        (float) (((float) ((float) t.conv / total_ticks)) * 100.0);
    trans_per =
        (float) (((float) ((float) t.trans / total_ticks)) * 100.0);
    pred_per =
        (float) (((float) ((float) t.prediction / total_ticks)) * 100.0);
    cod_per =
        (float) (((float) ((float) t.coding / total_ticks)) * 100.0);

    sum_ticks = t.coding + t.conv + t.idct + t.edges +
        t.iquant + t.trans + t.comp + t.prediction;

    measured =
        (float) (((float) ((float) sum_ticks / total_ticks)) * 100.0);

    printf("\n"
           "IDCT Computation:        %9.2f ms (%5.2f%% of total decoding time)\n"
           "Inverse Quantization:    %9.2f ms (%5.2f%% of total decoding time)\n"
           "Motion Compensation:     %9.2f ms (%5.2f%% of total decoding time)\n"
           "Boundary Extension:      %9.2f ms (%5.2f%% of total decoding time)\n"
           "Boundary Removal:        %9.2f ms (%5.2f%% of total decoding time)\n"
           "Block Data Transfer:     %9.2f ms (%5.2f%% of total decoding time)\n"
           "DC/AC Prediction:        %9.2f ms (%5.2f%% of total decoding time)\n"
           "VLC Decoding:            %9.2f ms (%5.2f%% of total decoding time)\n"
           "Total decoding time:     %9.2f ms, we measured %8.2f ms (%5.2f%%)\n",
           (float) t.idct, idct_per,
           (float) t.iquant, iquant_per,
           (float) t.comp, comp_per,
           (float) t.edges, edges_per,
           (float) t.conv, conv_per,
           (float) t.trans, trans_per,
           (float) t.prediction, pred_per,
           (float) t.coding, cod_per,
           (float) t.overall, (float) sum_ticks, measured);
}

#endif
