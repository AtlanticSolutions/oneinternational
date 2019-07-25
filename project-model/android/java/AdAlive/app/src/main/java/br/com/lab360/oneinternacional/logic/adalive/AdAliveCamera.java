package br.com.lab360.oneinternacional.logic.adalive;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Handler;
import android.util.Log;
import android.view.GestureDetector;
import android.view.GestureDetector.OnDoubleTapListener;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.WindowManager.LayoutParams;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.vuforia.CameraDevice;
import com.vuforia.Frame;
import com.vuforia.Image;
import com.vuforia.ObjectTracker;
import com.vuforia.PIXEL_FORMAT;
import com.vuforia.State;
import com.vuforia.TargetFinder;
import com.vuforia.TargetSearchResult;
import com.vuforia.Trackable;
import com.vuforia.Tracker;
import com.vuforia.TrackerManager;
import com.vuforia.Vuforia;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import br.com.lab360.adalive.R.string;
import br.com.lab360.oneinternacional.R;
import lib.application.ARApplicationException;
import lib.application.CloudRecognitionApplication;
import lib.error.AdAliveCameraAccessException;
import lib.error.IllegalSizeException;
import lib.error.NullActionParamException;
import lib.error.NullUrlServerException;
import lib.hardware.video.VideoPlayerHelper;
import lib.hardware.video.VideoPlayerHelper.MEDIA_STATE;
import lib.location.GPSTracker;
import lib.manager.LogManager;
import lib.ui.VideoActionEndListener;
import lib.ui.VideoReachedEndListener;
import lib.ui.action.VideoActionActivity;
import lib.utils.AdAliveApplicationGLView;
import lib.utils.AdAliveTexture;
import lib.utils.LoadDialogHandler;
import lib.web.MethodsAdAliveManager;

public class AdAliveCamera extends AdAliveBase implements CloudRecognitionApplication {
    private static final int UPDATE_ERROR_AUTHORIZATION_FAILED = -1;
    private static final int UPDATE_ERROR_PROJECT_SUSPENDED = -2;
    private static final int UPDATE_ERROR_NO_NETWORK_CONNECTION = -3;
    private static final int UPDATE_ERROR_SERVICE_NOT_AVAILABLE = -4;
    private static final int UPDATE_ERROR_BAD_FRAME_QUALITY = -5;
    private static final int UPDATE_ERROR_UPDATE_SDK = -6;
    private static final int UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE = -7;
    private static final int UPDATE_ERROR_REQUEST_TIMEOUT = -8;
    private int mInitErrorCode = 0;
    private boolean mFinderStarted = false;
    private AdAliveApplicationGLView mGlView;
    private AdAliveApplicationSession adAliveAppSession;
    private RelativeLayout mUILayout;
    private LoadDialogHandler loadingDialogHandler;
    private CloudRecoRenderer mCloudRenderer;
    private static final int HIDE_LOADING_DIALOG = 0;
    private Vector<AdAliveTexture> mAdAliveTextures;
    private int mlastErrorCode = 0;
    private boolean mIsDroidDevice = false;
    private Context context;
    private int idLayout;
    private int idContainerLoading;
    private String accessKey;
    private String secretKey;
    private String recognitionServiceKey;
    private String urlServer;
    private String targetName;
    private VideoPlayerHelper mVideoPlayerHelper = null;
    private GestureDetector mGestureDetector = null;
    private boolean isVideoAR;
    private boolean isVideoARTransp = false;
    private VideoReachedEndListener mVideoReachedEndListener;
    private LinearLayout llButtonsContainer;
    private List<Integer> listVideoAssets = new ArrayList();
    private LogManager logManager;
    public Image rgb;


    public AdAliveCamera(Context context, int idLayout, int idContainerLoading, String accessKey, String secretKey, String recognitionServiceKey, String urlServer, String userEmail) throws NullUrlServerException {
        this.context = context;
        this.idLayout = idLayout;
        this.idContainerLoading = idContainerLoading;
        this.accessKey = accessKey;
        this.secretKey = secretKey;
        this.recognitionServiceKey = recognitionServiceKey;
        this.urlServer = urlServer;
        GPSTracker gpsTracker = new GPSTracker(context);
        gpsTracker.beginUpdates();
        this.logManager = new LogManager(context, userEmail, gpsTracker);
        if (urlServer == null) {
            throw new NullUrlServerException("Url server not set.");
        } else {
            this.loadingDialogHandler = new LoadDialogHandler(context);
            if (!Memory.getInstance().isDeviceLogExecuted()) {
                Memory.getInstance().setDeviceLogExecuted(true);
                (new Handler()).postDelayed(new Runnable() {
                    public void run() {
                        AdAliveCamera.this.callDeviceLog();
                    }
                }, 120000L);
            }

            this.urlServer = !urlServer.contains("http://") && !urlServer.contains("https://") ? "http://" + urlServer : urlServer;
            MethodsAdAliveManager.getInstance().setHost(this.urlServer);
        }
    }

