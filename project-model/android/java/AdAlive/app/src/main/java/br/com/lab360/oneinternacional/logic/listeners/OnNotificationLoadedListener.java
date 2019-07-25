package br.com.lab360.oneinternacional.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.notification.NotificationObject;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnNotificationLoadedListener {
    void onNotificationLoadSuccess(ArrayList<NotificationObject> participantses);
    void onNotificationLoadError(String message);
}
