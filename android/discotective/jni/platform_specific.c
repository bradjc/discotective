#include <stdint.h>
#include <stdarg.h>
#include <android/log.h>


void disco_log (const char *fmt, ...) {
	va_list		arg;

	va_start(arg, fmt);
	__android_log_vprint(ANDROID_LOG_DEBUG, "LOG", fmt, arg);
	va_end(arg);
}

void disco_log_nol (const char *fmt, ...) {
	va_list		arg;

	va_start(arg, fmt);
	__android_log_vprint(ANDROID_LOG_DEBUG, "LOG", fmt, arg);
	va_end(arg);
}

void display_image (uint8_t *data, uint16_t height, uint16_t width) {
}

void trigger_error () {
	// do nothing on the android platform
	// this function is designed for debugging
}
