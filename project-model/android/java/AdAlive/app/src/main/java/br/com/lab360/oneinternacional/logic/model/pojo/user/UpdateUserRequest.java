package br.com.lab360.oneinternacional.logic.model.pojo.user;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 30/11/2016.
 */

public class UpdateUserRequest {
    @SerializedName("app_user")
    private User user;

    public UpdateUserRequest(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }
}
