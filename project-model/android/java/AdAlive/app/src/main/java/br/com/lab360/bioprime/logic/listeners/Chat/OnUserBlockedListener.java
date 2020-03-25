package br.com.lab360.bioprime.logic.listeners.Chat;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public interface OnUserBlockedListener {
    void onUserBlockedSuccess();

    void onUserBlockedError(String message);
}
