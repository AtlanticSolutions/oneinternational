package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public class UserGroups {
    @SerializedName("group_chats")
    private ArrayList<Integer> groups;

    public ArrayList<Integer> getGroups() {
        return groups;
    }
}
