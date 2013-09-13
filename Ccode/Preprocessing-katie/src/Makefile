# For Linux or any machines with gcc compiler
CC = gcc
CFLAGS = -ansi -Wall -pedantic -g

# For SunOS
#CFLAGS = -Aa

all: readWriteImage
 
clean:
	/bin/rm -f *.o ../readWriteImage

OBJ = tiff.o allocate.o preprocessing.o myMatrixInverse.o

readWriteImage: readWriteImage.o $(OBJ) 
	$(CC) $(CFLAGS) -o ../readWriteImage readWriteImage.o $(OBJ) -lm
