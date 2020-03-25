package br.com.lab360.bioprime.logic.model.v2;

import com.google.android.gms.location.Geofence;
import com.google.gson.annotations.SerializedName;

public class Region {

    private static final long GEOFENCE_EXPIRATION_IN_HOURS = 12;
    public static final long GEOFENCE_EXPIRATION_IN_MILLISECONDS = GEOFENCE_EXPIRATION_IN_HOURS;

    @SerializedName("id")
    private Integer id;
    @SerializedName("latitude")
    private String latitude;
    @SerializedName("longitude")
    private String longitude;
    @SerializedName("radius")
    private String radius;
    @SerializedName("on_enter")
    private Boolean onEnter;
    @SerializedName("on_exit")
    private Boolean onExit;
    @SerializedName("is_goal")
    private Boolean isGoal;

    private int loiteringDelay = 60000;

    public Region() {
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLatitude() {
        return this.latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return this.longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getRadius() {
        return this.radius;
    }

    public void setRadius(String radius) {
        this.radius = radius;
    }

    public Boolean getOnEnter() {
        return this.onEnter;
    }

    public void setOnEnter(Boolean onEnter) {
        this.onEnter = onEnter;
    }

    public Boolean getOnExit() {
        return this.onExit;
    }

    public void setOnExit(Boolean onExit) {
        this.onExit = onExit;
    }

    public Boolean getIsGoal() {
        return this.isGoal;
    }

    public void setIsGoal(Boolean isGoal) {
        this.isGoal = isGoal;
    }

    public String toString() {
        return "id: " + this.id + ", latitude: " + this.latitude + ", longitude: " + this.longitude + ", radius: " + this.radius + ", onEnter: " + this.onEnter + ", onExit: " + this.onExit + ", isGoal: " + this.isGoal;
    }

    public Geofence toGeofence() {
        Geofence g = new Geofence.Builder().setRequestId(String.valueOf(getId()))
                .setTransitionTypes(Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT)
                .setCircularRegion(Double.valueOf(getLatitude()), Double.valueOf(getLongitude()), Float.parseFloat(getRadius()))
                .setExpirationDuration(GEOFENCE_EXPIRATION_IN_MILLISECONDS)
                .setLoiteringDelay(loiteringDelay).build();
        return g;
    }
}
