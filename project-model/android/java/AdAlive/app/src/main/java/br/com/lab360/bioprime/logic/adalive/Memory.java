package br.com.lab360.bioprime.logic.adalive;

import android.app.AlarmManager;
import android.content.Context;
import lib.bean.geofence.RegionsResponse;
import lib.ui.VideoActionEndListener;

public class Memory {
    private static Memory instance;
    private AdAliveCamera adAliveCamera;
    private VideoActionEndListener mVideoActionEndListener;
    private boolean deviceLogExecuted;
    private RegionsResponse regionsResponse;
    private AlarmManager processTimer;
    private Context contexttrackingHelper;
    private String urlServerHelper;

    private Memory() {
    }

    public static Memory getInstance() {
        if (instance == null) {
            instance = new Memory();
        }

        return instance;
    }

    public AdAliveCamera getAdAliveCamera() {
        return this.adAliveCamera;
    }

    public void setAdAliveCamera(AdAliveCamera adAliveCamera) {
        this.adAliveCamera = adAliveCamera;
    }

    public VideoActionEndListener getmVideoActionEndListener() {
        return this.mVideoActionEndListener;
    }

    public void setmVideoActionEndListener(VideoActionEndListener mVideoActionEndListener) {
        this.mVideoActionEndListener = mVideoActionEndListener;
    }

    public boolean isDeviceLogExecuted() {
        return this.deviceLogExecuted;
    }

    public void setDeviceLogExecuted(boolean deviceLogExecuted) {
        this.deviceLogExecuted = deviceLogExecuted;
    }

    public RegionsResponse getRegionsResponse() {
        return this.regionsResponse;
    }

    public void setRegionsResponse(RegionsResponse regionsResponse) {
        this.regionsResponse = regionsResponse;
    }

    public AlarmManager getProcessTimer(Context context) {
        if (this.processTimer == null) {
            this.processTimer = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        }

        return this.processTimer;
    }

    public Context getContextTrackingHelper() {
        return this.contexttrackingHelper;
    }

    public void setContextTrackingHelper(Context contextTrackingHelper) {
        if (contextTrackingHelper != null) {
            this.contexttrackingHelper = contextTrackingHelper;
        }

    }

    public String getUrlServerHelper() {
        return this.urlServerHelper;
    }

    public void setUrlServerHelper(String urlServerHelper) {
        this.urlServerHelper = urlServerHelper;
    }
}