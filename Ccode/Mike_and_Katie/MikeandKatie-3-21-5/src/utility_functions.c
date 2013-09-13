#include "utility_functions.h"
#include "linked_list.h"
#include "image_data.h"
#include <stdio.h>

/* begin helper functions not to be used outside this file*/

void  group_help(linked_list * stack,const flex_array_t* in, uint16_t space);
void  group_help_indices(linked_list * stack,const flex_array_t* in, uint16_t space);

/*Helper functions: Finds the indices of elements in the flex array with respect to some operator and some threshold*/
flex_array_t* find_greater(const flex_array_t *array, float threshold);
flex_array_t* find_less(const flex_array_t *array, float threshold);
flex_array_t* find_equal(const flex_array_t *array, float threshold);
flex_array_t* find_greater_equal(const flex_array_t *array, float threshold);
flex_array_t* find_less_equal(const flex_array_t *array, float threshold);
flex_array_t* find_not_equal(const flex_array_t *array, float threshold);
/*end helper functions*/

float max(float a, float b){
	if(a>b){
		return a;
	}
	else{
		return b;
	}
}

int16_t int_abs(int16_t  input){
        if (input >= 0) return input;
        return (-1)*input;
}

float min(float a, float b){
	if(a<b){
		return a;
	}
	else{
		return b;
	}
}

flex_array_t* make_flex_array(uint16_t length){
              uint16_t i;
              flex_array_t* proj;
              if(length==0) return NULL;
              proj=malloc(sizeof(flex_array_t));
              proj->data=malloc(length*sizeof(int16_t));
              proj->length=length;
              for (i=0;i<length;i++){
                  proj->data[i]=0;
              }
              return proj;
}

void delete_flex_array(flex_array_t* proj){
     if(proj){
              if(proj->data){
                  free(proj->data);
                  proj->data=NULL;
              }
              free(proj);
              proj=NULL;
     }
}

void delete_staff_info(staff_info *staff)
{
     if(staff){
               if ( staff->staff_lines){
                  multifree(staff->staff_lines,2);
                  staff->staff_lines=NULL;
               }
               if ( staff->staff_bounds){
                  multifree(staff->staff_bounds,2);
                  staff->staff_bounds=NULL;
               }
               free(staff);
               staff=NULL;
     }
}
                  
void delete_params(params* p){
     if(p){
           free(p);
           p=NULL;
     }
}    

int16_t max_array(const flex_array_t *proj){
        int16_t maximum;
         uint16_t i;
         if(proj->length<1)return -32768;
         maximum=proj->data[0];
         for (i=0;i<(proj->length);i++){
             if((proj->data[i])>maximum) maximum=(proj->data[i]);
         }
         return maximum;
}
                                      
flex_array_t* find_greater(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])>threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])>threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              
              return found_array;
}

flex_array_t* find_less(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])<threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])<threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}

flex_array_t* find_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])==threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])==threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_greater_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])>=threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])>=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_less_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])<=threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])<=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find_not_equal(const flex_array_t *array, float threshold){
              uint16_t length=0;
              flex_array_t *found_array;
              uint16_t i,j;
              for (i=0;i<(array->length);i++){
                  if ((array->data[i])!=threshold) length++;
              }
              found_array=make_flex_array(length);
              j=0;
              for (i=0;i<(array->length);i++){
                  if  ((array->data[i])!=threshold){
                      found_array->data[j]=i;
                      j++;
                  }                                  
              }
              return found_array;
}
flex_array_t* find(const flex_array_t *array, float threshold, find_flags flag)
{
                  if(flag==greater) return find_greater(array,threshold);
                  else if(flag==less) return find_less(array,threshold);
                  else if(flag==greater_equal) return find_greater_equal(array,threshold);
                  else if(flag==less_equal) return find_less_equal(array,threshold);
                  else if(flag==equal) return find_equal(array,threshold);
                  else return find_not_equal(array,threshold);
}

flex_array_t* diff(const flex_array_t *array)
{
              
              uint16_t length,i;
              flex_array_t* difference;
              if(array->length<2)return NULL;
              length=(array->length)-1;
              
              difference=make_flex_array(length);
              for (i=0;i<length;i++){
                  difference->data[i]=(array->data[i+1])-(array->data[i]);
              }
              return difference;
}