    public void startRecognitionService() throws AdAliveCameraAccessException {
        if (VERSION.SDK_INT >= 23) {
            int hasCameraPermission = this.context.checkSelfPermission("android.permission.CAMERA");
            if (hasCameraPermission != 0) {
                throw new AdAliveCameraAccessException("Could not access the camera to start the AdAlive SDK.");
            }

            this.start();
        } else {
            this.start();
        }

    }

    private void start() {
        this.initRecognitionService(this.recognitionServiceKey);
    }

    private void initRecognitionService(String recognitionServiceKey) {
        this.adAliveAppSession = new AdAliveApplicationSession(this, recognitionServiceKey);
        this.startLoadingAnimation();
        this.adAliveAppSession.initAR(this.context, 1);
        this.mAdAliveTextures = new Vector();
        this.loadVideoTextures();
    }

    private void startLoadingAnimation() {
        LayoutInflater inflater = LayoutInflater.from(this.context);
        this.mUILayout = (RelativeLayout)inflater.inflate(this.idLayout, (ViewGroup)null, false);
        this.mUILayout.setVisibility(View.VISIBLE);
        this.mUILayout.setBackgroundColor(-1);
        if (this.idContainerLoading != 0) {
            this.loadingDialogHandler.mLoadingDialogContainer = this.mUILayout.findViewById(this.idContainerLoading);
            this.loadingDialogHandler.mLoadingDialogContainer.setVisibility(View.VISIBLE);
        }

        ((Activity)this.context).addContentView(this.mUILayout, new LayoutParams(-1, -1));
    }

    private void callDeviceLog() {
        MethodsAdAliveManager.getInstance().setHost(this.urlServer);
        this.logManager.execCallDeviceLog();
    }

    public boolean doInitTrackers() {
        TrackerManager tManager = TrackerManager.getInstance();
        boolean result = true;
        Tracker tracker = tManager.initTracker(ObjectTracker.getClassType());
        if (tracker == null) {
            Log.e("--- ERROR ---", "Tracker not initialized. Tracker already initialized or the camera is already started");
            result = false;
        }

        return result;
    }

    public boolean doLoadTrackersData() {
        TrackerManager trackerManager = TrackerManager.getInstance();
        ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
        TargetFinder targetFinder = objectTracker.getTargetFinder();
        if (targetFinder.startInit(this.accessKey, this.secretKey)) {
            targetFinder.waitUntilInitFinished();
        }

        int resultCode = targetFinder.getInitState();
        if (resultCode != 2) {
            if (resultCode == -1) {
                this.mInitErrorCode = -3;
            } else {
                this.mInitErrorCode = -4;
            }

            Log.e("--- ERROR ---", "Failed to initialize target finder.");
            return false;
        } else {
            return true;
        }
    }

    public boolean doStartTrackers() {
        TrackerManager trackerManager = TrackerManager.getInstance();
        ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
        objectTracker.start();
        TargetFinder targetFinder = objectTracker.getTargetFinder();
        targetFinder.startRecognition();
        this.mFinderStarted = true;
        return true;
    }

    public boolean doStopTrackers() {
        boolean result = true;
        TrackerManager trackerManager = TrackerManager.getInstance();
        ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
        if (objectTracker != null) {
            objectTracker.stop();
            TargetFinder targetFinder = objectTracker.getTargetFinder();
            targetFinder.stop();
            this.mFinderStarted = false;
            targetFinder.clearTrackables();
        } else {
            result = false;
        }

        return result;
    }

    public boolean doUnloadTrackersData() {
        return true;
    }

    public boolean doDeinitTrackers() {
        try {
            TrackerManager tManager = TrackerManager.getInstance();
            tManager.deinitTracker(ObjectTracker.getClassType());
        } catch (Exception var2) {
            Log.e("--- ERROR ---", "doDeinitTrackers: " + var2);
        }

        return true;
    }

