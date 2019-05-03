package br.com.lab360.oneinternacional.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */
public class RegisterUserEventRequest {

    @SerializedName("app_user_id")
    private int userId;
    @SerializedName("event_id")
    private int eventId;

    public RegisterUserEventRequest(int userId, int eventId) {
        this.userId = userId;
        this.eventId = eventId;
    }
}
