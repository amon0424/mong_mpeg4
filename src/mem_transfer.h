#ifndef _MEM_TRANSFER_H
#define _MEM_TRANSFER_H

void    transfer_8to16copy(int16 * const dst, const uint8 * const src,
                           xint stride);
void    transfer_16to8copy(uint8 * const dst, const int16 * const src,
                           xint stride);
void    transfer_8to16sub(int16 * const dct, uint8 * const cur,
                          const uint8 * ref, xint stride);
void    transfer_16to8add(uint8 * const dst, const int16 * const src,
                          xint stride);
void    transfer8x8_copy(uint8 * const dst, const uint8 * const src,
                         xint stride);
#endif /* _MEM_TRANSFER_H_ */
