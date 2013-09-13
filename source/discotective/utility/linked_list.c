#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

linked_list* linked_list_create () {
	linked_list*	l_list;

	l_list	= (linked_list*) malloc(sizeof(linked_list));

	if (l_list == NULL) linked_list_create_fail();

	l_list->head	= NULL;
	l_list->tail	= NULL;
	l_list->length	= 0;
	return l_list;
}

void linked_list_delete (linked_list* l_list) {
	void*	var;
	while (l_list->head) {
		var	= linked_list_pop_top(l_list);
		free(var);
	}
	free(l_list);
}

uint8_t linked_list_is_empty (const linked_list* l_list) {
	if (l_list->head) return 0;
	return 1;
}

void linked_list_push_top (linked_list* l_list, void** new_element) {
	linked_list_push(l_list, new_element, 0);
}

void linked_list_push_bottom (linked_list* l_list, void** new_element) {
	linked_list_push(l_list, new_element, 1);
}

// general push function, goes on top if bottom==0
void linked_list_push (linked_list* l_list, void** new_element, uint8_t bottom) {
	linked_element*	el;

	el	= (linked_element*) malloc(sizeof(linked_element));

	if (el == NULL) linked_list_create_fail();

	// setup new element
	el->data	= *new_element;
	if (bottom) {
		el->next	= NULL;
		el->prev	= l_list->tail;
	} else {
		el->next	= l_list->head;
		el->prev	= NULL;
	}

	// add new element to the linked list
	if (linked_list_is_empty(l_list)) {
		l_list->head	= el;
		l_list->tail	= el;
	} else {
		if (bottom) {
			(l_list->tail)->next	= el;
			l_list->tail			= el;
		} else {
			(l_list->head)->prev	= el;
			l_list->head			= el;
		}
	}
	l_list->length++;

	// make the function that inserted this no longer own the added element
	*new_element	= NULL;
}

void linked_list_clear_list (linked_list* l_list) {
	void*	var;
	while (l_list->head) {
		var	= linked_list_pop_top(l_list);
		free(var);
	}
	l_list->head	= NULL;
	l_list->tail	= NULL;
	l_list->length	= 0;
}   

void* linked_list_pop_top (linked_list* l_list) {
	void*			val;
	linked_element*	victim;

	victim			= l_list->head;
	val				= (l_list->head)->data;
	l_list->head	= victim->next;

	if (l_list->head) {
		(l_list->head)->prev	= NULL;
	} else {
		l_list->tail			= NULL;
	}
	free(victim);
	l_list->length--;
	return val;
}
      

void* linked_list_pop_bottom (linked_list* l_list) {
	void*			val;
	linked_element*	victim;

	victim			= l_list->tail;
	val				= (l_list->tail)->data;
	l_list->tail	= victim->prev;

	if (l_list->tail) {
		(l_list->tail)->next	= NULL;
	} else {
		l_list->head			= NULL;
	}
	free(victim);
	l_list->length--;
	return val;
}

void linked_list_move (linked_list* src, linked_list* dest) {
	void*	tmp;

	while (!linked_list_is_empty(src)) {
		tmp	= linked_list_pop_top(src);
		linked_list_push_bottom(dest, (void**) &tmp);
	}
}

void* linked_list_getIndexData (const linked_list* l_list, uint16_t index) {
	linked_element*	node_temp1;
	uint16_t		i;

	if (l_list->head && index < l_list->length) {
		node_temp1	= l_list->head;
		for (i=0; i<index; i++) {
			node_temp1	= node_temp1->next;
		}
		return node_temp1->data;
	} else {
		printf("error in getIndexData\n");
		return NULL;
	}
}

void linked_list_deleteIndexData (linked_list* l_list, uint16_t index) {
	void*			val;
	linked_element*	node_temp1;
	uint16_t		i;

	if (l_list->head && index < l_list->length) {
		node_temp1 = l_list->head;
		for(i=0; i<index; i++){
			node_temp1 = node_temp1->next;
		}
		if (index==0) {
			val	= linked_list_pop_top(l_list);
			free(val);
		} else if (index == l_list->length-1) {
			val	= linked_list_pop_bottom(l_list);
			free(val);
		} else {
			((node_temp1->next)->prev)	= node_temp1->prev;
			((node_temp1->prev)->next)	= node_temp1->next;
			free(node_temp1->data);
			free(node_temp1);
			l_list->length--;
		}
	} else {
		printf("Error deleting index in linked list. Ignoring.\n");
	}
}


