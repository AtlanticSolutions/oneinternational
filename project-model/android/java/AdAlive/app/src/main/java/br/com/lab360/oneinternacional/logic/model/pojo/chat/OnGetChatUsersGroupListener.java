package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnGetChatUsersGroupListener {
    void onGetChatGroupUsersError(String message);

    void onGetChatGroupUsersSuccess(ArrayList<ChatUser> chatUsers);
}