flex_array_t* abs_diff(const flex_array_t *array)
{
              int16_t new_diff;
              
              uint16_t length,i;
              flex_array_t* difference;
              if(array->length<2)return NULL;
              length=(array->length)-1;
              
              difference=make_flex_array(length);
              for (i=0;i<length;i++){
                  new_diff=(array->data[i+1])-(array->data[i]);
                  if (new_diff<0) new_diff*=(-1);
                  difference->data[i]=new_diff;
              }
              return difference;
}

int16_t sum(const flex_array_t *array)
{
        int16_t sum_var;
        uint16_t i;
        sum_var=0;
        for (i=0; i<(array->length);i++){
            sum_var+=(array->data[i]);
        }
        return sum_var;
}

int16_t rounded_mean(const flex_array_t *array)
{
        uint16_t length;
        int16_t  sum_var;
        length=array->length;
        sum_var=sum(array);
        sum_var+=length>>1;
        return sum_var/length;
}     
/*This function allows the computation of the median without sorting.
It has worst case complexity O(n^2) which is the same as quicksort, but since 
in most cases the mean and median will be nearby  it has average complexity O(n),
 with a somewhat obnoxious constant factor, but still pretty good*/
int16_t median(const flex_array_t *array)
{
        
        flex_array_t* dummy;
        uint16_t i;
        int16_t return_val;
        if(array->length==0) return -32768;/*error*/
        
        dummy=make_flex_array(array->length);
        for (i=0;i<(array->length);i++){
            dummy->data[i]=array->data[i];
        }
        flex_mergesort(dummy,0,dummy->length);
        if((dummy->length)%2) return_val= dummy->data[(dummy->length)/2];
        else return_val=(dummy->data[(dummy->length)/2]+  dummy->data[(dummy->length)/2-1]+1)/2;
        delete_flex_array(dummy);
        return return_val;     
        
         
}

flex_array_t* sub_array(const flex_array_t *array, uint16_t begin, uint16_t end)
{
              flex_array_t *new_array;
              uint16_t i;
              if(end<begin || array==NULL) return NULL;
              if(end>= (array->length)  )end= (array->length) -1;
              new_array=  make_flex_array(end+1-begin);
              for (i=begin;i<=end;i++){
                  new_array->data[i-begin]=array->data[i];
              }
              return new_array;
}

flex_array_t* minus(const flex_array_t *array, int16_t number)
{
              flex_array_t *new_array;
              uint16_t i;
              new_array=make_flex_array(array->length);
              for (i=0;i<array->length;i++){
                  new_array->data[i]=array->data[i]-number;
              }
              return new_array;
}
 
flex_array_t* minus_array(const flex_array_t *array, const flex_array_t *array2)
{
              
              flex_array_t *new_array;
              uint16_t i;
              if(array->length!=array2->length)return NULL;
              new_array=make_flex_array(array->length);
              for (i=0;i<array->length;i++){
                  new_array->data[i]=array->data[i]-array2->data[i];
              }
              return new_array;
} 


flex_array_t* kill_array_indices(flex_array_t *array, const flex_array_t *indices)
{
              uint16_t i,end,length,j;
              flex_array_t *new_array;
              length=0;
              j=0;
              end=((array->length) < (indices->length))?(array->length):(indices->length);
              for (i=0;i<end;i++){
                  if((indices->data[i])==0){
			 length++;
			}
              }
              new_array=make_flex_array(length);
              for (i=0;i<length;i++){
                  if (!(indices->data[i])){
                     new_array->data[j]=array->data[i];
                     j++;
                  }
              }
              delete_flex_array(array);
              return new_array;
}   

flex_array_t* get_line_at_index(const staff_info *staff,uint8_t index)
{
              uint8_t i;
              flex_array_t* new_array;
              new_array=make_flex_array(staff->number_staffs);
              for (i=0;i<(staff->number_staffs);i++){
                  new_array->data[i]=staff->staff_lines[index][i];
              }
              return new_array;
}                                                 



