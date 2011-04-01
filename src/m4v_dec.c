/*
 * m4v_dec.c
 *    -- an mpeg-4 video decoder for HW/SW Co-design, CJT 05-01-2004
 *
 * This is an mpeg-4 simple profile video decoder based on xvid 0.9.
 * The xvid library was redesigned and rewritten quite a bit to fix
 * some conformance issues as well as to simplify the code for easy
 * porting for embedded applications.  Since Xvid is coverred by GPL,
 * the modified source code of the library is still in public domain.
 * You are free to redistribute and use the source code following
 * the GPL guideline.
 *
 * This program is designed for the class "Embedded Firmware and
 * Hardware/Software Co-design,"  Dept. of Computer Science and
 * Information Engineering National Chiao Tung University,
 * 1001 Ta-Hsueh Rd. Hsinchu, 30010, Taiwan
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <network.h>
#include <tftp_support.h>
#include "m4vdec_api.h"
#include "timer.h"
/* Input bitstream file name: this can only be used in */
/*   semi-hosted operation mode.                       */
char   *fname = "./bitstream/foreman_150.m4v";

FILE   *fp;                         /* Input file pointer      */
uint8  *bitbuf;                     /* Input bitstream buffer  */
xint    bitstream_size = 83860;     /* bitstream size in bytes */
uint8  *yuvbuf;                     /* output YCbCr images     */
xint    raw_video_size = 5702400;   /* raw video size in bytes */

int
main(int arc, char *arv[])
{
    DEC_CTRL vdec_obj;
	struct sockaddr_in host;

    xint    frame_number = 0, code;
    xint    frame_size = 0;
	int err;

    /* allocating the data buffers */
    if ((bitbuf = (uint8 *) malloc(bitstream_size)) == NULL)
    {
        printf("Out of memory when allocating 'bitbuf'.\n");
        return 1;
    }
    if ((yuvbuf = (uint8 *) malloc(raw_video_size)) == NULL)
    {
        printf("Out of memory when allocating 'yuvbuf'.\n");
        return 1;
    }

	/* initialize network interface */
	init_all_network_interfaces();
	memset((char *) &host, 0, sizeof(host));
	host.sin_len = sizeof(host);
	host.sin_family = AF_INET;
	host.sin_addr = eth0_bootp_data.bp_siaddr;
	host.sin_port = 0;

	printf("Reading bitstream using tftp...\n");

    /* read video bitstream */
	bitstream_size = tftp_get(fname, &host, bitbuf, bitstream_size, TFTP_OCTET, &err);
	if (bitstream_size == -1)
    {
		printf("File read error. Error code:%d\n", err);
        return 1;
    }
	printf("bitstream_size = %d, err = %d\n", bitstream_size, err);
	
    /* decode video header to retrieve frame size (header < 64 bytes) */
    printf("Initializing decoder ...\n");
    if ((code = m4v_init_decoder(&vdec_obj, bitbuf, 64)) == 0)
    {
        frame_size = (vdec_obj.width * vdec_obj.height * 3) >> 1;
        vdec_obj.image = yuvbuf;
        vdec_obj.stride = vdec_obj.width;
        vdec_obj.bitstream = bitbuf;
        printf("Decoding frames: "); fflush(stdout);
        while (bitstream_size > 0)
        {
            vdec_obj.length = bitstream_size;

            if ((frame_number & 0x0f) == 0)
            {
                printf("%d...", frame_number); fflush(stdout);
            }

            m4v_decode_frame(&vdec_obj);
            vdec_obj.image += frame_size;
            frame_number++;

            /* Move the remaining bytes to the front of memory buffer.    */
            /* You should avoid pointer arithmetics for memory accesses   */
            /* due to portability issues across embedded processors.      */
            bitstream_size -= vdec_obj.length;
            memmove(bitbuf, (bitbuf+vdec_obj.length), bitstream_size);
        }
        printf("\n"); fflush(stdout);

        m4v_free_decoder(&vdec_obj);
    }
    else
    {
        printf("Cannot decode bitstream, code = %d.\n", code);
    }
	
    /* write video bitstream */
    printf("\nWriting decoded YCbCr frames using tftp...\n");
	bitstream_size = tftp_put("output.yuv", &host, yuvbuf, frame_size * frame_number, TFTP_OCTET, &err);
	if (bitstream_size == -1)
    {
		printf("File write error. Error code:%d\n", err);
        return 1;
    }

    printf("Finished decoding.\n");
    return 0;
}
