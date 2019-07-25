package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */

public class UserBlockStatus {
    @SerializedName("app_user_id")
    private int userId;
    @SerializedName("profile_image")
    private String profileImageURL;

    private String name, status;

    public int getUserId() {
        return userId;
    }

    public String getProfileImageURL() {
        return profileImageURL;
    }

    public String getName() {
        return name;
    }

    public String getStatus() {
        return status;
    }
}