flex_array_t* hist(const flex_array_t *array)
{
              /*Var Declarations*/
              flex_array_t* output_array;
              int16_t max_var;
              uint16_t i;
              uint16_t index;
              /*End Var Declarations*/
              
              max_var=max_array(array)+1;
              if(max_var<1) return NULL;/*for this values must be non-negative*/
              output_array=make_flex_array(max_var);
              
              for (i=0;i<max_var;i++){
                  output_array->data[i]=0;
              }
              for (i=0;i<array->length;i++){
                  index=array->data[i];
                  output_array->data[index]++;
              }
              return output_array;
}

uint16_t index_of_max(const flex_array_t *array)
{
         /*Var Declarations*/
         int16_t maximum;
         uint16_t index;
         uint16_t i;
         /*End Var Declarations*/
         if(array->length<1)return 0xFFFF;
         maximum=array->data[0];
         index=0;
         for (i=0;i<(array->length);i++){
             if ((array->data[i])>maximum){
                maximum=(array->data[i]);
                index=i;
             }
         }
         return index;
}

flex_array_t* array_ones(uint16_t length)
{
              flex_array_t* new_array;
              uint16_t i;
              
              new_array=make_flex_array( length); 
              for (i=0;i<length;i++){
                  new_array->data[i]=1;
              }
              return new_array;
}

flex_array_t* filter(const flex_array_t *B,const flex_array_t *A,const flex_array_t *X)
{
              flex_array_t* Y;
              uint16_t i,j;
              
              Y=make_flex_array(X->length);
              for (i=0;i<(Y->length);i++){
                  j=0;
                  Y->data[i]=0;
                  while(j<(B->length)&&i>=j){
                      Y->data[i]=(Y->data[i])+(B->data[j])*( X->data[i-j]);
                      j++;
                  }
                  j=1;
                  while(j<(A->length)&&i>=j){                       
                      Y->data[i]=(Y->data[i])-(A->data[j])*( Y->data[i-j]);
                      j++;
                  }
                  Y->data[i]=((Y->data[i])+(A->data[0])/2)/(A->data[0]);
              }  
              return Y;
}        

void fill_group(linked_list * list,const flex_array_t* in, uint16_t space){
             if(!list) return;
             if(!is_list_empty(list)) return;
             group_help(list,in,space);
             return;
}

linked_list* group(const flex_array_t* in, uint16_t space){	
             	linked_list* list;
		        list = create_linked_list();
             	group_help(list,in,space);
             	return list;
}

