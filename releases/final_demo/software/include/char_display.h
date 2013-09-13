#ifndef __CHAR_DISPLAY_H_
#define __CHAR_DISPLAY_H_

#include "altera_up_avalon_character_lcd.h"
#include "global.h"

#define LCD_ROW_ONE	0
#define LCD_ROW_TWO	1

extern alt_up_character_lcd_dev* LCD_port;
extern int LCD_initialized;

// Initalize the LCD
// Call before using other functions
int char_display_init ();

void char_display_clear ();

// Write a null terminated character string to the LCD
// row: LCD_ROW_ONE or LCD_ROW_TWO
// start_pos: 0 to 15
void char_display_write (int row, int start_pos, const char *ptr);

// Makes the cursor not display on the board
void char_display_hide_cursor ();

// Display Discotective Title
void char_display_title ();

void char_display_note_info(stems_t* note);


#endif
