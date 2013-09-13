#include "run.h"
#include <jni.h>

jint Java_com_discotective_Discotective_discotective_run (JNIEnv* env, jobject this, jbyte* rgba_img, jshort height, jshort width) {
	run(rgba_img, height, width);
}
