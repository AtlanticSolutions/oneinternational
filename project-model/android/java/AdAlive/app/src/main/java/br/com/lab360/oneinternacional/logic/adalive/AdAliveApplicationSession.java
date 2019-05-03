//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package br.com.lab360.oneinternacional.logic.adalive;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.os.AsyncTask;
import android.os.AsyncTask.Status;
import android.os.Build.VERSION;
import android.util.DisplayMetrics;
import android.util.Log;
import br.com.lab360.adalive.R.string;
import lib.application.ARApplicationException;
import lib.application.CloudRecognitionApplication;

import com.vuforia.CameraCalibration;
import com.vuforia.CameraDevice;
import com.vuforia.Matrix44F;
import com.vuforia.PIXEL_FORMAT;
import com.vuforia.Renderer;
import com.vuforia.State;
import com.vuforia.Tool;
import com.vuforia.Vec2I;
import com.vuforia.VideoBackgroundConfig;
import com.vuforia.VideoMode;
import com.vuforia.Vuforia;
import com.vuforia.Vuforia.UpdateCallbackInterface;

import static com.vuforia.Vuforia.setFrameFormat;

public class AdAliveApplicationSession implements UpdateCallbackInterface {
    private Context context;
    private final CloudRecognitionApplication mSessionControl;
    private boolean mStarted = false;
    private boolean mCameraRunning = false;
    private int mScreenWidth = 0;
    private int mScreenHeight = 0;
    private InitAdAliveTask mInitAdAliveTask;
    private LoadTrackerTask mLoadTrackerTask;
    private final Object mShutdownLock = new Object();
    private int mAdAliveFlags = 0;
    private int mCamera = 0;
    private Matrix44F mProjectionMatrix;
    private boolean mIsPortrait = false;
    private String recognitionServiceKey;
    private int[] mViewport;

    public AdAliveApplicationSession(CloudRecognitionApplication sessionControl, String recognitionServiceKey) {
        this.mSessionControl = sessionControl;
        this.recognitionServiceKey = recognitionServiceKey;
    }

    public void initAR(Context context, int screenOrientation) {
        ARApplicationException arException = null;
        this.context = context;
        if (screenOrientation == 4 && VERSION.SDK_INT > 8) {
            screenOrientation = 10;
        }

        ((Activity)this.context).setRequestedOrientation(screenOrientation);
        this.updateActivityOrientation();
        this.storeScreenDimensions();
        ((Activity)this.context).getWindow().setFlags(128, 128);
        this.mAdAliveFlags = 1;
        if (this.mInitAdAliveTask != null) {
            String logMessage = "Cannot initialize SDK twice";
            arException = new ARApplicationException(1, logMessage);
            Log.e("--- ERROR ---", logMessage);
        }

        if (arException == null) {
            try {
                this.mInitAdAliveTask = new InitAdAliveTask();
                this.mInitAdAliveTask.execute(new Void[0]);
            } catch (Exception var6) {
                String logMessage = "Initializing Recognition SDK failed";
                arException = new ARApplicationException(0, logMessage);
                Log.e("--- ERROR ---", logMessage);
            }
        }

        if (arException != null) {
            this.mSessionControl.onInitARDone(arException);
        }

    }

    public void startAR(int camera) throws ARApplicationException {
        String error;
        if (this.mCameraRunning) {
            error = "Camera already running, unable to open again";
            Log.e("--- ERROR ---", error);
            throw new ARApplicationException(6, error);
        } else {

            this.mCamera = camera;
            if (!CameraDevice.getInstance().init(camera)) {
                error = "Unable to open camera device: " + camera;
                Log.e("--- ERROR ---", error);
                throw new ARApplicationException(6, error);
            } else if (!CameraDevice.getInstance().selectVideoMode(-1)) {
                error = "Unable to set video mode";
                Log.e("--- ERROR ---", error);
                throw new ARApplicationException(6, error);
            } else {
                this.configureVideoBackground();
                if (!CameraDevice.getInstance().start()) {
                    error = "Unable to start camera device: " + camera;
                    Log.e("--- ERROR ---", error);
                    throw new ARApplicationException(6, error);
                } else {
                    this.setProjectionMatrix();
                    this.mSessionControl.doStartTrackers();
                    this.mCameraRunning = true;
                    setFrameFormat(PIXEL_FORMAT.RGB565, true);

                    if (!CameraDevice.getInstance().setFocusMode(2) && !CameraDevice.getInstance().setFocusMode(1)) {
                        CameraDevice.getInstance().setFocusMode(0);
                    }

                }
            }
        }
    }

