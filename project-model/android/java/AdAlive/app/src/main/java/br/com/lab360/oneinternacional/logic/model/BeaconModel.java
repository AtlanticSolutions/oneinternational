package br.com.lab360.oneinternacional.logic.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import io.realm.RealmObject;

public class BeaconModel extends RealmObject {
    @SerializedName("id")
    @Expose
    private Integer id;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("entry_message")
    @Expose
    private String entryMessage;
    @SerializedName("leave_message")
    @Expose
    private String leaveMessage;
    @SerializedName("major")
    @Expose
    private String major;
    @SerializedName("minor")
    @Expose
    private String minor;
    @SerializedName("proximity_id")
    @Expose
    private String proximityUuid;
    @SerializedName("tracking_distance")
    @Expose
    private String trackingDistance;
    @SerializedName("app_id")
    @Expose
    private Integer appId;
    @SerializedName("is_received_leave_message")
    @Expose
    private boolean isReceivedLeaveMessage;
    @SerializedName("is_received_entry_message")
    @Expose
    private boolean isReceivedEntryMessage;
    @SerializedName("description")
    @Expose
    private String description;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEntryMessage() {
        return entryMessage;
    }

    public void setEntryMessage(String entryMessage) {
        this.entryMessage = entryMessage;
    }

    public String getLeaveMessage() {
        return leaveMessage;
    }

    public void setLeaveMessage(String leaveMessage) {
        this.leaveMessage = leaveMessage;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getMinor() {
        return minor;
    }

    public void setMinor(String minor) {
        this.minor = minor;
    }

    public String getProximityUuid() {
        return proximityUuid;
    }

    public void setProximityUuid(String proximityUuid) {
        this.proximityUuid = proximityUuid;
    }

    public String getTrackingDistance() {
        return trackingDistance;
    }

    public void setTrackingDistance(String trackingDistance) {
        this.trackingDistance = trackingDistance;
    }

    public Integer getAppId() {
        return appId;
    }

    public void setAppId(Integer appId) {
        this.appId = appId;
    }

    public boolean isReceivedLeaveMessage() {
        return isReceivedLeaveMessage;
    }

    public void setReceivedLeaveMessage(boolean receivedLeaveMessage) {
        isReceivedLeaveMessage = receivedLeaveMessage;
    }

    public boolean isReceivedEntryMessage() {
        return isReceivedEntryMessage;
    }

    public void setReceivedEntryMessage(boolean receivedEntryMessage) {
        isReceivedEntryMessage = receivedEntryMessage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
