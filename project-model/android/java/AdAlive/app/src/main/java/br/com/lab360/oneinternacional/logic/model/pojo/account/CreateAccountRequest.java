package br.com.lab360.oneinternacional.logic.model.pojo.account;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.oneinternacional.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 23/11/2016.
 */
public class CreateAccountRequest {
    @SerializedName("app_user")
    private User user;

    public CreateAccountRequest(User user) {
        this.user = user;
    }

    public User getUser() {
        return user;
    }

}
