package com.discotective;

//from http://marakana.com/forums/android/examples/39.html

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.ShutterCallback;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;

public class Discotective extends Activity {
	private static final String	TAG = "CameraDemo";
	
	Camera				camera;
	CameraPreview		preview;
	Camera.Parameters	camera_params;
	Camera.Size			img_size;
	int					img_format;
	Button				buttonClick;
	

	// Called when the activity is first created.
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		Log.d(TAG, "started");
		
		// get the main discotective c code library
		System.loadLibrary("discotective-jni");
		
		Log.d(TAG, "loaded library");
		
		setContentView(R.layout.main);

		preview = new CameraPreview(this);
		((FrameLayout) findViewById(R.id.preview)).addView(preview);
		
		Log.d(TAG, "got new camera preview and added view");
		
		// this is bad
	//	while (preview.camera == null);
		
		Log.d(TAG, "not null");
		
		// figure out the size and format of the picture we will be getting
	//	camera_params	= preview.camera.getParameters();
	//	Log.d(TAG, "got camera params");
	//	img_size		= camera_params.getPictureSize();
	//	Log.d(TAG, "got img size");
	//	img_format		= camera_params.getPictureFormat();
	//	Log.d(TAG, "got img format");
		
		
		// set up the button
		buttonClick = (Button) findViewById(R.id.buttonClick);
		buttonClick.setOnClickListener( new OnClickListener() {
			public void onClick(View v) {
				preview.camera.takePicture(shutterCallback, rawCallback, postviewCallback, jpegCallback);
			}
		});

		Log.d(TAG, "onCreate'd");
	}


	ShutterCallback shutterCallback = new ShutterCallback() {
		public void onShutter() {
			Log.d(TAG, "onShutter'd");
		}
	};

	// Handles data for raw picture
	PictureCallback rawCallback = new PictureCallback() {
		public void onPictureTaken(byte[] data, Camera camera) {
			Log.d(TAG, "onPictureTaken - raw");
		}
	};
	
	// "The postview callback occurs when a scaled, fully processed postview image is available"
	PictureCallback postviewCallback = new PictureCallback() {
		public void onPictureTaken(byte[] data, Camera camera) {
			byte[]	rgba_img = {0};
		
			Log.d(TAG, "onPictureTaken - postview");
			
			// convert the output data to the format we need
			if (img_format == ImageFormat.JPEG) {
			} else if (img_format == ImageFormat.NV16) {
			} else if (img_format == ImageFormat.NV21) {
			} else if (img_format == ImageFormat.RGB_565) {
			} else if (img_format == ImageFormat.YUY2) {
			} else if (img_format == ImageFormat.YV12) {
			} else if (img_format == ImageFormat.UNKNOWN) {
			} else {
			}
			
			// do it baby
			discotective_run(rgba_img, (short) img_size.height, (short) img_size.width);
			
			
		}
	};

	// Handles data for jpeg picture
	PictureCallback jpegCallback = new PictureCallback() {
		public void onPictureTaken(byte[] data, Camera camera) {
			FileOutputStream outStream = null;
			try {
				// write to local sandbox file system
//				outStream = CameraDemo.this.openFileOutput(String.format("%d.jpg", System.currentTimeMillis()), 0);	
				// Or write to sdcard
				outStream = new FileOutputStream(String.format("/sdcard/%d.jpg", System.currentTimeMillis()));	
				outStream.write(data);
				outStream.close();
				Log.d(TAG, "onPictureTaken - wrote bytes: " + data.length);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
			}
			Log.d(TAG, "onPictureTaken - jpeg");
		}
	};
	
	
	
	public native int discotective_run (byte[] rgba_img, short height, short width);

}
