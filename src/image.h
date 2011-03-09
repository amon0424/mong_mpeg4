#ifndef _IMAGE_H_
#define _IMAGE_H_

#include "metypes.h"

#define CACHE_LINE  16
#define EDGE_SIZE  32

typedef struct
{
    uint8  *y;
    uint8  *u;
    uint8  *v;
} IMAGE;

void    init_image(uint32 cpu_flags);

int32   image_create(IMAGE * image, uint32 edged_width,
                     uint32 edged_height);
void    image_destroy(IMAGE * image, uint32 edged_width,
                      uint32 edged_height);

void    image_swap(IMAGE * image1, IMAGE * image2);
void    image_copy(IMAGE * image1, IMAGE * image2, uint32 edged_width,
                   uint32 height);
void    image_setedges(IMAGE * image, uint32 edged_width,
                       uint32 edged_height, uint32 width, uint32 height,
                       uint32 interlacing);
void    image_interpolate(const IMAGE * refn, IMAGE * refh,
                          IMAGE * refv, IMAGE * refhv, xint edged_width,
                          xint edged_height, xint rounding);

int     image_input(IMAGE * image, uint32 width, int height,
                    uint32 edged_width, uint8 * src);

int     image_output(IMAGE * image, uint32 width, int height,
                     uint32 edged_width, uint8 * dst,
                     uint32 dst_stride);

#endif /* _IMAGE_H_ */
