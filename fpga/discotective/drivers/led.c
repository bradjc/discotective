#include "led.h"
#include "altera_up_avalon_parallel_port.h"

int LED_initialized = 0;
alt_up_parallel_port_dev* LED_parallel_port;

int led_init () {
	if (!LED_initialized) {
		LED_parallel_port = alt_up_parallel_port_open_dev("/dev/red_leds");
		if (LED_parallel_port != NULL) {
			LED_initialized = 1;
			alt_up_parallel_port_set_all_bits_to_output(LED_parallel_port);
			// clear
			alt_up_parallel_port_write_data(LED_parallel_port, 0x0);
		}
	}
	return LED_initialized;
}

void led_clear () {
	if (!led_init()) return;

	alt_up_parallel_port_write_data(LED_parallel_port, 0x0);
}

void led_write (unsigned data) {
	if (!led_init()) return;

	alt_up_parallel_port_write_data(LED_parallel_port, (data & 0x3FFFF));
}

void led_turn_on (int led_num) {
	unsigned int data;

	if (!led_init()) return;
	if (led_num < 0 || led_num > 17) return;

	data = alt_up_parallel_port_read_data(LED_parallel_port);

	data |= (0x1 << led_num);

	alt_up_parallel_port_write_data(LED_parallel_port, data);
}

void led_turn_off (int led_num) {
	unsigned int data;

	if (!led_init()) return;
	if (led_num < 0 || led_num > 17) return;

	data = alt_up_parallel_port_read_data(LED_parallel_port);

	data &= ~(0x1 << led_num);

	alt_up_parallel_port_write_data(LED_parallel_port, data);
}
