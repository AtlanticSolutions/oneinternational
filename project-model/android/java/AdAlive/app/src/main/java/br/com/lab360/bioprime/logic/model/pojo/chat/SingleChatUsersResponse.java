package br.com.lab360.bioprime.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public class SingleChatUsersResponse {
    @SerializedName("single_chat_users")
    private ArrayList<SingleChatUser> singleChatUsers;

    public ArrayList<SingleChatUser> getSingleChatUsers() {
        return singleChatUsers;
    }
}
