package br.com.lab360.oneinternacional.logic.rxbus.events;

import java.util.Map;

/**
 * Created by Alessandro Valenza on 04/01/2017.
 */

public class SectorMessageReceivedEvent {
    private String message;
    private String title;
    private String info;

    public SectorMessageReceivedEvent(Map<String, String> data) {
        message = data.get("message");

        if (data.containsKey("title")) {
            title = data.get("title");
        }

        if (data.containsKey("info")) {
            info = data.get("info");
        }
    }

    public String getMessage() {
        return message;
    }

    public String getTitle() {
        return title;
    }

    public String getInfo() {
        return info;
    }
}
