#include <stdlib.h>
#include <stdio.h>
#include "mem_align.h"

void   *
xvid_malloc(size_t size, uint8 alignment)
{
    return (uint8 *) malloc(size);
}

void
xvid_free(void *mem_ptr)
{
    free(mem_ptr);
}
