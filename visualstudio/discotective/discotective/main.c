#include "io.h"
#include "global.h"
#include "linked_list.h"
#include <stdint.h>
#include "run.h"
#include "stb_image.h"

//#define _DEBUG

int main (int argc, char **argv) {

	uint8_t			*RGBAArray;
	linked_list*	all_notes;
	int				width;
	int				height;
	int				n;

	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);

	// check if img exists
	if (_access(argv[1], 0) != 0) {
		printf("File %s not found\n", argv[1]);
		return -1;
	}

	// load in jpeg image
	RGBAArray = stbi_load(argv[1], &width, &height, &n, 4);

	// do it
	all_notes = run(RGBAArray, height, width);

//	_CrtDumpMemoryLeaks();

	return 0;
}
