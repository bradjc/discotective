#include <math.h>
#include "allocate.h"
#include <stdio.h>
#include "preprocessing.h"

#define LENGTH_STEP_SIZES 7
#define STEPS 25

void binarizeIMG(uint8_t **img, int32_t height, int32_t width, image_t *binIMG, float fudge){
/*Binarize an image using quadratic linear regression
	img = input grayscale image
	height = height of image
	width = width of image
	binIMG = output binarized image
	fudge = fudge value for thresholding */
	
	float **X, *Y, **covMatrix, *intermediate, *W, **covMatrixINV, *Bias;
	int32_t i, j, k, counter;
	int32_t size;
	float sum;
	
	size = (int32_t)height*width;
	
	/*initlize X and Y for quadratic linear regression*/
	X = (float **)multialloc (sizeof (float), 2, (int32_t)size, 6);
	Y = (float *)get_spc((int32_t)size, sizeof(float));
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
	intermediate = (float *)get_spc((int32_t)6, sizeof(float));
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
    			setPixel(binIMG,i,j,0); 
    		}
    		else{
    			setPixel(binIMG,i,j,1);
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


void tbCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_top, int32_t *newHeight){
	int32_t *project_Y;
	int32_t i,j,crop_bot,max,h_frac,sum,w_thrsh;
	
	project_Y = (int32_t *)get_spc((int32_t)height, sizeof(int32_t));
	
	for(i=0;i<height;i++){
		sum = 0;
		for(j=0;j<width;j++){
			sum += getPixel(img,i,j);
		}
		project_Y[i] = sum;
	}
	
	h_frac = (int32_t)(((float)height/8.0)+0.5);
	
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

void lrCrop(const image_t *img, int32_t height, int32_t width, int32_t *crop_lef, int32_t *newWidth){
	int32_t *project_X;
	int32_t i,j,crop_rig,max,w_frac,sum,h_thrsh;
	
	project_X = (int32_t *)get_spc((int32_t)width, sizeof(int32_t));
	
	for(j=0;j<width;j++){
		sum = 0;
		for(i=0;i<height;i++){
			sum += getPixel(img,i,j);;
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

void ver_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img){
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
	float a1, a2, c1, c2, max_b, mn1_b, mn2_b, mx1_b, mx2_b, stepInterval, stepInterval_b1,
	 	stepInterval_b2, stepInterval_d1, stepInterval_d2, max_d, mn1_d, mn2_d, mx1_d, mx2_d,
		b1, b2, d1, d2, left, right, x_vp, y_vp, y;
	int32_t i, ind, iterD1, iterD2, iterB1, iterB2, s, x, y_test, row, col, old_y;
	float rs, *r;
	int32_t bmax1, bmax2, dmax1, dmax2, sz;
	int32_t stepsizes[LENGTH_STEP_SIZES] = {31, 23, 19, 11, 7, 3, 1};
	float restrictions[LENGTH_STEP_SIZES], b1Iterate[STEPS], b2Iterate[STEPS], d1Iterate[STEPS], d2Iterate[STEPS];
	
	/***SETUP***/
	r = (float *)get_spc((int32_t)w, sizeof(float));
	
	/* x indices:*/
	a1 = w;
	a2 = 1;
	c1 = a1;
	c2 = a2;
	
	/*initial values:*/
	bmax1 = (int32_t)((7.0*(float)h/8.0)+0.5);
	bmax2 = bmax1;
	dmax1 = (int32_t)(((float)h/4.0)+0.5);
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
	    mn1_b = max((float)(rs*h), (float)(bmax1 - (int32_t)((int32_t)STEPS/2.0)*sz));
	    mn2_b = max((float)(rs*h), (float)(bmax2 - (int32_t)((int32_t)STEPS/2.0)*sz));
	    mx1_b = min((float)(h-3), (float)(bmax1 + (int32_t)((int32_t)STEPS/2.0)*sz));
	    mx2_b = min((float)(h-3), (float)(bmax2 + (int32_t)((int32_t)STEPS/2.0)*sz));
	    
	    stepInterval_b1 = (mx1_b-mn1_b)/(STEPS-1);
	    stepInterval_b2 = (mx2_b-mn2_b)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			b1Iterate[i] = (int32_t)(mn1_b + i*stepInterval_b1 +0.5);
			b2Iterate[i] = (int32_t)(mn2_b + i*stepInterval_b2 + 0.5);
		}
		
		for(iterB1=0; iterB1<STEPS; iterB1++){
			b1 = b1Iterate[iterB1];
			for(iterB2=0; iterB2<STEPS; iterB2++){
				b2 = b2Iterate[iterB2];
	    
	            /*sum pixels intersected by line:*/
	            s = 0;
	            for(x=0; x<w; x++){
	            	/* draw line between points: WHY ORIGINALLY x-1???*/
	            	y_test = (int32_t)((((b1-b2)/(a1-a2))*(x))+b2+0.5);
	            	s += getPixel(img,y_test,x);
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
	    mn1_d = max((float)3, (float)(dmax1 - floor(STEPS/2)*sz));
	    mn2_d = max((float)3, (float)(dmax2 - floor(STEPS/2)*sz));
	    mx1_d = min((float)((1-rs)*h), (float)(bmax1 + floor(STEPS/2)*sz));
	    mx2_d = min((float)((1-rs)*h), (float)(bmax2 + floor(STEPS/2)*sz));
	    
	    stepInterval_d1 = (mx1_d-mn1_d)/(STEPS-1);
	    stepInterval_d2 = (mx2_d-mn2_d)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			d1Iterate[i] = (int32_t)(mn1_d + i*stepInterval_d1+0.5);
			d2Iterate[i] = (int32_t)(mn2_d + i*stepInterval_d2+0.5);
		}
	    
	    for(iterD1=0; iterD1<STEPS; iterD1++){
			d1 = d1Iterate[iterD1];
			for(iterD2=0; iterD2<STEPS; iterD2++){
				d2 = d2Iterate[iterD2];
	         	
	         	/*sum pixels intersected by line:*/
	            s = 0;
	            for(x=0; x<w; x++){
	            	/* draw line between points: WHY ORIGINALLY x-1???*/
	            	y_test = (int32_t)((((d1-d2)/(c1-c2))*(x))+d2+0.5);
	            	s += getPixel(img,y_test,x);
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
		        setPixel(new_img,row,col,getPixel(img,row,col));
		    }
		}      
	    return;
	}
	
	
	/***PERFORM TRANSFORMATION***/
	for(row=0; row<h; row++){
	    for(col=0; col<w; col++){
	        /*calculate coordinate from which to take pixel:*/
	        old_y = (int32_t)((y_vp + (row-y_vp)/r[col])+0.5);
	        
	        /*boundary checking:*/
	        old_y = max((float)old_y, (float)0);
	        old_y = min((float)old_y, (float)(h-1));
	        
	        /*assign pixel in new image:*/
	        setPixel(new_img,row,col,getPixel(img,old_y,col));
	    }
	}
	free(r);
}

void hor_deskew(const image_t *img, int32_t h, int32_t w, image_t *new_img){
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

float a1, a2, c1, c2, max_b, mn1_b, mn2_b, mx1_b, mx2_b, stepInterval, stepInterval_b1,
 	stepInterval_b2, stepInterval_d1, stepInterval_d2, max_d, mn1_d, mn2_d, mx1_d, mx2_d,
	b1, b2, d1, d2, left, right, x_vp, y_vp, x;
int32_t i, ind, iterD1, iterD2, iterB1, iterB2, s, s1, s2, y, x_test, x_test_fudge, row, col, old_x, fudge;
float rs, *r;
int32_t bmax1, bmax2, dmax1, dmax2, sz;
int32_t stepsizes[LENGTH_STEP_SIZES] = {31, 23, 19, 11, 7, 3, 1};
float restrictions[LENGTH_STEP_SIZES], b1Iterate[STEPS], b2Iterate[STEPS], d1Iterate[STEPS], d2Iterate[STEPS];

	
	r = (float *)get_spc((int32_t)h, sizeof(float));
	a1 = h;
	a2 = 1;
	c1 = a1;
	c2 = a2;
	
	/*initial values:*/
	bmax1 = (int32_t)((0.82*(float)w)+0.5);
	bmax2 = bmax1;
	dmax1 = (int32_t)((0.18*(float)w)+0.5);
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
	    mn1_b = max((float)(rs*w), (float)(bmax1 - floor(STEPS/2)*sz));
	    mn2_b = max((float)(rs*w), (float)(bmax2 - floor(STEPS/2)*sz));
	    mx1_b = min((float)(w), (float)(bmax1 + floor(STEPS/2)*sz));
	    mx2_b = min((float)(w), (float)(bmax2 + floor(STEPS/2)*sz));

	    stepInterval_b1 = (mx1_b-mn1_b)/(STEPS-1);
	    stepInterval_b2 = (mx2_b-mn2_b)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			b1Iterate[i] = (int32_t)(mn1_b + i*stepInterval_b1+0.5);
			b2Iterate[i] = (int32_t)(mn2_b + i*stepInterval_b2+0.5);
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
	            	x_test = (int32_t)((((b1-b2)/(a1-a2))*(y))+b2+0.5);
	            	x_test_fudge = (int32_t)((((b1-b2)/(a1-a2))*(y))+b2+0.5) - fudge;
	            	s1 += getPixel(img,y,x_test);
	            	s2 += getPixel(img,y,x_test_fudge);
	            }
	            
	            /*% draw line between points:
	            x_test = round((b1-b2)/(a1-a2)*(y-1)+b2);
	    
	            % look for large difference in area of line:
	            s1 = sum(img(sub2ind(size(img), y, x_test)));
	            s2 = sum(img(sub2ind(size(img), y, x_test-fudge)));*/
	            s = s2 - 2*s1;
	            
	            /*maximize:*/
	            if (s > max_b){
	                bmax1 = b1-(int32_t)((fudge/2)+0.5);
	                bmax2 = b2-(int32_t)((fudge/2)+0.5);
	                max_b = s;
	            }
			}
		}
	    
	    /*initial parameters for left side:*/
	    max_d = -2*h^2;
	    mn1_d = max((float)1, (float)(dmax1 - floor(STEPS/2)*sz));
	    mn2_d = max((float)1, (float)(dmax2 - floor(STEPS/2)*sz));
	    mx1_d = min((float)((1-rs)*w), (float)(bmax1 + floor(STEPS/2)*sz));
	    mx2_d = min((float)((1-rs)*w), (float)(bmax2 + floor(STEPS/2)*sz));
	    
	    
	    stepInterval_d1 = (mx1_d-mn1_d)/(STEPS-1);
	    stepInterval_d2 = (mx2_d-mn2_d)/(STEPS-1);
		for(i=0; i<STEPS; i++){
			d1Iterate[i] = (int32_t)(mn1_d + i*stepInterval_d1+0.5);
			d2Iterate[i] = (int32_t)(mn2_d + i*stepInterval_d2+0.5);
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
	            	x_test = (int32_t)((d1-d2)/(c1-c2)*(y)+d2+0.5);
	            	x_test_fudge = (int32_t)((d1-d2)/(c1-c2)*(y)+d2+0.5) + fudge;
	            	s1 += getPixel(img,y,x_test);
	            	s2 += getPixel(img,y,x_test_fudge);
	            }
	            
	            s = s2 - 2*s1;
	            
	            /*maximize:*/
	            if (s > max_d){
	                dmax1 = d1+(int32_t)((fudge/2)+0.5);
	                dmax2 = d2+(int32_t)((fudge/2)+0.5);
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
		        setPixel(new_img,row,col,getPixel(img,row,col));
		    }
		}      
	    return;
	} 
	
	/***PERFORM TRANSFORMATION***/
	for(row=0; row<h; row++){
	    for(col=0; col<w; col++){
	        /*calculate coordinate from which to take pixel:*/
	        old_x = (int32_t)((x_vp + (col-x_vp)/r[row])+0.5);
	        
	        /*boundary checking:*/
	        old_x = max((float)old_x, (float)0);
	        old_x = min((float)old_x, (float)(w-1));
	        
	        /*assign pixel in new image:*/
	        setPixel(new_img,row,col,getPixel(img,row,old_x));
	    }
	}
	free(r);
}

