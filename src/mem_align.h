#ifndef _MEM_ALIGN_H_
#define _MEM_ALIGN_H_

#include "metypes.h"

void   *xvid_malloc(size_t size, uint8 alignment);
void    xvid_free(void *mem_ptr);

#endif /* _MEM_ALIGN_H_ */
