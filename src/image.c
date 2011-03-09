/**************************************************************************
 *
 *	XVID MPEG-4 VIDEO CODEC
 *	image stuff
 *
 *	This program is an implementation of a part of one or more MPEG-4
 *	Video tools as specified in ISO/IEC 14496-2 standard.  Those intending
 *	to use this software module in hardware or software products are
 *	advised that its use may infringe existing patents or copyrights, and
 *	any such use would be at such party's own risk.  The original
 *	developer of this software module and his/her company, and subsequent
 *	editors and their companies, will have no liability for use of this
 *	software or modifications or derivatives thereof.
 *
 *	This program is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; either version 2 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program; if not, write to the Free Software
 *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 ***************************************************************************
*/

/**************************************************************************
 *
 *	History:
 *
 *  09.04.2002  PSNR calculations
 *	06.04.2002	removed interlaced edging from U,V blocks (as per spec)
 *  26.03.2002  interlacing support (field-based edging in set_edges)
 *	26.01.2002	rgb555, rgb565
 *	07.01.2001	commented u,v interpolation (not required for uv-block-based)
 *  23.12.2001  removed #ifdefs, added function pointers + init_common()
 *	22.12.2001	cpu #ifdefs
 *	 6.12.2001	inital version; (c)2001 peter ross <pross@cs.rmit.edu.au>
 *
 ***************************************************************************
*/

#include <stdlib.h>
#include <string.h>             // memcpy, memset
#include <math.h>

#include "image.h"
#include "bilinear8x8.h"
#include "mem_align.h"

#define SAFETY 64
#define EDGE_SIZE2  (EDGE_SIZE/2)

int32
image_create(IMAGE * image, uint32 edged_width, uint32 edged_height)
{
    const uint32 edged_width2 = edged_width / 2;
    const uint32 edged_height2 = edged_height / 2;

    image->y =
        xvid_malloc(edged_width * (edged_height + 1) + SAFETY,
                    CACHE_LINE);
    if (image->y == NULL)
    {
        return -1;
    }

    image->u =
        xvid_malloc(edged_width2 * edged_height2 + SAFETY, CACHE_LINE);
    if (image->u == NULL)
    {
        xvid_free(image->y);
        return -1;
    }
    image->v =
        xvid_malloc(edged_width2 * edged_height2 + SAFETY, CACHE_LINE);
    if (image->v == NULL)
    {
        xvid_free(image->u);
        xvid_free(image->y);
        return -1;
    }

    image->y += EDGE_SIZE * edged_width + EDGE_SIZE;
    image->u += EDGE_SIZE2 * edged_width2 + EDGE_SIZE2;
    image->v += EDGE_SIZE2 * edged_width2 + EDGE_SIZE2;

    return 0;
}

void
image_destroy(IMAGE * image, uint32 edged_width, uint32 edged_height)
{
    const uint32 edged_width2 = edged_width / 2;

    if (image->y)
    {
        xvid_free(image->y - (EDGE_SIZE * edged_width + EDGE_SIZE));
    }
    if (image->u)
    {
        xvid_free(image->u - (EDGE_SIZE2 * edged_width2 + EDGE_SIZE2));
    }
    if (image->v)
    {
        xvid_free(image->v - (EDGE_SIZE2 * edged_width2 + EDGE_SIZE2));
    }
}

void
image_swap(IMAGE * image1, IMAGE * image2)
{
    uint8  *tmp;

    tmp = image1->y;
    image1->y = image2->y;
    image2->y = tmp;

    tmp = image1->u;
    image1->u = image2->u;
    image2->u = tmp;

    tmp = image1->v;
    image1->v = image2->v;
    image2->v = tmp;
}

void
image_copy(IMAGE * image1, IMAGE * image2, uint32 edged_width,
           uint32 height)
{
    memcpy(image1->y, image2->y, edged_width * height);
    memcpy(image1->u, image2->u, edged_width * height / 4);
    memcpy(image1->v, image2->v, edged_width * height / 4);
}

