#include "altera_up_avalon_pixel_buffer.h"

int main(void)
{
	alt_up_pixel_buffer_dev * pixel_buf_dev;
	
	// open the Pixel Buffer port
	pixel_buf_dev = alt_up_pixel_buffer_open_dev ("/dev/Pixel_Buffer");
	
	if (pixel_buf_dev == NULL) {
		alt_printf ("Error: could not open pixel buffer device \n");
	} else {
		alt_printf ("Opened pixel buffer device \n");
	}
	
	/* Clear and draw a blue box on the screen */
	alt_up_pixel_buffer_clear_screen (pixel_buf_dev);
	alt_up_pixel_buffer_draw_box (pixel_buf_dev, 0, 0, 319, 239, 0x001F, 0);
}


for (i=0; i<640; i++) {
	
	for (j=0; j<480; j++) {
	
		
