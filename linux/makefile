SOURCE_DIR =	../source/discotective
IMG_SRC =		../test
BASE_FLAGS =	 -Wall -Werror -lm -I$(SOURCE_DIR)/include
FLAGS =			-c $(BASE_FLAGS)


audio.o:			$(SOURCE_DIR)/core/audio.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/audio.c

audio_files.o:		$(SOURCE_DIR)/core/audio_files.c
					gcc -std=c99 $(FLAGS) $(SOURCE_DIR)/core/audio_files.c

classification.o:	$(SOURCE_DIR)/core/classification.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/classification.c

deleting.o:			$(SOURCE_DIR)/core/deleting.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/deleting.c

music_functions.o:	$(SOURCE_DIR)/core/music_functions.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/music_functions.c

preprocessing.o:	$(SOURCE_DIR)/core/preprocessing.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/preprocessing.c

run.o:				$(SOURCE_DIR)/core/run.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/run.c

scanning.o:			$(SOURCE_DIR)/core/scanning.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/scanning.c

segmentation.o:		$(SOURCE_DIR)/core/segmentation.c
					gcc $(FLAGS) $(SOURCE_DIR)/core/segmentation.c

allocate.o:			$(SOURCE_DIR)/utility/allocate.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/allocate.c

flex_array.o:		$(SOURCE_DIR)/utility/flex_array.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/flex_array.c

general_functions.o:	$(SOURCE_DIR)/utility/general_functions.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/general_functions.c

global.o:			$(SOURCE_DIR)/utility/global.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/global.c

image_functions.o:	$(SOURCE_DIR)/utility/image_functions.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/image_functions.c

linked_list.o:		$(SOURCE_DIR)/utility/linked_list.c
					gcc $(FLAGS) $(SOURCE_DIR)/utility/linked_list.c

stb_image.o:		stb_image.c
					gcc $(FLAGS) stb_image.c

build:				audio.o audio_files.o classification.o deleting.o music_functions.o preprocessing.o run.o scanning.o segmentation.o allocate.o flex_array.o general_functions.o global.o image_functions.o linked_list.o stb_image.o
					gcc $(BASE_FLAGS) main.c platform_specific.c stb_image.c audio.o audio_files.o classification.o deleting.o music_functions.o preprocessing.o run.o scanning.o segmentation.o allocate.o flex_array.o general_functions.o global.o image_functions.o linked_list.o -o discotective

aunt:				build
					./discotective $(IMG_SRC)/aunt_rhody2.jpg