    public void stopAR() throws ARApplicationException {
        if (this.mInitAdAliveTask != null && this.mInitAdAliveTask.getStatus() != Status.FINISHED) {
            this.mInitAdAliveTask.cancel(true);
            this.mInitAdAliveTask = null;
        }

        if (this.mLoadTrackerTask != null && this.mLoadTrackerTask.getStatus() != Status.FINISHED) {
            this.mLoadTrackerTask.cancel(true);
            this.mLoadTrackerTask = null;
        }

        this.mInitAdAliveTask = null;
        this.mLoadTrackerTask = null;
        this.mStarted = false;
        this.stopCamera();
        Object var1 = this.mShutdownLock;
        synchronized(this.mShutdownLock) {
            boolean unloadTrackersResult = this.mSessionControl.doUnloadTrackersData();
            boolean deinitTrackersResult = this.mSessionControl.doDeinitTrackers();
            Vuforia.deinit();
            if (!unloadTrackersResult) {
                throw new ARApplicationException(4, "Failed to unload trackers' data");
            } else if (!deinitTrackersResult) {
                throw new ARApplicationException(5, "Failed to deinitialize trackers");
            }
        }
    }

    public void resumeAR() throws ARApplicationException {
        Vuforia.onResume();
        if (this.mStarted) {
            this.startAR(this.mCamera);
        }

    }

    public void pauseAR() throws ARApplicationException {
        if (this.mStarted) {
            this.stopCamera();
        }

        Vuforia.onPause();
    }

    public Matrix44F getProjectionMatrix() {
        return this.mProjectionMatrix;
    }

    public void onConfigurationChanged() {
        this.updateActivityOrientation();
        this.storeScreenDimensions();
        if (this.isARRunning()) {
            this.configureVideoBackground();
            this.setProjectionMatrix();
        }

    }

    public void onResume() {
        Vuforia.onResume();
    }

    public int[] getViewport() {
        return this.mViewport;
    }

    public void onPause() {
        Vuforia.onPause();
    }

    public void onSurfaceChanged(int width, int height) {
        Vuforia.onSurfaceChanged(width, height);
    }

    public void onSurfaceCreated() {
        Vuforia.onSurfaceCreated();
    }

    public void Vuforia_onUpdate(State state) {
        this.mSessionControl.onQCARUpdate(state);
    }

    private String getInitializationErrorString(int code) {
        if (code == -2) {
            return this.context.getString(string.INIT_ERROR_DEVICE_NOT_SUPPORTED);
        } else if (code == -3) {
            return this.context.getString(string.INIT_ERROR_NO_CAMERA_ACCESS);
        } else if (code == -4) {
            return this.context.getString(string.INIT_LICENSE_ERROR_MISSING_KEY);
        } else if (code == -5) {
            return this.context.getString(string.INIT_LICENSE_ERROR_INVALID_KEY);
        } else if (code == -7) {
            return this.context.getString(string.INIT_LICENSE_ERROR_NO_NETWORK_TRANSIENT);
        } else if (code == -6) {
            return this.context.getString(string.INIT_LICENSE_ERROR_NO_NETWORK_PERMANENT);
        } else if (code == -8) {
            return this.context.getString(string.INIT_LICENSE_ERROR_CANCELED_KEY);
        } else {
            return code == -9 ? this.context.getString(string.INIT_LICENSE_ERROR_PRODUCT_TYPE_MISMATCH) : this.context.getString(string.INIT_LICENSE_ERROR_UNKNOWN_ERROR);
        }
    }

    private void storeScreenDimensions() {
        DisplayMetrics metrics = new DisplayMetrics();
        ((Activity)this.context).getWindowManager().getDefaultDisplay().getMetrics(metrics);
        this.mScreenWidth = metrics.widthPixels;
        this.mScreenHeight = metrics.heightPixels;
    }

    private void updateActivityOrientation() {
        Configuration config = this.context.getResources().getConfiguration();
        switch(config.orientation) {
        case 0:
        default:
            break;
        case 1:
            this.mIsPortrait = true;
            break;
        case 2:
            this.mIsPortrait = false;
        }

    }

    private void setProjectionMatrix() {
        CameraCalibration camCal = CameraDevice.getInstance().getCameraCalibration();
        this.mProjectionMatrix = Tool.getProjectionGL(camCal, 10.0F, 5000.0F);
    }

    public void stopCamera() {
        if (this.mCameraRunning) {
            this.mSessionControl.doStopTrackers();
            CameraDevice.getInstance().stop();
            CameraDevice.getInstance().deinit();
            this.mCameraRunning = false;
        }

    }

