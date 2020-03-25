package br.com.lab360.bioprime.logic.model.pojo.timeline;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 30/01/2017.
 */
public class PostLog {
    private double latitude, longitude;
    @SerializedName("device_id_vendor")
    private String deviceIdVendor;

    public PostLog(double latitude, double longitude, String deviceIdVendor) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.deviceIdVendor = deviceIdVendor;
    }
}
