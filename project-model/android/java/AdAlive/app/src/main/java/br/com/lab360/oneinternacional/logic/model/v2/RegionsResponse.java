package br.com.lab360.oneinternacional.logic.model.v2;

import com.google.gson.annotations.SerializedName;

import java.util.List;
public class RegionsResponse {

    @SerializedName("regions")
    private List<Region> regions = null;
    @SerializedName("geofence_time")
    private int geofenceTime;

    public RegionsResponse() {
    }

    public List<Region> getRegions() {
        return this.regions;
    }

    public void setRegions(List<Region> regions) {
        this.regions = regions;
    }

    public int getGeofenceTime() {
        return this.geofenceTime;
    }

    public void setGeofenceTime(int geofenceTime) {
        this.geofenceTime = geofenceTime;
    }
}
