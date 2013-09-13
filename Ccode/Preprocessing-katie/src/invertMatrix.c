#include<math.h>
#include "allocate.h"
#include <stdio.h>

int GetMinor(float **src, float **dest, int row, int col, int order);
double CalcDeterminant( float **mat, int order);

/* matrix inversioon*/
/* the result is put in Y*/
void MatrixInversion(float **A, int order, float **Y)
{   
	float *temp, **minor;
	double det;
	int i, j;
	
    /* get the determinant of a*/
    det = 1.0/CalcDeterminant(A,order);
    printf("det: %f", CalcDeterminant(A,order));

    /* memory allocation*/
    /*temp = (float *)get_spc((order-1)*(order-1), sizeof(float));*/
    /*minor = (float **)multialloc (sizeof (float), 2, order-1, order-1);*/
    
    /*
    float *temp = new float[(order-1)*(order-1)];
    float **minor = new float*[order-1];
    for(i=0;i<order-1;i++)
        minor[i] = temp+(i*(order-1));*/
        
     temp = malloc(sizeof(float) *(order-1)*(order-1));
     minor = malloc(sizeof(float)*(order-1));
 	for(i=0;i<order-1;i++){
	    minor[i] = temp+(i*(order-1));
 	}

    for(j=0;j<order;j++)
    {
        for(i=0;i<order;i++)
        {
            /* get the co-factor (matrix) of A(j,i)*/
            GetMinor(A,minor,j,i,order);
            Y[i][j] = det*CalcDeterminant(minor,order-1);
            printf("%f	", Y[i][j]);
            if( (i+j)%2 == 1)
                Y[i][j] = -Y[i][j];
        }
    }

    /* release memory*/
    /*delete [] minor[0];*/
    
    free(temp);
    free(minor);
    /*multifree(minor,2)*/;
    /*delete [] temp;
    delete [] minor;*/
}

/* calculate the cofactor of element (row,col)*/
int GetMinor(float **src, float **dest, int row, int col, int order)
{
	int colCount, rowCount, i, j;
	
    /* indicate which col and row is being copied to dest*/
    colCount=0,rowCount=0;

    for(i = 0; i < order; i++ )
    {
        if( i != row )
        {
            colCount = 0;
            for(j = 0; j < order; j++ )
            {
                /* when j is not the element*/
                if( j != col )
                {
                    dest[rowCount][colCount] = src[i][j];
                    colCount++;
                }
            }
            rowCount++;
        }
    }

    return 1;
}

/* Calculate the determinant recursively.*/
double CalcDeterminant( float **mat, int order)
{
	float det, **minor;
	int i;
	
    /* order must be >= 0*/
	/* stop the recursion when matrix is a single element*/
    if( order == 1 )
        return mat[0][0];

    /* the determinant value*/
    det = 0;

    /* allocate the cofactor matrix*/
    minor = malloc(sizeof(float)*(order-1));
 	for(i=0;i<order-1;i++){
	   minor[i] = malloc(sizeof(float)*(order-1));
 	}
	    
    /*minor = (float **)multialloc (sizeof (float), 2, order-1, order-1);*/
    /*float **minor;
    minor = new float*[order-1];
    for(int i=0;i<order-1;i++)
        minor[i] = new float[order-1];*/

    for(i = 0; i < order; i++ )
    {
        /* get minor of element (0,i)*/
        GetMinor( mat, minor, 0, i , order);
        /* the recusion is here!*/

        det += (i%2==1?-1.0:1.0) * mat[0][i] * CalcDeterminant(minor,order-1);
        /*det += pow( -1.0, i ) * mat[0][i] * CalcDeterminant( minor,order-1 );*/
    }

    /* release memory*/
    /*multifree(minor,2);*/
    /*for(int i=0;i<order-1;i++)
        delete [] minor[i];
    delete [] minor;*/
    
    for(i=0;i<order-1;i++){
        free(minor[i]);
    }
    free(minor);

    return det;
}
