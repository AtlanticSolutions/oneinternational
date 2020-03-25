package br.com.lab360.bioprime.logic.model.pojo.geofence;

import com.google.gson.annotations.SerializedName;

public class GeofenceMessage {

    @SerializedName("id")
    int id;
    @SerializedName("message")
    String message;
    @SerializedName("active")
    Boolean active;
    @SerializedName("automatic")
    Boolean automatic;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Boolean getAutomatic() {
        return automatic;
    }

    public void setAutomatic(Boolean automatic) {
        this.automatic = automatic;
    }
}
