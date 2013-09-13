package com.discotective;

// from http://marakana.com/forums/android/examples/39.html

//import java.io.FileNotFoundException;
//import java.io.FileOutputStream;
import java.io.IOException;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.hardware.Camera;
//import android.hardware.Camera.PreviewCallback;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;


class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {
	private static final String TAG = "CameraDemo";

	SurfaceHolder	mHolder;
	public Camera	camera = null;

	CameraPreview (Context context) {
		super(context);
		
		
		Log.d(TAG, "preview called");
		
		// Install a SurfaceHolder.Callback so we get notified when the
		// underlying surface is created and destroyed.
		mHolder = getHolder();
		Log.d(TAG, "got holder");
		mHolder.addCallback(this);
		Log.d(TAG, "added callback");
		mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
		Log.d(TAG, "set type");
	}

	public void surfaceCreated (SurfaceHolder holder) {
		// The Surface has been created, acquire the camera and tell it where
		// to draw.
		Log.d(TAG, "surface calledback");
		try {
			camera = Camera.open();
		} catch (RuntimeException ex) {
			Log.d(TAG, "camera open err");
			Log.e(TAG, "exception", ex);
		//	ex.printStackTrace();
		}
		Log.d(TAG, "camera opened");
		try {
			camera.setPreviewDisplay(holder);
			Log.d(TAG, "camera set preview");
						
		//	camera.setPreviewCallback(new PreviewCallback() {

		//		public void onPreviewFrame (byte[] data, Camera arg1) {
		//			FileOutputStream outStream = null;
		//			try {
		//				outStream = new FileOutputStream(String.format("/sdcard/%d.jpg", System.currentTimeMillis()));	
		//				outStream.write(data);
		//				outStream.close();
		//				Log.d(TAG, "onPreviewFrame - wrote bytes: " + data.length);
		//			} catch (FileNotFoundException e) {
		//				e.printStackTrace();
		//			} catch (IOException e) {
		//				e.printStackTrace();
		//			} finally {
		//			}
		//			CameraPreview.this.invalidate();
		//		}
		//	});
		} catch (IOException e) {
			Log.d(TAG, "camera preview err");
			e.printStackTrace();
		}
	}

	public void surfaceDestroyed (SurfaceHolder holder) {
		// Surface will be destroyed when we return, so stop the preview.
		// Because the CameraDevice object is not a shared resource, it's very
		// important to release it when the activity is paused.
		camera.stopPreview();
		camera = null;
	}

	public void surfaceChanged (SurfaceHolder holder, int format, int w, int h) {
		// Now that the size is known, set up the camera parameters and begin
		// the preview.
		Camera.Parameters parameters = camera.getParameters();
		parameters.setPreviewSize(w, h);
		camera.setParameters(parameters);
		camera.startPreview();
	}

	@Override
	public void draw (Canvas canvas) {
			super.draw(canvas);
			Paint	p = new Paint(Color.RED);
			Log.d(TAG,"draw");
			canvas.drawText("PREVIEW", canvas.getWidth()/2, canvas.getHeight()/2, p );
	}
}