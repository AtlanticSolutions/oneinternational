package br.com.lab360.bioprime.logic.listeners.Chat;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnUserGroupLoadedListener {
    void onUserGropsLoadSuccess(ArrayList<BaseObject> chats);
    void onUserGroupsLoadError(String message);
}