    public void onInitARDone(ARApplicationException exception) {
        if (exception == null) {
            this.initApplicationAR();
            this.mCloudRenderer.setmIsActive(true);
            ((Activity)this.context).addContentView(this.mGlView, new LayoutParams(-1, -1));

            try {
                this.adAliveAppSession.startAR(0);
            } catch (ARApplicationException var3) {
                Log.e("--- ERROR ---", var3.getString());
            }

            boolean result = CameraDevice.getInstance().setFocusMode(2);
            if (!result) {
                Log.e("--- ERROR ---", "Unable to enable continuous autofocus");
            }

            this.mUILayout.bringToFront();
            this.mUILayout.setBackgroundColor(0);
            if (this.idContainerLoading != 0) {
                this.loadingDialogHandler.sendEmptyMessage(0);
                this.loadingDialogHandler.mLoadingDialogContainer.setVisibility(View.GONE);
            }
        } else {
            Log.e("--- ERROR ---", exception.getString());
            if (this.mInitErrorCode != 0) {
                this.showErrorMessage(this.mInitErrorCode, 10.0D);
            } else {
                this.showInitializationErrorMessage(exception.getString());
            }
        }

    }

    private void showErrorMessage(int errorCode, double errorTime) {
        if (errorTime >= 5.0D && errorCode != this.mlastErrorCode) {
            this.mlastErrorCode = errorCode;
            ((Activity)this.context).runOnUiThread(new Runnable() {
                public void run() {
                    Log.e(AdAliveCamera.this.getStatusTitleString(AdAliveCamera.this.mlastErrorCode), AdAliveCamera.this.getStatusDescString(AdAliveCamera.this.mlastErrorCode));
                }
            });
        }
    }

    private void showInitializationErrorMessage(final String message) {
        ((Activity)this.context).runOnUiThread(new Runnable() {
            public void run() {
                Log.e(AdAliveCamera.this.context.getString(string.INIT_ERROR), message);
            }
        });
    }

    public void onQCARUpdate(State state) {
        TrackerManager trackerManager = TrackerManager.getInstance();
        ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
        TargetFinder finder = objectTracker.getTargetFinder();
        int statusCode = finder.updateSearchResults();
        if (statusCode < 0) {
            this.showErrorMessage(statusCode, state.getFrame().getTimeStamp());
        } else if (statusCode == 2 && finder.getResultCount() > 0) {
            TargetSearchResult result = finder.getResult(0);
            if (result.getTrackingRating() > 0) {
                Trackable trackable = finder.enableTracking(result);
                String codeObject = trackable.getName();
                this.setTargetName(codeObject);
                this.callTargetLog();
            }
        }

        this.setTargetName((String)null);

        Frame frame = state.getFrame();
        long num = frame.getNumImages();


        for(int i = 0; i < num; i++){
            //Log.e("FORMAT", ""+frame.getImage(i).getFormat());
            if(frame.getImage(i).getFormat() == PIXEL_FORMAT.RGB565){
                rgb = frame.getImage(i);
                break;
            }
        }

    }

    public Image getImage(){
        return rgb;
    }

    private void callTargetLog() {
        this.logManager.execCallTargetLog(this.targetName);
    }

    private void initApplicationAR() {
        int depthSize = 16;
        int stencilSize = 0;
        boolean translucent = Vuforia.requiresAlpha();
        this.mGlView = new AdAliveApplicationGLView(this.context);
        this.mGlView.init(translucent, depthSize, stencilSize);
        this.mVideoPlayerHelper = new VideoPlayerHelper();
        this.mVideoPlayerHelper.init();
        this.mVideoPlayerHelper.setActivity((Activity)this.context);
        this.mCloudRenderer = new CloudRecoRenderer(this.context, this.adAliveAppSession, this, this.mVideoPlayerHelper, 0);
        this.mCloudRenderer.setTextures(this.mAdAliveTextures);
        this.mGlView.setRenderer(this.mCloudRenderer);
    }

    public void stopFinderIfStarted() {
        if (this.mFinderStarted) {
            this.mFinderStarted = false;
            TrackerManager trackerManager = TrackerManager.getInstance();
            ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
            TargetFinder targetFinder = objectTracker.getTargetFinder();
            targetFinder.stop();
        }

    }

