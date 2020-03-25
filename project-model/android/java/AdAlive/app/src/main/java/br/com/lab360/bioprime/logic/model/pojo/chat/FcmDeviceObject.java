package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 10/11/2016.
 */

public class FcmDeviceObject {
    private String action;
    private String deviceId;
    private int userId;

    public FcmDeviceObject() {
    }

    public FcmDeviceObject(String action, int userId, String deviceId) {
        this.action = action;
        this.deviceId = deviceId;
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
