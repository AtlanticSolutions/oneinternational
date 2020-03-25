package br.com.lab360.bioprime.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public class GetChatGroupsResponse {
    @SerializedName("group_chats")
    private ArrayList<BaseObject> groups;

    public ArrayList<BaseObject> getGroups() {
        return groups;
    }
}
