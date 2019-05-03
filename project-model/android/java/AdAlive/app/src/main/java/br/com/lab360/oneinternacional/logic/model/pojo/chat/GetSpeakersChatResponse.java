package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class GetSpeakersChatResponse {

    @SerializedName("speakers")
    private ArrayList<ChatUser> chatSpeakers;

    public ArrayList<ChatUser> getChatSpeakers() {
        return chatSpeakers;
    }
}
