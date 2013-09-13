#include "platform_specific.h"
#include "global.h"
#include <stdio.h>
#include <stdarg.h>
#include "stb_image_write.h"
#include "image_functions.h"
#include <stdlib.h>


void disco_log (const char *fmt, ...) {
	va_list		arg;

	va_start(arg, fmt);
	vprintf(fmt, arg);
	printf("\n");
	va_end(arg);
}

// print to log with no new line at the end
void disco_log_nol (const char *fmt, ...) {
	va_list		arg;

	va_start(arg, fmt);
	vprintf(fmt, arg);
	va_end(arg);
}

void display_image (uint8_t *data, uint16_t height, uint16_t width) {

	static int		filecount = 0;		// makes each filename unique
	char			filename[100];
	int				err = 0;

	// create the filename
	sprintf(filename, "outimage%d.png", filecount++);

	err = stbi_write_png(filename, width, height, 1, data, width);

	free(data);

	if (!err) {
		printf("error writing png output.\n");
		exit(1);
	}

}

void trigger_error () {
	int a = 8;
	int b = 0;
	int c;

	c = a/b;
}

void write_file (uint8_t* data, uint32_t length, char* filename) {
	FILE *output;
	
	output = fopen(filename, "wb");
	fwrite(data, 1, length, output);
	
	fclose(output);
}

	
