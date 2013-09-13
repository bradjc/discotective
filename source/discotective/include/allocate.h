#ifndef ALLOCATE_H
#define ALLOCATE_H

#include <stdlib.h>

void* get_spc (int num, size_t size);

void* mget_spc (int num, size_t size);

void* multialloc (size_t s, int d, ...);

void multifree (void* r, int d);

#endif
