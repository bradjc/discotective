iPhone Code Organization

All files are same as before, except:

The code which was in main before, is now located in DiscotectiveViewController.m following the line which says 
dispatch_async(binarizeQueue,^{

some notes: NSLog is just a write to the console in objective C land

sections like the following

dispatch_queue_t mainQueue;
		mainQueue=dispatch_get_main_queue();
		binaryUIImage=[self createUIImageFromBinaryImage:image1];
		[sheetMusicImage.image release];
		//Finished Preprocessing..........................
		dispatch_sync(mainQueue, ^{
			sheetMusicImage.image=[binaryUIImage retain];
		});

basically are just getting the main thread so that ui stuff can be done there creating an objective c type 
image from our binary image type and writing that image to the display

usleep just delays the execution

the binarizeUIImage function just takes int he objective c image type and converts it to grayscale using the formula we had from matlab
and then binarizes it using the adaptive threshold binarize function

