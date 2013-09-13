#ifndef PLATFORM_SPECIFIC_H_
#define PLATFORM_SPECIFIC_H_

#include "global.h"


void disco_log (const char *fmt, ...);
void disco_log_nol (const char *fmt, ...);

void display_image (uint8_t *data, uint16_t height, uint16_t width);

void trigger_error ();

void createAudioFile(uint8_t* data, uint32_t length);

void playAudioFile(const char* fileName);

void write_file (uint8_t* data, uint32_t length, char* filename);

#endif
