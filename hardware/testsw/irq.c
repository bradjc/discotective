#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "system.h"
/*
static void handle_interrupts (void* context, alt_u32 id) {
	/* cast the context pointer to an integer pointer. *
	volatile int* edge_capture_ptr = (volatile int*) context;
	
	* Read the edge capture register on the button PIO.
	* Store value.
	*
	*edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE);
	/* Write to the edge capture register to reset it. *
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0);
	/* reset interrupt capability for the Button PIO. *
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BUTTON_PIO_BASE, 0xf);
}

The following code shows an example of the code for the main program that registers the ISR with the HAL.
Example: Registering the Button PIO ISR with the HAL


...
/* Declare a global variable to hold the edge capture value. *
volatile int edge_capture;
...

/* Initialize the button_pio. *
static void init_button_pio() {
	/* Recast the edge_capture pointer to match the
	alt_irq_register() function prototype. *
	void* edge_capture_ptr = (void*) &edge_capture;
	/* Enable all 4 button interrupts. *
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(BUTTON_PIO_BASE, 0xf);
	/* Reset the edge capture register. *
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(BUTTON_PIO_BASE, 0x0);
	/* Register the ISR. *
	alt_irq_register(BUTTON_PIO_IRQ, edge_capture_ptr, handle_button_interrupts);
}
*/


#define AVALON_BRIDGE_INTERRUPT_ID

alt_irq_register(AVALON_BRIDGE_INTERRUPT_ID, NULL, handle_bridge_interrupts);

void handle_bridge_interrupts (void* context, alt_u32 id) {
	// do something with this interrupt
}