package br.com.lab360.bioprime.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationObject;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnNotificationLoadedListener {
    void onNotificationLoadSuccess(ArrayList<NotificationObject> participantses);
    void onNotificationLoadError(String message);
}
