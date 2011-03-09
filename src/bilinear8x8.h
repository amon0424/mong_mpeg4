
#include "mem_transfer.h"

void    halfpel8x8_h(uint8 * dst,
                     uint8 * src, xint stride, xint rounding);

void    halfpel8x8_v(uint8 * dst,
                     uint8 * src, xint stride, xint rounding);

void    halfpel8x8_hv(uint8 * dst,
                      uint8 * src, xint stride, xint rounding);

static __inline void
interpolate8x8_switch(uint8 * cur,
                      uint8 * refn,
                      xint x, xint y,
                      xint dx, xint dy, xint stride, xint rounding)
{
    uint8  *dst, *src;

    dst = cur + y * stride + x;
    switch (((dx & 1) << 1) + (dy & 1)) // ((dx%2)?2:0)+((dy%2)?1:0)
    {
    case 0:
        src = refn + (y + dy / 2) * stride + x + dx / 2;
        transfer8x8_copy(dst, src, stride);
        break;

    case 1:
        src = refn + (y + (dy - 1) / 2) * stride + x + dx / 2;
        halfpel8x8_v(dst, src, stride, rounding);
        break;

    case 2:
        src = refn + (y + dy / 2) * stride + x + (dx - 1) / 2;
        halfpel8x8_h(dst, src, stride, rounding);
        break;

    default:
        src = refn + (y + (dy - 1) / 2) * stride + x + (dx - 1) / 2;
        halfpel8x8_hv(dst, src, stride, rounding);
        break;
    }
}
