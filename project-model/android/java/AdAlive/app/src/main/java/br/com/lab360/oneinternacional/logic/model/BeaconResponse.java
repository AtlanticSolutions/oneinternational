package br.com.lab360.oneinternacional.logic.model;

import com.google.gson.annotations.SerializedName;
 
import java.util.List;
 
/**
 * Created by Edson on 04/06/2018.
 */
 
public class BeaconResponse {
 
    @SerializedName("beacons")
    List<BeaconModel> beacons;
    public List<BeaconModel> getBeacons() {
        return beacons;
    }
 
    public void setBeacons(List<BeaconModel> beacons) {
        this.beacons = beacons;
    }
 
}