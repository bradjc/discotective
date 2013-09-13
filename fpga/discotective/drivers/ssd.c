#include "ssd.h"
#include "altera_up_avalon_parallel_port.h"


int SSD_initialized = 0;
alt_up_parallel_port_dev* SSD_parallel_port0;
alt_up_parallel_port_dev* SSD_parallel_port1;

// active high
int ssd_segs[15];


int ssd_init () {
	if (!SSD_initialized) {
		SSD_parallel_port0 = alt_up_parallel_port_open_dev("/dev/seven_seg_3_0");
		SSD_parallel_port1 = alt_up_parallel_port_open_dev("/dev/seven_seg_7_4");
		if (SSD_parallel_port0 != NULL || SSD_parallel_port1 != NULL) {
			SSD_initialized = 1;
			alt_up_parallel_port_set_all_bits_to_output(SSD_parallel_port0);
			alt_up_parallel_port_set_all_bits_to_output(SSD_parallel_port1);
			ssd_segs[0]		= 0x3F;
			ssd_segs[1]		= 0x06;
			ssd_segs[2]		= 0x5B;
			ssd_segs[3]		= 0x4F;
			ssd_segs[4]		= 0x66;
			ssd_segs[5]		= 0x6D;
			ssd_segs[6]		= 0x7D;
			ssd_segs[7]		= 0x07;
			ssd_segs[8]		= 0x7F;
			ssd_segs[9]		= 0x67;
			ssd_segs[10]	= 0x77;
			ssd_segs[11]	= 0x7C;
			ssd_segs[12]	= 0x39;
			ssd_segs[13]	= 0x5E;
			ssd_segs[14]	= 0x79;
			ssd_segs[15]	= 0x71;
		}
	}
	return SSD_initialized;
}

void ssd_write_digit (int location, int value) {
	unsigned int data;
	alt_up_parallel_port_dev* current_SDD_port;
	
	if (!ssd_init()) return;
	if (location < 0 || location > 7) return;
	if (value < 0 || value > 15) return;

	// sort out which bank we want
	if (location < 4) {
		current_SDD_port = SSD_parallel_port0;
	} else {
		current_SDD_port = SSD_parallel_port1;
		location -= 4;
	}

	// read data
	data = alt_up_parallel_port_read_data(current_SDD_port);
	// clear out the bits of the location we want to write
	data &= ~(0xFF << (location * 8));
	// write the proper segments
	data |= (ssd_segs[value & 0xF] << (location * 8));
	// if dot was desired add that bit
	alt_up_parallel_port_write_data(current_SDD_port, data);
}

void ssd_write_value (int value) {
	unsigned int data;
	int digit1, digit2, digit3, digit4;

	if (!ssd_init()) return;

	digit1 = ssd_segs[(value & 0xF)];
	digit2 = ssd_segs[((value >> 4) & 0xF)];
	digit3 = ssd_segs[((value >> 8) & 0xF)];
	digit4 = ssd_segs[((value >> 12) & 0xF)];
	
	data = (digit4 << 24) | (digit3 << 16) | (digit2 << 8) | digit1;
	alt_up_parallel_port_write_data(SSD_parallel_port0, data);

	digit1 = ssd_segs[((value >> 16) & 0xF)];
	digit2 = ssd_segs[((value >> 20) & 0xF)];
	digit3 = ssd_segs[((value >> 24) & 0xF)];
	digit4 = ssd_segs[((value >> 28) & 0xF)];

	data = (digit4 << 24) | (digit3 << 16) | (digit2 << 8) | digit1;
	alt_up_parallel_port_write_data(SSD_parallel_port1, data);

}

void ssd_clear_all () {
	if (!ssd_init()) return;
	
	alt_up_parallel_port_write_data(SSD_parallel_port0, 0xFFFFFFFF);
	alt_up_parallel_port_write_data(SSD_parallel_port1, 0xFFFFFFFF);
}
