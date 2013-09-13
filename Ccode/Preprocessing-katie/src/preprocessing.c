#include <math.h>
#include "allocate.h"
#include <stdio.h>
#include "preprocessing.h"

#define LENGTH_STEP_SIZES 7
#define STEPS 25

void binarizeIMG(double **img, int height, int width, double **binIMG, double fudge){
/*Binarize an image using quadratic linear regression
	img = input grayscale image
	height = height of image
	width = width of image
	binIMG = output binarized image
	fudge = fudge value for thresholding */
	
	float **X, *Y, **covMatrix, *intermediate, *W, **covMatrixINV, *Bias;
	int i, j, k, counter;
	int size;
	float sum;
	
	size = (int)height*width;
	
	/*initlize X and Y for quadratic linear regression*/
	X = (float **)multialloc (sizeof (float), 2, (int)size, 6);
	Y = (float *)get_spc((int)size, sizeof(float));
	counter = 0;
	for(i=0; i<height; i++){
		for(j=0; j<width; j++){
			X[counter][0] = 1;
			X[counter][1] = i;
			X[counter][2] = j;
			X[counter][3] = i*j;
			X[counter][4] = i*i;
			X[counter][5] = j*j;
			Y[counter] = img[i][j];
			counter++;
		}
	}
	
	/*solve for the weights W of the quadratic linear regression*/
	intermediate = (float *)get_spc((int)6, sizeof(float));
	for(i=0; i<6; i++){
		sum = 0;
		for(j=0; j<size; j++){
			sum += X[j][i]*Y[j];	
		}
		intermediate[i] = sum;
	}
	
	covMatrix=(float **) multialloc (sizeof (float), 2, 6, 6);
	for(k=0; k<6; k++){
        for(i=0; i<6;i++){
        	sum = 0;
            for(j=0; j<size; j++){
                sum += (X[j][k]*X[j][i]);
            }
            covMatrix[k][i] = sum;
        }
    }
    
    covMatrixINV=(float **) multialloc (sizeof (float), 2, 6, 6);
    myMatrixInverse(covMatrix,6,covMatrixINV);
    
    
    W = (float *)get_spc(6, sizeof(float));
    for(i=0;i<6;i++){
    	sum = 0;
    	for(j=0;j<6;j++){
    		sum += covMatrixINV[i][j]*intermediate[j];
    	}
    	W[i] = sum;
    }
    
    
	/*transform image using determined weights*/
    Bias = (float *)get_spc(size, sizeof(float));
    for(i=0;i<size;i++){
    	sum = 0;
    	for(j=0;j<6;j++){
    		sum += X[i][j]*W[j];
    	}
    	Bias[i] = sum;
    }
    
	/*binarize image...have to change later to make more compressed*/
    counter = 0;
    for(i=0; i<height; i++){
    	for(j=0; j<width; j++){
    		if(img[i][j] - Bias[counter]>fudge){
    			binIMG[i][j] = 0; 
    		}
    		else{
    			binIMG[i][j] = 1;
    		}
    		counter++;
    	}
    }
    
    multifree(X,2); 
	free(Y);
	multifree(covMatrix,2);
	free(intermediate);
	free(W);
	multifree(covMatrixINV,2);
	free(Bias);
    		
}


void tbCrop(double **img, int height, int width, int *crop_top, int *newHeight){
	int *project_Y;
	int i,j,crop_bot,max,h_frac,sum,w_thrsh;
	
	project_Y = (int *)get_spc((int)height, sizeof(int));
	
	for(i=0;i<height;i++){
		sum = 0;
		for(j=0;j<width;j++){
			sum += img[i][j];
		}
		project_Y[i] = sum;
	}
	
	h_frac = (int)(((double)height/8.0)+0.5);
	
	max = -1;
	*crop_top = 0;
	for(i=0;i<h_frac;i++){
		if(project_Y[i]>max){
			max = project_Y[i];
			*crop_top = i;
		}
	}
	
	max = -1;
	crop_bot = height-1;
	for(i=height-1;i>height-h_frac;i--){
		if(project_Y[i]>max){
			max = project_Y[i];
			crop_bot = i;
		}
	}
	w_thrsh = 0.2 * width;

	/*crop out sides with large amounts of black:
	(turn into do-whiles in c)*/
	while (project_Y[*crop_top + 4] > w_thrsh){
	    *crop_top += 4;
	}
	
	while (project_Y[crop_bot - 4] > w_thrsh){
	    crop_bot -= 4;
	}
	
	*newHeight = crop_bot-*crop_top+1;

}

