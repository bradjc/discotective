LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := discotective-jni

LOCAL_SRC_FILES := \
    ../../../source/discotective/core/audio.c			\
	../../../source/discotective/core/classification.c	\
	../../../source/discotective/core/deleting.c		\
	../../../source/discotective/core/music_functions.c	\
	../../../source/discotective/core/preprocessing.c	\
	../../../source/discotective/core/run.c				\
	../../../source/discotective/core/scanning.c		\
	../../../source/discotective/core/segmentation.c	\
	../../../source/discotective/utility/allocate.c				\
	../../../source/discotective/utility/flex_array.c			\
	../../../source/discotective/utility/general_functions.c	\
	../../../source/discotective/utility/global.c				\
	../../../source/discotective/utility/image_functions.c		\
	../../../source/discotective/utility/linked_list.c			\
	platform_specific.c											\
	jni_run.c
	
LOCAL_C_INCLUDES	:= $(LOCAL_PATH)/../../../source/discotective/include

LOCAL_LDLIBS := -llog

include $(BUILD_SHARED_LIBRARY)