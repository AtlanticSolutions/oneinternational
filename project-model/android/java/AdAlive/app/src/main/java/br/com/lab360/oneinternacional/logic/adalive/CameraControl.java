package br.com.lab360.oneinternacional.logic.adalive;

import android.app.Activity;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;


public class CameraControl {
    private boolean flashlightOnOff;
    private boolean hasFlash;
    private boolean isCameraFront;
    private boolean hasFrontAndBackCamera;
    private Activity activity;
    private AdAliveCamera adAliveCamera;
    private AdAliveApplicationSession adAliveApplicationSession;
    private View ivFlash;
    private View ivCamera;
    public static final int CAMERA_DEFAULT = 0;
    protected static final int CAMERA_BACK = 1;
    protected static final int CAMERA_FRONT = 2;
    public static final int FOCUS_MODE_CONTINUOUSAUTO = 2;

    public CameraControl(Activity activity, AdAliveCamera adAliveCamera, AdAliveApplicationSession adAliveApplicationSession) {
        this.activity = activity;
        this.adAliveCamera = adAliveCamera;
        this.adAliveApplicationSession = adAliveApplicationSession;
        this.verifyHasFlash();
        this.verifyHasCameraFront();
    }

    public CameraControl(Activity activity, AdAliveCamera adAliveCamera, AdAliveApplicationSession adAliveApplicationSession, View ivFlash, View ivCamera) {
        this.activity = activity;
        this.adAliveCamera = adAliveCamera;
        this.adAliveApplicationSession = adAliveApplicationSession;
        this.ivFlash = ivFlash;
        this.ivCamera = ivCamera;
        this.verifyHasFlash();
        this.verifyHasCameraFront();
    }

    public void initCameraOperation() {
        if (this.ivFlash != null && this.ivCamera != null) {
            this.configListenerImageView();
            this.configVisibleImageView();
        }

    }

    private void configListenerImageView() {
        this.ivFlash.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                if (!CameraControl.this.isCurrentFrontCamera()) {
                    CameraControl.this.switchFlashlight();
                } else {
                    CameraControl.this.flashlightOff();
                }

            }
        });
        this.ivCamera.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                CameraControl.this.switchCamera();
                if (CameraControl.this.isCameraFront) {
                    CameraControl.this.flashlightOff();
                }

            }
        });
    }

    private void configVisibleImageView() {
        boolean hasFlash = this.hasCameraFlash();
        int visibleImageView = hasFlash ? 0 : 8;
        this.ivFlash.setVisibility(View.GONE);
        boolean hasFrontCamera = this.hasFrontCamera();
        visibleImageView = hasFrontCamera ? 0 : 8;
        this.ivCamera.setVisibility(View.GONE);
    }

    public void switchCamera() {
        int idCamera = 0;
        if (this.hasFrontAndBackCamera) {
            this.adAliveApplicationSession.stopCamera();
            //byte idCamera;
            if (this.isCameraFront) {
                this.isCameraFront = false;
                idCamera = 1;
            } else {
                this.isCameraFront = true;
                idCamera = 2;
            }

            try {
                this.adAliveApplicationSession.startAR(idCamera);
            } catch (Exception var3) {
                Log.e("--- ERROR ---", var3.toString());
            }

            this.adAliveCamera.doStartTrackers();
        }

    }

    private void verifyHasCameraFront() {
        CameraInfo ci = new CameraInfo();
        boolean hasFrontCamera = false;
        boolean hasBackCamera = false;

        for(int i = 0; i < Camera.getNumberOfCameras(); ++i) {
            Camera.getCameraInfo(i, ci);

            if (ci.facing == 1) {
                hasFrontCamera = true;
            } else if (ci.facing == 0) {
                hasBackCamera = true;
            }
        }

        this.hasFrontAndBackCamera = hasBackCamera && hasFrontCamera;
    }

    public boolean hasFrontCamera() {
        return this.hasFrontAndBackCamera;
    }

    public boolean isCurrentFrontCamera() {
        return this.isCameraFront;
    }

    public void switchFlashlight() {
        if (this.hasFlash) {
            if (this.flashlightOnOff) {
                this.flashlightOff();
            } else {
                this.flashlightOn();
            }
        }

    }

    private void flashlightOn() {
        this.flashlightOnOff = true;
        //CameraDevice.setTouchLight(true);
    }

    private void flashlightOff() {
        this.flashlightOnOff = false;
        //CameraDevice.setTouchLight(false);
    }

    private void verifyHasFlash() {
        this.hasFlash = this.activity.getPackageManager().hasSystemFeature("android.hardware.camera.flash");
    }

    public boolean hasCameraFlash() {
        return this.hasFlash;
    }


    /*public static boolean setFocusMode(int mode) {
        return CameraDevice.setFocusMode(mode);
    }*/
}