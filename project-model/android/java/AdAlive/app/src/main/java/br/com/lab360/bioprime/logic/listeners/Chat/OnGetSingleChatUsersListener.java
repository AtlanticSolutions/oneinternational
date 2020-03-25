package br.com.lab360.bioprime.logic.listeners.Chat;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.chat.SingleChatUser;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public interface OnGetSingleChatUsersListener {

    void onGetSingleChatUsersSuccess(ArrayList<SingleChatUser> groups);
    void onGetSingleChatUsersError(String message);

}