void lrCrop(double **img, int height, int width, int *crop_lef, int *newWidth){
	int *project_X;
	int i,j,crop_rig,max,w_frac,sum,h_thrsh;
	
	project_X = (int *)get_spc((int)width, sizeof(int));
	
	for(j=0;j<width;j++){
		sum = 0;
		for(i=0;i<height;i++){
			sum += img[i][j];
		}
		project_X[j] = sum;
	}
	
	w_frac = 40;
	
	max = -1;
	*crop_lef = 0;
	for(j=0;j<w_frac;j++){
		if(project_X[j]>max){
			max = project_X[j];
			*crop_lef = j;
		}
	}
	
	max = -1;
	crop_rig = width-1;
	for(j=width-1;j>width-w_frac;j--){
		if(project_X[j]>max){
			max = project_X[j];
			crop_rig = j;
		}
	}
	h_thrsh = 0.25 * height;

	/*crop out sides with large amounts of black:
	(turn into do-whiles in c)*/
	while (project_X[*crop_lef + 4] > h_thrsh){
	    *crop_lef += 4;
	}
	
	while (project_X[crop_rig - 4] > h_thrsh){
	    crop_rig -= 4;
	}
	
	*newWidth = crop_rig-*crop_lef+1;

}

double max(double a, double b){
	if(a>b){
		return a;
	}
	else{
		return b;
	}
}

double min(double a, double b){
	if(a<b){
		return a;
	}
	else{
		return b;
	}
}

