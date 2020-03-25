package br.com.lab360.bioprime.logic.listeners.Chat;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnRemoveChatUserListener {
    void onRemoveChatUserSuccess(ArrayList<Integer> groups);

    void onRemoveChatUserError(String message);
}
