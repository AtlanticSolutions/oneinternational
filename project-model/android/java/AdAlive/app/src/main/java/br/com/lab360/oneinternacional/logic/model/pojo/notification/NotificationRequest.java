package br.com.lab360.oneinternacional.logic.model.pojo.notification;

import com.google.gson.annotations.SerializedName;

/**
 * Created by VictorCS on 18/01/2017.
 */

public class NotificationRequest {

    @SerializedName("notification_id")
    private String notificationId;

    @SerializedName("app_user_id")
    private String appUserId;

    public NotificationRequest(String notificationId, String appUserId) {
        this.notificationId = notificationId;
        this.appUserId = appUserId;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public String getAppUserId() {
        return appUserId;
    }

    public void setAppUserId(String appUserId) {
        this.appUserId = appUserId;
    }
}
