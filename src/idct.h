#ifndef _IDCT_H_
#define _IDCT_H_

void    idct_int32_init(void);
void    idct(short *const block);
void    idct_dual(short *const block1, short *const block2);
#endif /* _IDCT_H_ */