void
image_setedges(IMAGE * image, uint32 edged_width, uint32 edged_height,
               uint32 width, uint32 height, uint32 interlacing)
{
    const uint32 edged_width2 = edged_width / 2;
    const uint32 width2 = width / 2;
    uint32  i;
    uint8  *dst;
    uint8  *src;

    dst = image->y - (EDGE_SIZE + EDGE_SIZE * edged_width);
    src = image->y;

    for (i = 0; i < EDGE_SIZE; i++)
    {
        // if interlacing, edges contain top-most data from each field
        if (interlacing && (i & 1))
        {
            memset(dst, *(src + edged_width), EDGE_SIZE);
            memcpy(dst + EDGE_SIZE, src + edged_width, width);
            memset(dst + edged_width - EDGE_SIZE,
                   *(src + edged_width + width - 1), EDGE_SIZE);
        }
        else
        {
            memset(dst, *src, EDGE_SIZE);
            memcpy(dst + EDGE_SIZE, src, width);
            memset(dst + edged_width - EDGE_SIZE, *(src + width - 1),
                   EDGE_SIZE);
        }
        dst += edged_width;
    }

    for (i = 0; i < height; i++)
    {
        memset(dst, *src, EDGE_SIZE);
        memset(dst + edged_width - EDGE_SIZE, src[width - 1],
               EDGE_SIZE);
        dst += edged_width;
        src += edged_width;
    }

    src -= edged_width;
    for (i = 0; i < EDGE_SIZE; i++)
    {
        // if interlacing, edges contain bottom-most data from each field
        if (interlacing && !(i & 1))
        {
            memset(dst, *(src - edged_width), EDGE_SIZE);
            memcpy(dst + EDGE_SIZE, src - edged_width, width);
            memset(dst + edged_width - EDGE_SIZE,
                   *(src - edged_width + width - 1), EDGE_SIZE);
        }
        else
        {
            memset(dst, *src, EDGE_SIZE);
            memcpy(dst + EDGE_SIZE, src, width);
            memset(dst + edged_width - EDGE_SIZE, *(src + width - 1),
                   EDGE_SIZE);
        }
        dst += edged_width;
    }

//U
    dst = image->u - (EDGE_SIZE2 + EDGE_SIZE2 * edged_width2);
    src = image->u;

    for (i = 0; i < EDGE_SIZE2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memcpy(dst + EDGE_SIZE2, src, width2);
        memset(dst + edged_width2 - EDGE_SIZE2, *(src + width2 - 1),
               EDGE_SIZE2);
        dst += edged_width2;
    }

    for (i = 0; i < height / 2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memset(dst + edged_width2 - EDGE_SIZE2, src[width2 - 1],
               EDGE_SIZE2);
        dst += edged_width2;
        src += edged_width2;
    }
    src -= edged_width2;

    for (i = 0; i < EDGE_SIZE2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memcpy(dst + EDGE_SIZE2, src, width2);
        memset(dst + edged_width2 - EDGE_SIZE2, *(src + width2 - 1),
               EDGE_SIZE2);
        dst += edged_width2;
    }

// V
    dst = image->v - (EDGE_SIZE2 + EDGE_SIZE2 * edged_width2);
    src = image->v;

    for (i = 0; i < EDGE_SIZE2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memcpy(dst + EDGE_SIZE2, src, width2);
        memset(dst + edged_width2 - EDGE_SIZE2, *(src + width2 - 1),
               EDGE_SIZE2);
        dst += edged_width2;
    }

    for (i = 0; i < height / 2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memset(dst + edged_width2 - EDGE_SIZE2, src[width2 - 1],
               EDGE_SIZE2);
        dst += edged_width2;
        src += edged_width2;
    }
    src -= edged_width2;
    for (i = 0; i < EDGE_SIZE2; i++)
    {
        memset(dst, *src, EDGE_SIZE2);
        memcpy(dst + EDGE_SIZE2, src, width2);
        memset(dst + edged_width2 - EDGE_SIZE2, *(src + width2 - 1),
               EDGE_SIZE2);
        dst += edged_width2;
    }
}

void
image_interpolate(const IMAGE * refn, IMAGE * refh, IMAGE * refv,
                  IMAGE * refhv, xint edged_width, xint edged_height,
                  xint rounding)
{
    uint32  offset;
    uint8  *n_ptr, *h_ptr, *v_ptr, *hv_ptr;
    xint    x, y;

    uint32  stride_add = 7 * edged_width;

    offset = EDGE_SIZE * (edged_width + 1);

    n_ptr = refn->y;
    h_ptr = refh->y;
    v_ptr = refv->y;
    hv_ptr = refhv->y;

    n_ptr -= offset;
    h_ptr -= offset;
    v_ptr -= offset;
    hv_ptr -= offset;

    for (y = 0; y < edged_height; y += 8)
    {
        for (x = 0; x < edged_width; x += 8)
        {
            halfpel8x8_h(h_ptr, n_ptr, edged_width, rounding);
            halfpel8x8_v(v_ptr, n_ptr, edged_width, rounding);
            halfpel8x8_hv(hv_ptr, n_ptr, edged_width, rounding);

            n_ptr += 8;
            h_ptr += 8;
            v_ptr += 8;
            hv_ptr += 8;
        }
        h_ptr += stride_add;
        v_ptr += stride_add;
        hv_ptr += stride_add;
        n_ptr += stride_add;
    }
}

/* get source image */

int
image_input(IMAGE * image, uint32 width, int height, uint32 edged_width,
            uint8 * src)
{
    uint32  edged_width2 = edged_width >> 1;
    uint32  width2 = width >> 1;
    uint32  y;
    uint8  *y_out = image->y;
    uint8  *u_out = image->u;
    uint8  *v_out = image->v;

    for (y = height; y; y--)
    {
        memcpy(y_out, src, width);
        src += width;
        y_out += edged_width;
    }

    for (y = height >> 1; y; y--)
    {
        memcpy(u_out, src, width2);
        src += width2;
        u_out += edged_width2;
    }

    for (y = height >> 1; y; y--)
    {
        memcpy(v_out, src, width2);
        src += width2;
        v_out += edged_width2;
    }
    return 0;
}

int
image_output(IMAGE * image, uint32 width, int height,
             uint32 edged_width, uint8 * dst, uint32 dst_stride)
{
    int32   idx;
    uint8  *Y_Cur = image->y;
    uint8  *U_Cur = image->u;
    uint8  *V_Cur = image->v;
    uint32  width2 = width >> 1;
    uint32  edged_width2 = edged_width >> 1;
    uint32  dst_stride2 = dst_stride >> 1;

    for (idx = 0; idx < height; idx++)
    {
        memcpy(dst, Y_Cur, width);
        dst += dst_stride;
        Y_Cur += edged_width;
    }

    for (idx = 0; idx < height >> 1; idx++)
    {
        memcpy(dst, U_Cur, width2);
        dst += dst_stride2;
        U_Cur += edged_width2;
    }

    for (idx = 0; idx < height >> 1; idx++)
    {
        memcpy(dst, V_Cur, width2);
        dst += dst_stride2;
        V_Cur += edged_width2;

    }

    return 0;
}
