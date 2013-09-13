#ifndef LINKED_LIST_H
#define LINKED_LIST_H
#include <stdint.h>
#include "flex_array.h"

typedef struct linked_data{
	void *data;
	struct linked_data *next;
	struct linked_data *prev;
} linked_element;

typedef struct linked_list_struct{
	linked_element *head;
	linked_element *tail;
	uint16_t length;
} linked_list;


linked_list* linked_list_create ();

uint8_t linked_list_is_empty (linked_list* l_list);

void linked_list_push_top (linked_list* l_list, void* new_element);

void linked_list_push_bottom (linked_list* l_list, void* new_element);

void linked_list_delete_list (linked_list* l_list);

void* linked_list_pop_top (linked_list* l_list);

void* linked_list_pop_bottom (linked_list* l_list);

void* linked_list_getIndexData (linked_list* l_list, uint16_t index);

void linked_list_deleteIndexData (linked_list* l_list, uint16_t index);

linked_list* linked_list_group (const flex_array_t* in, uint16_t space);

linked_list* linked_list_group_indices (const flex_array_t* in, uint16_t space);

void linked_list_fill_group_indices (linked_list *list, const flex_array_t* in, uint16_t space);

void linked_list_group_help_indices (linked_list * stack, const flex_array_t* in, uint16_t space);

void linked_list_group_help (linked_list* stack, const flex_array_t* in, uint16_t space);

void linked_list_move (linked_list* src, linked_list* dest);

void linked_list_insert_before_index (linked_list* l_list, uint16_t index, void* new_element);

#endif
