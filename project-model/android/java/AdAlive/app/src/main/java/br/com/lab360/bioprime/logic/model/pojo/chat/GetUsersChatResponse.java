package br.com.lab360.bioprime.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class GetUsersChatResponse {

    @SerializedName("app_users")
    private ArrayList<ChatUser> chatUsers;

    public ArrayList<ChatUser> getChatUsers() {
        return chatUsers;
    }

}
