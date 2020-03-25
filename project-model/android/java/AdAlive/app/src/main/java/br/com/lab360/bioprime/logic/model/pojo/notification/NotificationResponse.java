package br.com.lab360.bioprime.logic.model.pojo.notification;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;


public class NotificationResponse {

    @SerializedName("pushs")
    private ArrayList<NotificationObject> notifications;

    public ArrayList<NotificationObject> getNotifications() {
        return notifications;
    }
}
