package br.com.lab360.oneinternacional.logic.model.pojo.notification;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Paulo on 01/09/2017.
 */

public class NotificationObject {

    private int id;

    @SerializedName("message")
    private String message;

    @SerializedName("read")
    private Boolean read;

    @SerializedName("info")
    private String info;

    public int getId() {
        return id;
    }

    public String getMessage() {
        return message;
    }

    public Boolean getRead() {
        return read;
    }

    public String getInfo() {
        return info;
    }
}
