#include "char_display.h"
#include "altera_up_avalon_character_lcd.h"
#include "global.h"

int LCD_initialized = 0;
alt_up_character_lcd_dev* LCD_port;

int char_display_init () {
	if (!LCD_initialized) {
		LCD_port = alt_up_character_lcd_open_dev("/dev/character_lcd_0");
		if (LCD_port != NULL) {
			LCD_initialized = 1;
			// clear it
			alt_up_character_lcd_init(LCD_port);
		}
	}
	return LCD_initialized;
}

void char_display_clear () {
	if (!char_display_init()) return;

	alt_up_character_lcd_init(LCD_port);
}

void char_display_write (int row, int start_pos, const char *ptr) {
	if (!char_display_init()) return;
	if (row != LCD_ROW_ONE && row != LCD_ROW_TWO) return;
	if (start_pos < 0 || start_pos > 15) return;

	alt_up_character_lcd_set_cursor_pos(LCD_port, start_pos, row);
	alt_up_character_lcd_string(LCD_port, ptr);
}

void char_display_hide_cursor () {
	if (!char_display_init()) return;

	alt_up_character_lcd_cursor_off(LCD_port);
}

void char_display_title () {
	// Display interesting things on the LCD
	char_display_write(LCD_ROW_ONE, 0, "The Discotective");
	char_display_write(LCD_ROW_TWO, 1, "Music -> Sound");
	char_display_hide_cursor();
}

void char_display_note_info (stems_t* note) {
	char midiVal[20];
	char dur[20];

	sprintf(midiVal, "midi val:%d", note->midi + note->mod);
	sprintf(dur, "duration: %d", note->duration);
	char_display_write(LCD_ROW_ONE, 0, midiVal);
	char_display_write(LCD_ROW_TWO, 1, dur);
	char_display_hide_cursor();
}
