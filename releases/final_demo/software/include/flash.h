#ifndef FLASH_H_
#define FLASH_H_

#include "global.h"
#include <stdint.h>

#define FLASH_IMAGE1 0x400000
#define FLASH_IMAGE2 0x4a0000
#define FLASH_IMAGE3 0xb400000

void write_image_to_flash (image16_t* image, uint32_t location);

void read_image_from_flash(image16_t* image,uint32_t location_in_flash);

#endif