void fill_group_indices(linked_list *list, const flex_array_t* in, uint16_t space){
             if(!list) return;
             if(!is_list_empty(list)) return;
             group_help_indices(list,in,space);
             return;
}             
void  group_help_indices(linked_list * stack,const flex_array_t* in, uint16_t space)
    {
    /* 'in' is ungrouped array of locations
     'space' is how far apart two objects must be to be considered part of
     different objects
    

     in = [1 2 4 5 6 10]
     result = [1  2 (start end indices)
               4  6
               10 10

    
    Var Declarations*/
    uint16_t i,xbegin,xend;
    int16_t* array;
    /*End Var Declarations*/
    
    if (in->length<1) return;
    
    i = 1;
    xbegin = 0;
    xend = 0;
    while(1){
        while(1){
            if (xend == (in->length)-1){
                array=malloc(2*sizeof(int16_t));
                array[0]=xbegin;
                array[1]=xend;
                push_bottom(stack,array);
                return;
            }
            if (in->data[xend+1] > (in->data[xend] + space)){
                /*result(i,:) = in(xbegin:xend);*/
                array=malloc(2*sizeof(int16_t));
                array[0]=xbegin;
                array[1]=xend;
                push_bottom(stack,array);
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

void  group_help(linked_list * stack,const flex_array_t* in, uint16_t space)
    {
    /* 'in' is ungrouped array of locations
     'space' is how far apart two objects must be to be considered part of
     different objects
    
     in = [1 2 4 5 6 10]
     result = [1  2 (start end indices)
               4  6
               10 10
    
    Var Declarations*/
    uint16_t i,xbegin,xend;
    int16_t* array;
    /*End Var Declarations*/
    
    if (in->length<1) return;
    
    i = 1;
    xbegin = 0;
    xend = 0;
    while(1){
        while(1){
            if (xend == (in->length)-1){
                array=malloc(2*sizeof(int16_t));
                array[0]=in->data[xbegin];
                array[1]=in->data[xend];
                push_bottom(stack,array);
                return;
            }
            if (in->data[xend+1] > (in->data[xend] + space)){
                /*result(i,:) = in(xbegin:xend);*/
                array=malloc(2*sizeof(int16_t));
                array[0]=in->data[xbegin];
                array[1]=in->data[xend];
                push_bottom(stack,array);
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

void flex_merge(flex_array_t* array,uint16_t low,uint16_t high, uint16_t mid)
{
     flex_array_t* temp_array;
     uint16_t i,j,k;
     
     temp_array=make_flex_array(mid+1-low);
     
     i=0;
     j=low;
     while(j<=mid) temp_array->data[i++]=array->data[j++];
     i=0;
     k=low;
     while (k<j && j<=high){
           if(  temp_array->data[i]<=array->data[j]) array->data[k++]=temp_array->data[i++];
           else array->data[k++] =array->data[j++];
     }
     while(k<j) array->data[k++]=temp_array->data[i++];
     delete_flex_array(temp_array);
     return;
}


void flex_mergesort(flex_array_t* array, uint16_t low, uint16_t high)
{
     uint16_t mid;
     if (low<high){
        mid=(low+high)/2;
        flex_mergesort(array,low,mid);
        flex_mergesort(array,mid+1,high);
        flex_merge(array,low,high,mid);
     }
     return;
}

/*flex array of pointers*/
flex_pointer_array_t* make_flex_pointer_array(uint16_t length,uint16_t size_of_element){
              uint16_t i;
              flex_pointer_array_t* proj;
              if(length==0) return NULL;
              proj=malloc(sizeof(flex_pointer_array_t));
              proj->data=malloc(length*size_of_element);
              proj->length=length;
              for (i=0;i<length;i++){
                  proj->data[i]=NULL;
              }
              return proj;
}

void delete_flex_pointer_array(flex_pointer_array_t* proj){
     uint16_t i;
    if(proj){
              if (proj->data){
                 for (i=0;i<(proj->length);i++ ){
                     if(proj->data[i]) free(proj->data[i]);
                 }
                 free(proj->data);            
                 proj->data=NULL;
              }
              free(proj);
              proj=NULL;
     }
}

/* can get up to 2 sections, if don't want second section pass -1 to last two*/
flex_array_t* get_sub_array(const flex_array_t* array, int16_t start1, int16_t end1, int16_t start2, int16_t end2){
              flex_array_t* new_array;
              uint16_t i;
              if(start1==-1) start1=0;
              if(end1==-1) end1+=array->length;
              if (start1<0 ||end1>= array->length || start1>end1){
                           printf("Error(1) in get_sub_array, indices out of bounds\n");
                           exit(1);
              }
              if( start2==-1 || end2==-1) {
                  new_array=make_flex_array(end1+1-start1);
                  for (i=start1; i<=end1; i++){
                      new_array->data[i-start1]=array->data[i];
                  }
              }
              else{
                   if(start2>end2 ||end1>=start2){
                            printf("Error(2) in get_sub_array, indices overlapped\n");
                            exit(1);      
                   }
                   new_array=make_flex_array(end1+2+end2-start1-start2);
                   for (i=start1; i<=end1; i++){
                      new_array->data[i-start1]=array->data[i];
                  }
                  for (i=start2; i<=end2; i++){
                      new_array->data[i+end1+1-start1-start2]=array->data[i];
                  }
              }
              return new_array;
}

void quickSort( uint32_t* a, uint16_t l, uint16_t r)
{
   uint16_t j;

   if( l < r ) 
   {
   	/*divide and conquer*/
       j = partition( a, l, r);
       if(j-1>l) quickSort( a, l, j-1);
       if(j+1<r) quickSort( a, j+1, r);
   }
	
}

uint32_t partition( uint32_t* a, uint16_t l, uint16_t r) {
	uint32_t pivot, t;
	uint16_t i, j;

	pivot = a[l];
	i = l; j = r+1;
		
	while(1)
	{
		do ++i; while( a[i] <= pivot && i <= r );
		do --j; while( a[j] > pivot );
		if( i >= j ) break;
		t = a[i];
		a[i] = a[j]; 
		a[j] = t;
	}
	t = a[l]; 
	a[l] = a[j]; 
	a[j] = t;
	return j;
}
