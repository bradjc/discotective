#include<math.h>
#include "allocate.h"
#include <stdio.h>
#include "preprocessing.h"

/* matrix inversion*/
/* the result is put in B*/
void myMatrixInverse(float **A, int32_t n, float **B){
	float s, t;
	int32_t i,j,k,L;
	
	/******DEFINE IDENTITY MATRIX****/
	for(i=0; i<n; i++){
		for(j=0; j<n; j++){
			B[i][j] = 0;
		}
	}
	for(i=0; i<n; i++){
		B[i][i] = 1;
	}
	
	/***INVERT USING GAUSSIAN ELIMINATION***/
	for(j=0;j<n;j++){
		for(i=j;i<n;i++){
			if(A[i][j] != 0){
				for(k=0;k<n;k++){
					s = A[j][k];
					A[j][k] = A[i][k];
					A[i][k] = s;
	
					s = B[j][k];
					B[j][k] = B[i][k];
					B[i][k] = s;	
				}
				t = 1/A[j][j];	
				for(k=0;k<n;k++){
					A[j][k] = t*A[j][k];
					B[j][k] = t*B[j][k];
				}
				for(L=0;L<n;L++){
					if(L != j){
						t = -A[L][j];
						for(k=0;k<n;k++){
							A[L][k] = A[L][k] + t*A[j][k];
							B[L][k] = B[L][k] + t*B[j][k];
						}
					}
				}		
			}
			break;		
		}
		if(A[i][j] == 0){
			printf("Singular Matrix");
			return;		
		}	
	}
}
