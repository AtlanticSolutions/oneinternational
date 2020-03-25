package br.com.lab360.bioprime.logic.model.pojo.timeline;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */

public class PostCreation {
    private String title, message;
    @SerializedName("account_id")
    private int accountId;
    @SerializedName("base64_picture")
    private String pictureBase64;
    @SerializedName("app_user_id")
    private int appUserId;
    @SerializedName("app_id")
    private int appId;
    @SerializedName("master_event_id")
    private int masterEventId;

    public PostCreation(String title, String message, String pictureBase64, int accountId, int appUserId, int appId, int masterEventId) {
        this.title = title;
        this.message = message;
        this.pictureBase64 = pictureBase64;
        this.accountId = accountId;
        this.appUserId = appUserId;
        this.appId = appId;
        this.masterEventId = masterEventId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getAppUserId() {
        return appUserId;
    }

    public void setAppUserId(int appUserId) {
        this.appUserId = appUserId;
    }

    public int getAppId() {
        return appId;
    }

    public void setAppId(int appId) {
        this.appId = appId;
    }
}
