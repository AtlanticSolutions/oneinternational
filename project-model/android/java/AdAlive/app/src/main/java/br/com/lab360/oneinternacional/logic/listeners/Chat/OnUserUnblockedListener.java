package br.com.lab360.oneinternacional.logic.listeners.Chat;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public interface OnUserUnblockedListener {
    void onUserUnblockedError(String message);
    void onUserUnblockedSuccess();
}
