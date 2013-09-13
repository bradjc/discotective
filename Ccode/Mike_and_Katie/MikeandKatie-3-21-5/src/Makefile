# For Linux or any machines with gcc compiler
CC = gcc
CFLAGS = -ansi -Wall -pedantic -g

# For SunOS
#CFLAGS = -Aa

all: readWriteImage
 
clean:
	/bin/rm -f *.o ../readWriteImage

OBJ = tiff.o allocate.o preprocessing.o myMatrixInverse.o linked_list.o image_data.o classify.o segmentation.o utility_functions.o outputIMG.o

readWriteImage: readWriteImage.o $(OBJ) 
	$(CC) $(CFLAGS) -o ../readWriteImage readWriteImage.o $(OBJ) -lm
