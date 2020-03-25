package br.com.lab360.bioprime.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */

public class ChatBlockStatusResponse {
    @SerializedName("single_chat_user")
    private UserBlockStatus userStatus;

    public UserBlockStatus getUserStatus() {
        return userStatus;
    }
}