    public void startFinderIfStopped() {
        if (!this.mFinderStarted) {
            this.mFinderStarted = true;
            TrackerManager trackerManager = TrackerManager.getInstance();
            ObjectTracker objectTracker = (ObjectTracker)trackerManager.getTracker(ObjectTracker.getClassType());
            if (objectTracker != null) {
                TargetFinder targetFinder = objectTracker.getTargetFinder();
                targetFinder.clearTrackables();
                targetFinder.startRecognition();
            }
        }

    }

    private String getStatusDescString(int code) {
        if (code == -1) {
            return this.context.getString(string.UPDATE_ERROR_AUTHORIZATION_FAILED_DESC);
        } else if (code == -2) {
            return this.context.getString(string.UPDATE_ERROR_PROJECT_SUSPENDED_DESC);
        } else if (code == -3) {
            return this.context.getString(string.UPDATE_ERROR_NO_NETWORK_CONNECTION_DESC);
        } else if (code == -4) {
            return this.context.getString(string.UPDATE_ERROR_SERVICE_NOT_AVAILABLE_DESC);
        } else if (code == -6) {
            return this.context.getString(string.UPDATE_ERROR_UPDATE_SDK_DESC);
        } else if (code == -7) {
            return this.context.getString(string.UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE_DESC);
        } else if (code == -8) {
            return this.context.getString(string.UPDATE_ERROR_REQUEST_TIMEOUT_DESC);
        } else {
            return code == -5 ? this.context.getString(string.UPDATE_ERROR_BAD_FRAME_QUALITY_DESC) : this.context.getString(string.UPDATE_ERROR_UNKNOWN_DESC);
        }
    }

    private String getStatusTitleString(int code) {
        if (code == -1) {
            return this.context.getString(string.UPDATE_ERROR_AUTHORIZATION_FAILED_TITLE);
        } else if (code == -2) {
            return this.context.getString(string.UPDATE_ERROR_PROJECT_SUSPENDED_TITLE);
        } else if (code == -3) {
            return this.context.getString(string.UPDATE_ERROR_NO_NETWORK_CONNECTION_TITLE);
        } else if (code == -4) {
            return this.context.getString(string.UPDATE_ERROR_SERVICE_NOT_AVAILABLE_TITLE);
        } else if (code == -6) {
            return this.context.getString(string.UPDATE_ERROR_UPDATE_SDK_TITLE);
        } else if (code == -7) {
            return this.context.getString(string.UPDATE_ERROR_TIMESTAMP_OUT_OF_RANGE_TITLE);
        } else if (code == -8) {
            return this.context.getString(string.UPDATE_ERROR_REQUEST_TIMEOUT_TITLE);
        } else {
            return code == -5 ? this.context.getString(string.UPDATE_ERROR_BAD_FRAME_QUALITY_TITLE) : this.context.getString(string.UPDATE_ERROR_UNKNOWN_TITLE);
        }
    }

    public void resumeRecognitionService() {
        if (this.mIsDroidDevice) {
            ((Activity)this.context).setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            ((Activity)this.context).setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }

        if (this.adAliveAppSession != null) {
            try {
                this.adAliveAppSession.resumeAR();
            } catch (ARApplicationException var2) {
                Log.e("--- ERROR ---", var2.getString());
            }
        }

        if (this.mGlView != null) {
            this.mGlView.setVisibility(View.VISIBLE);
            this.mGlView.onResume();
        }

        if (this.isVideoAR) {
            this.mCloudRenderer.resumeServiceVideoAR();
        }

    }

    public void pauseRecognitionService() {
        if (this.adAliveAppSession != null) {
            try {
                this.adAliveAppSession.pauseAR();
            } catch (ARApplicationException var2) {
                Log.e("--- ERROR ---", var2.getString());
            }
        }

        if (this.mGlView != null) {
            this.mGlView.setVisibility(View.VISIBLE);
            this.mGlView.onPause();
        }

        if (this.isVideoAR) {
            this.mCloudRenderer.pauseServiceVideoAR();
        }

    }

    public void stopRecognitionService() {
        if (this.adAliveAppSession != null) {
            try {
                this.adAliveAppSession.stopAR();
            } catch (ARApplicationException var2) {
                Log.e("--- ERROR ---", var2.getString());
            }

            if (this.isVideoAR) {
                this.mCloudRenderer.stopServiceVideoAR();
            }
        }

        System.gc();
    }

    public void updateConfigurationService() {
        this.adAliveAppSession.onConfigurationChanged();
    }

    public AdAliveApplicationSession getAdAliveAppSession() {
        return this.adAliveAppSession;
    }

