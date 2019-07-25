package br.com.lab360.oneinternacional.logic.listeners.Chat;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnAddChatUserListener {
    void onAddChatUserSuccess(ArrayList<Integer> groups);

    void onAddChatUserError(String message);
}
