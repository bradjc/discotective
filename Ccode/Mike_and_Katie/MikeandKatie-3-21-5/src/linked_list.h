#ifndef LINKED_LIST_H
#define LINKED_LIST_H
#include <stdint.h>

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

linked_list* create_linked_list();

uint8_t is_list_empty(linked_list* l_list);

void push_top(linked_list* l_list, void* new_element);

void push_bottom(linked_list* l_list, void* new_element);

void delete_list(linked_list* l_list);

void* pop_top(linked_list* l_list);

void* pop_bottom(linked_list* l_list);

void* getIndexData(linked_list* l_list, uint16_t index);

void deleteIndexData(linked_list* l_list, uint16_t index);

void linked_list_insert_before_index(linked_list* l_list, uint16_t index, void* new_element);


#endif