    private void setTargetName(String targetName) {
        synchronized(this) {
            this.targetName = targetName;
        }

        this.setChanged();
        this.notifyObservers();
    }

    public synchronized String getTargetName() {
        return this.targetName;
    }

    public void playVideoAction(String urlVideo, Context context, VideoActionEndListener mVideoActionEndListener, boolean isEndCloseVideo) throws NullActionParamException {
        if (urlVideo != null && context != null) {
            if (!urlVideo.equals("")) {
                this.setmVideoActionEndListener(mVideoActionEndListener);
                Memory.getInstance().setAdAliveCamera(this);
                Intent i = new Intent(context, VideoActionActivity.class);
                i.putExtra("video_url", urlVideo);
                i.putExtra("close-video", isEndCloseVideo);
                context.startActivity(i);
            } else {
                throw new NullActionParamException("Action params uninformed.");
            }
        } else {
            throw new NullActionParamException("Action params uninformed.");
        }
    }

    public void playVideoAR(int actionId, String urlVideoAR, boolean isVideoARTransp, List<ButtonAR> buttonARArrayList,
                            ClickButtonARListener listener) throws NullActionParamException, IllegalSizeException {
        this.isVideoARTransp = isVideoARTransp;
        if (urlVideoAR != null) {
            if (!urlVideoAR.equals("")) {
                this.isVideoAR = true;
                this.mCloudRenderer.setVideoAR(true);
                this.mCloudRenderer.setUrlVideoAR(urlVideoAR);
                SimpleOnGestureListener mSimpleListener = new GestureListener();
                this.mGestureDetector = new GestureDetector(this.context, mSimpleListener);
                this.mIsDroidDevice = Build.MODEL.toLowerCase().startsWith("droid");
                this.mGestureDetector.setOnDoubleTapListener(new OnDoubleTapListener() {
                    public boolean onDoubleTap(MotionEvent e) {
                        return false;
                    }

                    public boolean onDoubleTapEvent(MotionEvent e) {
                        return false;
                    }

                    public boolean onSingleTapConfirmed(MotionEvent e) {
                        boolean isSingleTapHandled = false;
                        if (AdAliveCamera.this.mCloudRenderer != null && AdAliveCamera.this.mCloudRenderer.isTapOnScreenInsideTarget(e.getX(), e.getY())) {
                            if (AdAliveCamera.this.mVideoPlayerHelper != null && AdAliveCamera.this.mVideoPlayerHelper.isPlayableOnTexture() && (AdAliveCamera.this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.PAUSED || AdAliveCamera.this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.READY || AdAliveCamera.this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.STOPPED || AdAliveCamera.this.mVideoPlayerHelper.getStatus() == MEDIA_STATE.REACHED_END)) {
                                AdAliveCamera.this.mCloudRenderer.playVideoPlayback();
                            }

                            isSingleTapHandled = true;
                        }

                        return isSingleTapHandled;
                    }
                });
                this.mCloudRenderer.playVideoPlayback();
                if (buttonARArrayList != null) {
                    if (buttonARArrayList.size() > 3) {
                        throw new IllegalSizeException("List is already at maximum size of the 3.");
                    }

                    this.createButtonAR(actionId, buttonARArrayList, listener);
                }

            } else {
                throw new NullActionParamException("Action params uninformed.");
            }
        } else {
            throw new NullActionParamException("Action params uninformed.");
        }
    }

    public void stopVideoAR() {
        this.mCloudRenderer.lostTargetUpdateStatus();
        this.mGestureDetector = null;
        this.isVideoAR = false;
        this.removeButtonsAR();
    }

    private void pauseAll() {
        if (this.mVideoPlayerHelper != null && this.mVideoPlayerHelper.isPlayableOnTexture()) {
            this.mVideoPlayerHelper.pause();
        }

    }

    public void setListVideoAssets(List<Integer> listVideoAssets) {
        if (listVideoAssets != null) {
            if (listVideoAssets.size() > 3) {
                this.listVideoAssets = listVideoAssets;
                return;
            }
        } else {
            this.listVideoAssets = new ArrayList();
        }

        this.listVideoAssets.add(R.drawable.nothing);
        this.listVideoAssets.add(R.drawable.nothing);
        this.listVideoAssets.add(R.drawable.nothing);
    }

