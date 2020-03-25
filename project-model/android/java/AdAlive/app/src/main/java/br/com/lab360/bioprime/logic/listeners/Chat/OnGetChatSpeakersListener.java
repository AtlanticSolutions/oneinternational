package br.com.lab360.bioprime.logic.listeners.Chat;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.chat.ChatUser;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnGetChatSpeakersListener {
    void onGetChatSpeakerError(String message);

    void onGetChatSpeakerSuccess(ArrayList<ChatUser> chatUsers);
}
