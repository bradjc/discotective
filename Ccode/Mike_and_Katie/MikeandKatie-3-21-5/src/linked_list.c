
#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

linked_list* create_linked_list()
{
             linked_list* l_list;
             
             l_list=malloc(sizeof(linked_list));
             l_list->head=NULL;
             l_list->tail=NULL;
             l_list->length=0;
             return l_list;
}

uint8_t is_list_empty(linked_list* l_list){
        if(l_list->head) return 0;
        else return 1;
}

void push_top(linked_list* l_list, void* new_element)
{
     linked_element* el;
     el=malloc(sizeof(linked_element));
     el->data=new_element;
     el->prev=NULL;/*next goes up, prev goes down*/
     el->next=l_list->head;
     if (is_list_empty(l_list)){
        l_list->head=el;
        l_list->tail=el;
     }
     else{                             
          (l_list->head)->prev=el;
          l_list->head=el;
     }
     (l_list->length)++;
}

void push_bottom(linked_list* l_list, void* new_element)
{
     linked_element* el;
     el=malloc(sizeof(linked_element));
     el->data=new_element;
     el->next=NULL;/*next goes up, prev goes down*/
     el->prev=l_list->tail;
     if (is_list_empty(l_list)==1){
        l_list->head=el;
        l_list->tail=el;
     }
     else{ 
         (l_list->tail)->next=el;
         l_list->tail=el;
     }
     (l_list->length)++;
}

void delete_list(linked_list* l_list)
{
     void* var;
     while (l_list->head){
           var=pop_top(l_list);
           free(var);
     }
     free(l_list);
}                        

void* pop_top(linked_list* l_list)
{
      void * val;
      linked_element* victim;
      
      victim=l_list->head;
      val=(l_list->head)->data;
      l_list->head=victim->next;
      
      if (l_list->head)
         (l_list->head)->prev=NULL;
      else
          (l_list->tail)=NULL;
      free(victim);
      (l_list->length)--;
      return val;
}
      

void* pop_bottom(linked_list* l_list)
{
      void * val;
      linked_element* victim;
      
      victim=l_list->tail;
      val=(l_list->tail)->data;
      l_list->tail=victim->prev;
      
      if (l_list->tail)
         (l_list->tail)->next=NULL;
      else
          (l_list->head)=NULL;
      free(victim);
      (l_list->length)--;
      return val;
}

void* getIndexData(linked_list* l_list, uint16_t index){
	void *val;
	linked_element *node_temp1;
	uint16_t i;
	
	if(l_list->head && index<(l_list->length)){
		node_temp1 = l_list->head;
		for(i=0;i<index;i++){
			node_temp1 = node_temp1->next;
		}	
		return (node_temp1->data);
	}
	else{
		printf("error in getIndexData\n");
		return NULL;
	}
}

void deleteIndexData(linked_list* l_list, uint16_t index){
	void *val;
	linked_element *node_temp1;
	uint16_t i;
	
	if(l_list->head && index<(l_list->length)){
		node_temp1 = l_list->head;
		for(i=0;i<index;i++){
			node_temp1 = node_temp1->next;
		}
		if(index==0){
			val=pop_top(l_list);
			free(val);
		}
		else if(index== l_list->length -1){
			val=pop_bottom(l_list);
			free(val);
		}
		else{
			((node_temp1->next)->prev)=(node_temp1->prev);
			((node_temp1->prev)->next)=node_temp1->next;	
			free(node_temp1->data);
			free(node_temp1);
			l_list->length--;
		}
	}
	else printf("Error deleting index in linked list. Ignoring.\n");

}

void linked_list_insert_before_index(linked_list* l_list, uint16_t index, void* new_element){
     linked_element *node_temp1;
     linked_element *new_node;
     uint16_t i;
     if(index<=0) {
              push_top(l_list,new_element);
              return;
     }
     if(index>= l_list->length){
                push_bottom(l_list, new_element);
                return;
     }
     node_temp1=l_list->head;
     for (i=0; i< index-1; i++){
         node_temp1=node_temp1->next;
     }
      
     new_node=malloc(sizeof(linked_element));
     new_node->data=new_element;
     new_node->next=node_temp1->next;
     new_node->prev=node_temp1;
      
     node_temp1->next=new_node;
    ( new_node->next)->prev=new_node;
     (l_list->length)++;
}/*
 linked_element* el;
     el=malloc(sizeof(linked_element));
     el->data=new_element;
     el->next=NULL;//next goes up, prev goes down
     el->prev=l_list->tail;
     if (is_list_empty(l_list)==1){
        l_list->head=el;
        l_list->tail=el;
     }
     else{ 
         (l_list->tail)->next=el;
         l_list->tail=el;
     }
     (l_list->length)++;    */
     
