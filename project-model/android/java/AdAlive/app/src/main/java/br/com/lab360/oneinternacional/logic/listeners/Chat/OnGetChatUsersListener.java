package br.com.lab360.oneinternacional.logic.listeners.Chat;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatUser;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnGetChatUsersListener {
    void onGetChatUsersError(String message);

    void onGetChatUsersSuccess(ArrayList<ChatUser> chatUsers);
}