void ver_deskew(double **img, int h, int w, double **new_img){
	/*
	 this code works by first choosing
	 the points d1, d2, b1, and b2.
	 b2|             |
	   |             |d1
	   |             |
	   |             |
	   |             |b1
	 b2|             |
	   |             |
	 the points are chosen so that the line
	 that connects them passes through many
	 dark pixels (a staffline hopefully).
	
	 next the vanishing point is calculated
	 using algebra, and a simple map is
	 created to adjust for any skew
	*/
	double a1, a2, c1, c2, max_b, mn1_b, mn2_b, mx1_b, mx2_b, stepInterval, stepInterval_b1,
	 	stepInterval_b2, stepInterval_d1, stepInterval_d2, max_d, mn1_d, mn2_d, mx1_d, mx2_d,
		b1, b2, d1, d2, left, right, x_vp, y_vp, y;
	int i, ind, iterD1, iterD2, iterB1, iterB2, s, x, y_test, row, col, old_y;
	double rs, *r;
	int bmax1, bmax2, dmax1, dmax2, sz;
	int stepsizes[LENGTH_STEP_SIZES] = {31, 23, 19, 11, 7, 3, 1};
	double restrictions[LENGTH_STEP_SIZES], b1Iterate[STEPS], b2Iterate[STEPS], d1Iterate[STEPS], d2Iterate[STEPS];
	
	/***SETUP***/
	r = (double *)get_spc((int)w, sizeof(double));
	
	/* x indices:*/
	a1 = w;
	a2 = 1;
	c1 = a1;
	c2 = a2;
	
	/*initial values:*/
	bmax1 = (int)((7.0*(double)h/8.0)+0.5);
	bmax2 = bmax1;
	dmax1 = (int)(((double)h/4.0)+0.5);
	dmax2 = dmax1;

	/*steps:*/
	stepInterval = (0.55 - 0.65)/(LENGTH_STEP_SIZES-1);
	for(i=0; i<LENGTH_STEP_SIZES; i++){
		restrictions[i] = 0.65 + i*stepInterval;
	}
	
	/*OPTIMIZE B1, B2, D1, and D2 points*/
	
	/*iterate step size:*/
	for(ind=0; ind<LENGTH_STEP_SIZES; ind++){
	    
	    /*initial general parameters:*/
	    sz = stepsizes[ind];
	    rs = restrictions[ind];
	    
	    /*initial bottom half parameters:*/
	    max_b = -1;
	    mn1_b = max((double)(rs*h), (double)(bmax1 - (int)((int)STEPS/2.0)*sz));
	    mn2_b = max((double)(rs*h), (double)(bmax2 - (int)((int)STEPS/2.0)*sz));
	    mx1_b = min((double)(h-3), (double)(bmax1 + (int)((int)STEPS/2.0)*sz));
	    mx2_b = min((double)(h-3), (double)(bmax2 + (int)((int)STEPS/2.0)*sz));
	    
	    stepInterval_b1 = (mx1_b-mn1_b)/(STEPS-1);
	    stepInterval_b2 = (mx2_b-mn2_b)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			b1Iterate[i] = (int)(mn1_b + i*stepInterval_b1 +0.5);
			b2Iterate[i] = (int)(mn2_b + i*stepInterval_b2 + 0.5);
		}
		
		for(iterB1=0; iterB1<STEPS; iterB1++){
			b1 = b1Iterate[iterB1];
			for(iterB2=0; iterB2<STEPS; iterB2++){
				b2 = b2Iterate[iterB2];
	    
	            /*sum pixels intersected by line:*/
	            s = 0;
	            for(x=0; x<w; x++){
	            	/* draw line between points: WHY ORIGINALLY x-1???*/
	            	y_test = (int)((((b1-b2)/(a1-a2))*(x-1))+b2+0.5);
	            	s += img[y_test][x];
	            }
	        
	            /*maximize:*/
	            if (s > max_b){
	                bmax1 = b1;
	                bmax2 = b2;
	                max_b = s;
				}
			}
		}
	    
	    /*initial top half parameters):*/
	    max_d = -1;
	    mn1_d = max((double)3, (double)(dmax1 - floor(STEPS/2)*sz));
	    mn2_d = max((double)3, (double)(dmax2 - floor(STEPS/2)*sz));
	    mx1_d = min((double)((1-rs)*h), (double)(bmax1 + floor(STEPS/2)*sz));
	    mx2_d = min((double)((1-rs)*h), (double)(bmax2 + floor(STEPS/2)*sz));
	    
	    stepInterval_d1 = (mx1_d-mn1_d)/(STEPS-1);
	    stepInterval_d2 = (mx2_d-mn2_d)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			d1Iterate[i] = (int)(mn1_d + i*stepInterval_d1+0.5);
			d2Iterate[i] = (int)(mn2_d + i*stepInterval_d2+0.5);
		}
	    
	    for(iterD1=0; iterD1<STEPS; iterD1++){
			d1 = d1Iterate[iterD1];
			for(iterD2=0; iterD2<STEPS; iterD2++){
				d2 = d2Iterate[iterD2];
	         	
	         	/*sum pixels intersected by line:*/
	            s = 0;
	            for(x=0; x<w; x++){
	            	/* draw line between points: WHY ORIGINALLY x-1???*/
	            	y_test = (int)((((d1-d2)/(c1-c2))*(x-1))+d2+0.5);
	            	s += img[y_test][x];
	            }
	        
	            /*maximize:*/
	            if (s > max_d){
	                dmax1 = d1;
	                dmax2 = d2;
	                max_d = s;
	            }
			}
	    } 
	}
	
	/*shorten variable names:*/
	b1 = bmax1;
	b2 = bmax2;
	d1 = dmax1;
	d2 = dmax2;
	
	
	/*** CALCULATE VANISHING POINT AND RATIO ***/
	
	/*algebra (intersection of two lines):*/
	right = d1 - b1 + a1*(b1-b2)/(a1-a2) - c1*(d1-d2)/(c1-c2);
	left = (b1-b2)/(a1-a2) - (d1-d2)/(c1-c2);
	x_vp = right / left;
	y_vp = (x_vp - a1) * (b1-b2)/(a1-a2) + b1;
	
	/* use line with largest slope to calculate ratio for transformation:*/
	if (fabs(d1 - d2) < fabs(b1 - b2) && (fabs(b1 - b2) > 3)){
		for(x=0; x<w; x++){
	    	y = (b1 - b2)/(a1 - a2)*(x - a1) + b1;
	    	r[x] = (b1 - y_vp)/(y - y_vp);
	   	}
	}
	else if (fabs(d1 - d2) > 3){
		for(x=0; x<w; x++){
	    	y = (d1 - d2)/(c1 - c2)*(x - c1) + d1;
	    	r[x] = (d1 - y_vp)/(y - y_vp);
	   	}
	}
	else{
	    /* no correction needed:*/
	    for(row=0; row<h; row++){
		    for(col=0; col<w; col++){
		        /*assign pixel in new image:*/
		        new_img[row][col] = img[row][col];
		    }
		}      
	    return;
	}
	
	
	/***PERFORM TRANSFORMATION***/
	for(row=0; row<h; row++){
	    for(col=0; col<w; col++){
	        /*calculate coordinate from which to take pixel:*/
	        old_y = (int)((y_vp + (row-y_vp)/r[col])+0.5);
	        
	        /*boundary checking:*/
	        old_y = max((double)old_y, (double)1);
	        old_y = min((double)old_y, (double)h);
	        
	        /*assign pixel in new image:*/
	        new_img[row][col] = img[old_y][col];
	    }
	}
	free(r);
}

