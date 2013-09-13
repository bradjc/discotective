/* Gaussian Elimination */
#include <math.h>
#include "allocate.h"
#include <stdio.h>

void invertMatrixGauss(float **matrix, int n)
{
float **Imatrix;
int i,count,j;
double ratio,temp;

Imatrix = (float **)multialloc (sizeof (float), 2, n, n);
for(i=0; i<n; i++){
	for(j=0; i<n; j++){
		Imatrix[i][j] = 0;
	}
}
for(i=0; i<n; i++){
	Imatrix[i][i] = 1;
}

/* Gaussian elimination */
for(i=0;i<(n-1);i++){
	for(j=(i+1);j<n;j++){
		ratio = matrix[j][i] / matrix[i][i];
		for(count=i;count<n;count++) {
			matrix[j][count] -= (ratio * matrix[i][count]);
			Imatrix[j][count] -=(ratio* Imatrix[i][count]);
		}
	}
}

/* Back substitution */
/*for(count=i;count<n;count++) {
	Imatrix[n-1][count] = Imatrix[n-1][count]/matrix[n-1][n-1];
}

for(i=(n-2);i>=0;i--){
	temp = b[i];
	for(j=(i+1);j<n;j++){
		temp -= (matrix[i][j] * Imatrix[j]);
	}
	x[i] = temp / matrix[i][i];
}
printf("Answer:\n");
for(i=0;i<n;i++){
	printf("x%d = %lf\n",i,x[i]);
}*/
}