    private void configureVideoBackground() {
        CameraDevice cameraDevice = CameraDevice.getInstance();
        VideoMode vm = cameraDevice.getVideoMode(-1);
        VideoBackgroundConfig config = new VideoBackgroundConfig();
        config.setEnabled(true);
        config.setPosition(new Vec2I(0, 0));
        int xSize;
        int ySize;
        if (this.mIsPortrait) {
            xSize = (int)((float)vm.getHeight() * ((float)this.mScreenHeight / (float)vm.getWidth()));
            ySize = this.mScreenHeight;
            if (xSize < this.mScreenWidth) {
                xSize = this.mScreenWidth;
                ySize = (int)((float)this.mScreenWidth * ((float)vm.getWidth() / (float)vm.getHeight()));
            }
        } else {
            xSize = this.mScreenWidth;
            ySize = (int)((float)vm.getHeight() * ((float)this.mScreenWidth / (float)vm.getWidth()));
            if (ySize < this.mScreenHeight) {
                xSize = (int)((float)this.mScreenHeight * ((float)vm.getWidth() / (float)vm.getHeight()));
                ySize = this.mScreenHeight;
            }
        }

        config.setSize(new Vec2I(xSize, ySize));
        this.mViewport = new int[4];
        this.mViewport[0] = (this.mScreenWidth - xSize) / 2 + config.getPosition().getData()[0];
        this.mViewport[1] = (this.mScreenHeight - ySize) / 2 + config.getPosition().getData()[1];
        this.mViewport[2] = xSize;
        this.mViewport[3] = ySize;
        Renderer.getInstance().setVideoBackgroundConfig(config);
    }

    private boolean isARRunning() {
        return this.mStarted;
    }

    private class LoadTrackerTask extends AsyncTask<Void, Integer, Boolean> {
        private LoadTrackerTask() {
        }

        protected Boolean doInBackground(Void... params) {
            synchronized(AdAliveApplicationSession.this.mShutdownLock) {
                return AdAliveApplicationSession.this.mSessionControl.doLoadTrackersData();
            }
        }

        protected void onPostExecute(Boolean result) {
            ARApplicationException arException = null;
            if (!result) {
                String logMessage = "Failed to load tracker data.";
                Log.e("--- ERROR ---", logMessage);
                arException = new ARApplicationException(3, logMessage);
            } else {
                System.gc();
                Vuforia.registerCallback(AdAliveApplicationSession.this);
                AdAliveApplicationSession.this.mStarted = true;
            }

            AdAliveApplicationSession.this.mSessionControl.onInitARDone(arException);
        }
    }

    private class InitAdAliveTask extends AsyncTask<Void, Integer, Boolean> {
        private int mProgressValue;

        private InitAdAliveTask() {
            this.mProgressValue = -1;
        }

        protected Boolean doInBackground(Void... params) {
            synchronized(AdAliveApplicationSession.this.mShutdownLock) {
                Vuforia.setInitParameters((Activity)AdAliveApplicationSession.this.context, AdAliveApplicationSession.this.mAdAliveFlags, AdAliveApplicationSession.this.recognitionServiceKey);

                do {
                    this.mProgressValue = Vuforia.init();
                    this.publishProgress(new Integer[]{this.mProgressValue});
                } while(!this.isCancelled() && this.mProgressValue >= 0 && this.mProgressValue < 100);

                return this.mProgressValue > 0;
            }
        }

        protected void onProgressUpdate(Integer... values) {
        }

        protected void onPostExecute(Boolean result) {
            ARApplicationException arException;
            if (result) {
                boolean initTrackersResult = AdAliveApplicationSession.this.mSessionControl.doInitTrackers();
                if (initTrackersResult) {
                    try {
                        AdAliveApplicationSession.this.mLoadTrackerTask = AdAliveApplicationSession.this.new LoadTrackerTask();
                        AdAliveApplicationSession.this.mLoadTrackerTask.execute(new Void[0]);
                    } catch (Exception var6) {
                        String logMessagex = "Loading tracking data set failed";
                        arException = new ARApplicationException(3, logMessagex);
                        Log.e("--- ERROR ---", logMessagex);
                        AdAliveApplicationSession.this.mSessionControl.onInitARDone(arException);
                    }
                } else {
                    arException = new ARApplicationException(2, "Failed to initialize trackers");
                    AdAliveApplicationSession.this.mSessionControl.onInitARDone(arException);
                }
            } else {
                String logMessage = AdAliveApplicationSession.this.getInitializationErrorString(this.mProgressValue);
                Log.e("--- ERROR ---", "InitAdAliveTask.onPostExecute: " + logMessage + " Exiting.");
                arException = new ARApplicationException(0, logMessage);
                AdAliveApplicationSession.this.mSessionControl.onInitARDone(arException);
            }

        }
    }
}