void hor_deskew(double **img, int h, int w, double **new_img){
/**** OVERVIEW ***

 this code works in a similar way to
 the vertical deskew script. it works
 by points along the top and bottom
   *                *
 ---------------------





 ---------------------
  *                *
where the lines connecting them likely
run along the edges of the staffs.
afterward, the vansihing point is calculated
and we use a transform to correct for skew.
*/

double a1, a2, c1, c2, max_b, mn1_b, mn2_b, mx1_b, mx2_b, stepInterval, stepInterval_b1,
 	stepInterval_b2, stepInterval_d1, stepInterval_d2, max_d, mn1_d, mn2_d, mx1_d, mx2_d,
	b1, b2, d1, d2, left, right, x_vp, y_vp, x;
int i, ind, iterD1, iterD2, iterB1, iterB2, s, s1, s2, y, x_test, x_test_fudge, row, col, old_x, fudge;
double rs, *r;
int bmax1, bmax2, dmax1, dmax2, sz;
int stepsizes[LENGTH_STEP_SIZES] = {31, 23, 19, 11, 7, 3, 1};
double restrictions[LENGTH_STEP_SIZES], b1Iterate[STEPS], b2Iterate[STEPS], d1Iterate[STEPS], d2Iterate[STEPS];

	
	r = (double *)get_spc((int)h, sizeof(double));
	a1 = h;
	a2 = 1;
	c1 = a1;
	c2 = a2;
	
	/*initial values:*/
	bmax1 = (int)((0.82*(double)w)+0.5);
	bmax2 = bmax1;
	dmax1 = (int)((0.18*(double)w)+0.5);
	dmax2 = dmax1;
	
	
	/*steps:*/
	stepInterval = (0.60 - 0.70)/(LENGTH_STEP_SIZES-1);
	for(i=0; i<LENGTH_STEP_SIZES; i++){
		restrictions[i] = 0.65 + i*stepInterval;
	}
	fudge = 15;
	
	/*** OPTIMIZE B1, B2, D1, and D2 points ***/

	/*iterate step size:*/
	for(ind=0; ind<LENGTH_STEP_SIZES; ind++){
	    
	    /*initial general parameters:*/
	    sz = stepsizes[ind];
	    rs = restrictions[ind];
	    
	    /*initial parameters for the right side:*/
	    
	    max_b = -2*h;
	    mn1_b = max((double)(rs*w), (double)(bmax1 - floor(STEPS/2)*sz));
	    mn2_b = max((double)(rs*w), (double)(bmax2 - floor(STEPS/2)*sz));
	    mx1_b = min((double)(w), (double)(bmax1 + floor(STEPS/2)*sz));
	    mx2_b = min((double)(w), (double)(bmax2 + floor(STEPS/2)*sz));

	    stepInterval_b1 = (mx1_b-mn1_b)/(STEPS-1);
	    stepInterval_b2 = (mx2_b-mn2_b)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			b1Iterate[i] = (int)(mn1_b + i*stepInterval_b1+0.5);
			b2Iterate[i] = (int)(mn2_b + i*stepInterval_b2+0.5);
		}
		
		for(iterB1=0; iterB1<STEPS; iterB1++){
			b1 = b1Iterate[iterB1];
			for(iterB2=0; iterB2<STEPS; iterB2++){
				b2 = b2Iterate[iterB2];
	        
	            /*sum pixels intersected by line:*/
	            s1 = 0;
	            s2 = 0;
	            for(y=0; y<h; y++){
	            	/* draw line between points:*/
	            	x_test = (int)((((b1-b2)/(a1-a2))*(y-1))+b2+0.5);
	            	x_test_fudge = (int)((((b1-b2)/(a1-a2))*(y-1))+b2+0.5) - fudge;
	            	s1 += img[y][x_test];
	            	s2 += img[y][x_test_fudge];
	            }
	            
	            /*% draw line between points:
	            x_test = round((b1-b2)/(a1-a2)*(y-1)+b2);
	    
	            % look for large difference in area of line:
	            s1 = sum(img(sub2ind(size(img), y, x_test)));
	            s2 = sum(img(sub2ind(size(img), y, x_test-fudge)));*/
	            s = s2 - 2*s1;
	            
	            /*maximize:*/
	            if (s > max_b){
	                bmax1 = b1-(int)((fudge/2)+0.5);
	                bmax2 = b2-(int)((fudge/2)+0.5);
	                max_b = s;
	            }
			}
		}
	    
	    /*initial parameters for left side:*/
	    max_d = -2*h^2;
	    mn1_d = max((double)1, (double)(dmax1 - floor(STEPS/2)*sz));
	    mn2_d = max((double)1, (double)(dmax2 - floor(STEPS/2)*sz));
	    mx1_d = min((double)((1-rs)*w), (double)(bmax1 + floor(STEPS/2)*sz));
	    mx2_d = min((double)((1-rs)*w), (double)(bmax2 + floor(STEPS/2)*sz));
	    
	    
	    stepInterval_d1 = (mx1_d-mn1_d)/(STEPS-1);
	    stepInterval_d2 = (mx2_d-mn2_d)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			d1Iterate[i] = (int)(mn1_d + i*stepInterval_d1+0.5);
			d2Iterate[i] = (int)(mn2_d + i*stepInterval_d2+0.5);
		}
	    
	    for(iterD1=0; iterD1<STEPS; iterD1++){
			d1 = d1Iterate[iterD1];
			for(iterD2=0; iterD2<STEPS; iterD2++){
				d2 = d2Iterate[iterD2];

	            /*sum pixels intersected by line:*/
	            s1 = 0;
	            s2 = 0;
	            for(y=0; y<h; y++){
	            	/* draw line between points:*/
	            	x_test = (int)((d1-d2)/(c1-c2)*(y-1)+d2+0.5);
	            	x_test_fudge = (int)((d1-d2)/(c1-c2)*(y-1)+d2+0.5) + fudge;
	            	s1 += img[y][x_test];
	            	s2 += img[y][x_test_fudge];
	            }
	            
	            s = s2 - 2*s1;
	            
	            /*maximize:*/
	            if (s > max_d){
	                dmax1 = d1+(int)((fudge/2)+0.5);
	                dmax2 = d2+(int)((fudge/2)+0.5);
	                max_d = s;
	            }
			}
	    }
	}
	
	/*shorten variable names:*/
	b1 = bmax1;
	b2 = bmax2;
	d1 = dmax1;
	d2 = dmax2;
	
	
	/*** CALCULATE VANISHING POINT AND RATIO ***/
	
	/*algebra (intersection of two lines):*/
	right = d1 - b1 + a1*(b1-b2)/(a1-a2) - c1*(d1-d2)/(c1-c2);
	left = (b1-b2)/(a1-a2) - (d1-d2)/(c1-c2);
	y_vp = right / left;
	x_vp = (y_vp - a1) * (b1-b2)/(a1-a2) + b1;
	
	/*use line with largest slope to calculate ratio for transformation:*/
	if (fabs(d1 - d2) < fabs(b1 - b2) && (fabs(b1 - b2) > 3)){
	    for(y=0; y<h; y++){
	    	x = (b1 - b2)/(a1 - a2)*(y - a1) + b1;
	    	r[y] = (b1 - x_vp)/(x - x_vp);
	   	}
	}
	else if (fabs(d1 - d2) > 3){
		for(y=0; y<h; y++){
	    	x = (d1 - d2)/(c1 - c2)*(y - c1) + d1;
	    	r[y] = (d1 - x_vp)/(x - x_vp);
	   	}
	}
	else{
	    /* no correction needed:*/
	    for(row=0; row<h; row++){
		    for(col=0; col<w; col++){
		        /*assign pixel in new image:*/
		        new_img[row][col] = img[row][col];
		    }
		}      
	    return;
	} 
	
	/***PERFORM TRANSFORMATION***/
	for(row=0; row<h; row++){
	    for(col=0; col<w; col++){
	        /*calculate coordinate from which to take pixel:*/
	        old_x = (int)((x_vp + (col-x_vp)/r[row])+0.5);
	        
	        /*boundary checking:*/
	        old_x = max((double)old_x, (double)1);
	        old_x = min((double)old_x, (double)w);
	        
	        /*assign pixel in new image:*/
	        new_img[row][col] = img[row][old_x];
	    }
	}
	free(r);
}