    private void loadVideoTextures() {
        this.mAdAliveTextures.add(AdAliveTexture.loadTextureFromApk("video_ar/video_background.png", this.context.getAssets()));
        this.mAdAliveTextures.add(AdAliveTexture.loadTextureFromApk("video_ar/busy.png", this.context.getAssets()));
        this.mAdAliveTextures.add(AdAliveTexture.loadTextureFromApk("video_ar/error.png", this.context.getAssets()));
        //this.mAdAliveTextures.add(AdAliveTexture.loadTextureFromRes(context, R.drawable.nothing));
    }

    public void resultVideoAR(int requestCode, int resultCode, Intent data) {
        if (requestCode == 1) {
            ((Activity)this.context).setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
            if (resultCode == -1) {
                String movieBeingPlayed = data.getStringExtra("movieName");
                boolean mReturningFromFullScreen = true;
                this.mCloudRenderer.resultVideoAR(movieBeingPlayed, data);
            }
        }

    }

    public void onTouchVideoARMotionEvent(MotionEvent event) {
        if (this.mGestureDetector != null) {
            this.mGestureDetector.onTouchEvent(event);
        }

    }

    public void setVideoReachedEndListener(VideoReachedEndListener listen) {
        this.mVideoReachedEndListener = listen;
    }

    public VideoReachedEndListener getVideoReachedEndListener() {
        return this.mVideoReachedEndListener;
    }

    public boolean isVideoARTransp() {
        return this.isVideoARTransp;
    }

    private void setmVideoActionEndListener(VideoActionEndListener mVideoActionEndListener) {
        Memory.getInstance().setmVideoActionEndListener(mVideoActionEndListener);
    }

    private void createButtonAR(int actionId, List<ButtonAR> buttonARArrayList, ClickButtonARListener listener) {
        if (this.mUILayout != null && buttonARArrayList != null) {
            this.llButtonsContainer = new LinearLayout(this.context);
            this.llButtonsContainer.setOrientation(LinearLayout.HORIZONTAL);
            this.configButtonARViews(actionId, buttonARArrayList, listener);
            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(-1, -2);
            layoutParams.addRule(12, this.llButtonsContainer.getId());
            this.llButtonsContainer.setLayoutParams(layoutParams);
            this.mUILayout.addView(this.llButtonsContainer);
        }

    }

    private void configButtonARViews(int actionId, List<ButtonAR> buttonARArrayList, final ClickButtonARListener listener) {
        Iterator var3 = buttonARArrayList.iterator();

        while(var3.hasNext()) {
            final ButtonAR buttonAR = (ButtonAR)var3.next();
            buttonAR.setActionId(actionId);
            final Button button = new Button(this.context);
            button.setId(buttonAR.getId());
            button.setBackgroundColor(Color.parseColor(buttonAR.getBgColor()));
            button.setText(buttonAR.getTitle());
            button.setTextColor(Color.parseColor(buttonAR.getTitleColor()));
            //if (buttonAR.getClickButtonARListener() != null) {
                button.setOnClickListener(new OnClickListener() {
                    public void onClick(View v) {
                        listener.onClickButtonARListener(buttonAR.getHref());
                        AdAliveCamera.this.logManager.execCallActionButtonArLog(buttonAR.getActionId(), button.getId());
                    }
                });
            //}

            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2, 1.0F);
            layoutParams.setMargins(5, 5, 5, 5);
            button.setLayoutParams(layoutParams);
            this.llButtonsContainer.addView(button);
        }

    }

    public LinearLayout getLlButtonsContainer(){
        return llButtonsContainer;
    }

    private void removeButtonsAR() {
        if (this.mUILayout != null && this.llButtonsContainer != null) {
            ((Activity)this.context).runOnUiThread(new Runnable() {
                public void run() {
                    AdAliveCamera.this.mUILayout.removeView(AdAliveCamera.this.llButtonsContainer);
                    AdAliveCamera.this.llButtonsContainer = null;
                }
            });
        }

    }

    private class GestureListener extends SimpleOnGestureListener {
        private final Handler autofocusHandler;

        private GestureListener() {
            this.autofocusHandler = new Handler();
        }

        public boolean onDown(MotionEvent e) {
            return true;
        }

        public boolean onSingleTapUp(MotionEvent e) {
            this.autofocusHandler.postDelayed(new Runnable() {
                public void run() {
                    boolean result = CameraDevice.getInstance().setFocusMode(2);
                    if (!result) {
                        Log.e("--- ERROR ---", "Unable to trigger focus");
                    }

                }
            }, 1000L);
            return true;
        }
    }

}

