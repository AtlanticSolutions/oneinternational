package br.com.lab360.bioprime.logic.model.pojo.chat;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnGetChatUsersGroupListener {
    void onGetChatGroupUsersError(String message);

    void onGetChatGroupUsersSuccess(ArrayList<ChatUser> chatUsers);
}