linked_list* linked_list_group (const flex_array_t* in, uint16_t space) {
	linked_list*	list;

	list	= linked_list_create();
	linked_list_group_help(list, in, space);
	return list;
}

linked_list* linked_list_group_indices (const flex_array_t* in, uint16_t space) {
	linked_list*	list;
	list	= linked_list_create();
	linked_list_group_help_indices(list, in, space);
	return list;
}

void linked_list_fill_group_indices (linked_list *list, const flex_array_t* in, uint16_t space) {
	if (!list) return;
	if (!linked_list_is_empty(list)) return;
	linked_list_group_help_indices(list, in, space);
}

void linked_list_group_help_indices (linked_list * stack, const flex_array_t* in, uint16_t space) {
//	'in' is ungrouped array of locations
//	'space' is how far apart two objects must be to be considered part of
//	different objects
//
//
//	in = [1 2 4 5 6 10]
//	result = [1  2 (start end indices)
//		   4  6
//		   10 10

	uint16_t	i, xbegin, xend;
	int16_t*	array;

	if (in->length<1) return;

	i		= 1;
	xbegin	= 0;
	xend	= 0;
	while (1) {
		while (1) {
			if (xend == (in->length)-1) {
				array		= (int16_t*) malloc(2*sizeof(int16_t));
				array[0]	= xbegin;
				array[1]	= xend;
				linked_list_push_bottom(stack, (void**) &array);
				return;
			}
			if (in->data[xend+1] > (in->data[xend] + space)) {
				array		= (int16_t*) malloc(2*sizeof(int16_t));
				array[0]	= xbegin;
				array[1]	= xend;
				linked_list_push_bottom(stack, (void**) &array);
				xbegin		= xend + 1;
				xend++;
				i++;
				if (xbegin > in->length) {
					return;
				}
				break;
			}

			xend++;
		}
	}
}

void linked_list_group_help (linked_list *stack, const flex_array_t* in, uint16_t space) {
//	'in' is ungrouped array of locations
//	'space' is how far apart two objects must be to be considered part of
//	different objects
//
//	in = [1 2 4 5 6 10]
//	result = [1  2 (start end indices)
//		   4  6
//		   10 10

	uint16_t	i;
	uint16_t	xbegin, xend;
	int16_t*	array;

	if (in->length < 1) return;

	i		= 1;
	xbegin	= 0;
	xend	= 0;
	while (1) {
		while (1) {
			if (xend == (in->length)-1) {
				array		= (int16_t*) malloc(2*sizeof(int16_t));
				array[0]	= in->data[xbegin];
				array[1]	= in->data[xend];
				linked_list_push_bottom(stack, (void**) &array);
				return;
			}
			if (in->data[xend+1] > (in->data[xend] + space)) {
				/*result(i,:) = in(xbegin:xend);*/
				array		= (int16_t*) malloc(2*sizeof(int16_t));
				array[0]	= in->data[xbegin];
				array[1]	= in->data[xend];
				linked_list_push_bottom(stack, (void**) &array);
				xbegin = xend + 1;
				xend++;
				i++;
				if (xbegin > in->length){
					return;
				}
				break;
			}

			xend ++;
		}
	}
}

void linked_list_insert_before_index (linked_list* l_list, uint16_t index, void** new_element) {
	linked_element	*node_temp1;
	linked_element	*new_node;
	uint16_t		i;

	if (index <= 0) {
		linked_list_push_top(l_list, new_element);
		return;
	}

	if (index >= l_list->length) {
		linked_list_push_bottom(l_list, new_element);
		return;
	}

	node_temp1 = l_list->head;
	for (i=0; i<index-1; i++) {
		node_temp1 = node_temp1->next;
	}

	new_node		= (linked_element*) malloc(sizeof(linked_element));
	new_node->data	= *new_element;
	new_node->next	= node_temp1->next;
	new_node->prev	= node_temp1;

	node_temp1->next		= new_node;
	(new_node->next)->prev	= new_node;
	l_list->length++;

	*new_element	= NULL;
}