void w_crop(double **img, int h, int w, int strict, int *crop_t, int *newHeight, int *crop_l, int *newWidth){
/*this algorithm crops out white space according to a threshold fraction
returns cropped image with some cushion*/

int crop_b, crop_r,pad_lr,pad_tb, *proj_onto_y, *proj_onto_x, i, j, sum;
double h_thrsh, w_thrsh;

	if (strict == 0){
	    h_thrsh = 0.012*h; 	/*vertical threshold*/
	    w_thrsh = 0.012*w; 	/*horizontal threshold*/
	    pad_lr = 40;    	/*pixels in lr_padding*/
	    pad_tb = 20;    	/*pixels in tb_padding*/
	}
	else{
	    h_thrsh = 1;
	    w_thrsh = 1;
	    pad_lr = 0;
	    pad_tb = 0;
	}
	
	
	proj_onto_y = (int *)get_spc((int)h, sizeof(int));
	for(i=0;i<h;i++){
		sum = 0;
		for(j=0;j<w;j++){
			sum += img[i][j];
		}
		proj_onto_y[i] = sum;
	}
	
	proj_onto_x = (int *)get_spc((int)w, sizeof(int));
	for(j=0;j<w;j++){
		sum = 0;
		for(i=0;i<h;i++){
			sum += img[i][j];
		}
		proj_onto_x[j] = sum;
	}


	/*initial values*/
	*crop_l = 0;
	crop_r = w-1;
	*crop_t = 0;
	crop_b = h-1;
	
	
	/*find boundaries for crop:*/
	while (*crop_l < w-1 && proj_onto_x[*crop_l] < h_thrsh){
	    (*crop_l)++;
	}
	
	while (crop_r > 0 && proj_onto_x[crop_r] < h_thrsh){
	    crop_r--;
	} 
	   
	while (*crop_t < h-1 && proj_onto_y[*crop_t] < w_thrsh){
	    (*crop_t)++;
	}
	
	while (crop_b > 0 && proj_onto_y[crop_b] < w_thrsh){
	    crop_b--;
	}

	/*cushion:*/
	*crop_l = (int)(max((double)1, (double)((*crop_l) - pad_lr)));
	crop_r = (int)(min((double)w, (double)(crop_r + pad_tb)));
	*crop_t = (int)(max((double)1, (double)((*crop_t) - pad_lr)));
	crop_b = (int)(min((double)h, (double)(crop_b + pad_tb)));
	
	*newHeight = crop_b-(*crop_t)+1;
	*newWidth = crop_r-(*crop_l)+1;
	
}
