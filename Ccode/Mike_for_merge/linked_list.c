
#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

linked_list* create_linked_list()
{
             linked_list* l_list;
             
             l_list=malloc(sizeof(linked_list));
             l_list->head=NULL;
             l_list->tail=NULL;
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
     el->next=NULL;/*next goes up, prev goes down*/
     el->prev=l_list->head;
     if (is_list_empty(l_list)){
        l_list->head=el;
        l_list->tail=el;
     }
     else{                             
          (l_list->head)->next=el;
          l_list->head=el;
     }
}

void push_bottom(linked_list* l_list, void* new_element)
{
     linked_element* el;
     el=malloc(sizeof(linked_element));
     el->data=new_element;
     el->prev=NULL;/*next goes up, prev goes down*/
     el->next=l_list->tail;
     if (is_list_empty(l_list)){
        l_list->head=el;
        l_list->tail=el;
     }
     else{ 
         (l_list->tail)->prev=el;
         l_list->tail=el;
     }
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
      l_list->head=victim->prev;
      
      if (l_list->head)
         (l_list->head)->next=NULL;
      else
          (l_list->tail)=NULL;
      free(victim);
      return val;
}
      

void* pop_bottom(linked_list* l_list)
{
      void * val;
      linked_element* victim;
      
      victim=l_list->tail;
      val=(l_list->tail)->data;
      l_list->tail=victim->next;
      
      if (l_list->tail)
         (l_list->tail)->prev=NULL;
      else
          (l_list->head)=NULL;
      free(victim);
      return val;
}