void w_crop(const image_t *img, int32_t h, int32_t w, int32_t strict, int32_t *crop_t, int32_t *newHeight, int32_t *crop_l, int32_t *newWidth){
/*this algorithm crops out white space according to a threshold fraction
returns cropped image with some cushion*/

int32_t crop_b, crop_r,pad_lr,pad_tb, *proj_onto_y, *proj_onto_x, i, j, sum;
float h_thrsh, w_thrsh;

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
	
	
	proj_onto_y = (int32_t *)get_spc((int32_t)h, sizeof(int32_t));
	for(i=0;i<h;i++){
		sum = 0;
		for(j=0;j<w;j++){
			sum += getPixel(img,i,j);
		}
		proj_onto_y[i] = sum;
	}
	
	proj_onto_x = (int32_t *)get_spc((int32_t)w, sizeof(int32_t));
	for(j=0;j<w;j++){
		sum = 0;
		for(i=0;i<h;i++){
			sum += getPixel(img,i,j);
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
	*crop_l = (int32_t)(max((float)1, (float)((*crop_l) - pad_lr)));
	crop_r = (int32_t)(min((float)w, (float)(crop_r + pad_tb)));
	*crop_t = (int32_t)(max((float)1, (float)((*crop_t) - pad_lr)));
	crop_b = (int32_t)(min((float)h, (float)(crop_b + pad_tb)));
	
	*newHeight = crop_b-(*crop_t)+1;
	*newWidth = crop_r-(*crop_l)+1;
	
}

void blob_kill(image_t* img, uint8_t lr, uint8_t tb){

    /*%%% OVERVIEW %%%
    
     this algorithm removes any black images from
     around the image border using a depth first search
    
     be sure that the blobs are not large
     or the runtime will increase dramatically
    
     set lr to 1 to remove blobs from the left and right
     set tb to 1 to remove blobs from the top and bottom
    
    %%% SET-UP %%%
    Var Declarations*/
    uint16_t height,width,col,row,n;
    int8_t nbors[4][2];
    linked_list* stack;
    uint16_t* array;
    uint16_t* array2;
    uint64_t watch;
    /*End Var Declaraions*/
    height=img->height;
    width=img->width;
    nbors[0][0]=-1;
    nbors[0][1]=-1;
    nbors[1][0]=-1;
    nbors[1][1]= 1;
    nbors[2][0]= 1;
    nbors[2][1]=-1;
    nbors[3][0]= 1;
    nbors[3][1]= 1;
    stack=create_linked_list();
    watch=0;
    
    
    /*%%% ALGORITHM %%%*/
    
    if (lr == 1){
        /* loop through left and right border pixels*/
        for (col = 0;col<width;col+=width-1){
            for (row = 0;row<height;row++){
                /* look for blob:*/
                if (getPixel(img,row,col) == 1){
                    
                    /* initialize blob stuff:*/
                    setPixel(img,row,col,0);
                    array=malloc(2*sizeof(uint16_t));
                    array[0]=row;
                    array[1]=col;
                    push_top(stack,array);
                    watch++;
                    /* depth first search:*/
                    while (is_list_empty(stack)==0){
                          array=pop_top(stack);
                          
                        /* check neighbors:*/
                        for (n=0;n<4;n++){
                            array2=malloc(2*sizeof(uint16_t));
                            array2[0]=array[0]+nbors[n][0];
                            array2[1]=array[1]+nbors[n][1];
                            if (array2[0]>0 && array2[1]>0 && array2[0]<height && array2[1]<width && getPixel( img,array2[0], array2[1] ) ){
                                setPixel(img,array2[0], array2[1],0);
                                
                                push_top(stack,array2);
                                watch++;
                                
                            }
                            else free(array2);
                        }
                        free(array);
                    }
                }
            }
        }
    }
    if (tb == 1){
        /* loop through top and bottom border pixels:*/
        for (col = 0;col<width;col++){
            for (row = 0;row<height;row+=height-1){
                
                /* look for blob:*/
                if (getPixel(img,row,col) == 1){
                    
                    /* initialize blob stuff:*/
                    setPixel(img,row,col,0);
                    array=malloc(2*sizeof(uint16_t));
                    array[0]=row;
                    array[1]=col;
                    push_top(stack,array);
                    
                    /* depth first search:*/
                    while (is_list_empty(stack)==0){
                          array=pop_top(stack);
                        /* check neighbors:*/
                        for (n=0;n<4;n++){
                            array2=malloc(2*sizeof(uint16_t));
                            array2[0]=array[0]+nbors[n][0];
                            array2[1]=array[1]+nbors[n][1];
                            if (array2[0]>0 && array2[1]>0 && array2[0]<height && array2[1]<width && getPixel( img,array2[0], array2[1] ) ){
                                push_top(stack,array2);
                                setPixel(img,array2[0], array2[1],0);
                            }
                            else free(array2);
                        }
                        free(array);
                    }
                }
            }
        }
    }
    delete_list(stack);

}
