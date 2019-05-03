package br.com.lab360.oneinternacional.logic.rxbus.events;

import java.util.Map;

/**
 * Created by Victor Santiago on 16/01/2017.
 */

public class InteractiveNotification {

    private String title;
    private String message;
    private String notificationId;

    public InteractiveNotification(Map<String, String> data) {
        title = data.containsKey("title") ? title = data.get("title") : "";

        message = data.containsKey("message") ? data.get("message") : "";

        notificationId = data.containsKey("notificationId") ?
                notificationId = data.get("notificationId") : "";

    }

    public String getMessage() {
        return message;
    }

    public String getTitle() {
        return title;
    }

    public String getNotificationId() {
        return notificationId;
    }

}
