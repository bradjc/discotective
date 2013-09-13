#ifndef RUN_H
#define RUN_H

#include <stdint.h>
#include "global.h"
#include "linked_list.h"

linked_list* run (uint8_t* rgba_img, uint16_t height, uint16_t width);

#endif