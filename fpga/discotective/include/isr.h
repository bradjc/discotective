#ifndef __ISR_H_
#define __ISR_H_

#include "system.h"
#include "alt_types.h"

#define BUTTON_ISR_NUM	1

void ISR_button (void* context, alt_u32 id);


#endif
