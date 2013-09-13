
int main () {


	volatile int* JTAG_data_ptr;
	volatile int* JTAG_control_ptr;
	
	int jtag_data;
	int jtag_control;
	
	
	JTAG_data_ptr		= (int*) 0x00002020;
	JTAG_control_ptr	= (int*) 0x00002024;
	
	
	while (1) {
		jtag_control = *JTAG_control_ptr;
		
		if (0xFFFF0000 & jtag_control) {
			// there is room in the buffer
			
			// write a Z
			*JTAG_data_ptr = 0x0000805A;
			
		}
		
	}

	return 0;
	
}