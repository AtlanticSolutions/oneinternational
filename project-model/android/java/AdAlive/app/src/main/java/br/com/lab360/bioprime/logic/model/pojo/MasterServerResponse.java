package br.com.lab360.bioprime.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Paulo Roberto on 03/08/2017.
 */

public class MasterServerResponse {


    @SerializedName("app_id")
    private int appId;

    @SerializedName("url_adalive")
    private String urlAdalive;

    @SerializedName("url_chat")
    private String urlChat;

    public int getAppId() {
        return appId;
    }

    public String getUrlChat() {
        return urlChat;
    }

    public String getUrlAdalive() {
        return urlAdalive;
    }

    //    @SerializedName("app_id")
//    private int appId;
//
//    @SerializedName("device_name")
//    private String deviceName;
//
//    @SerializedName("longitude")
//    private String longitude;
//
//    @SerializedName("latitude")
//    private String latitude;
//
//    @SerializedName("device_system_name")
//    private String deviceSystemName;
//
//    @SerializedName("device_id_vendor")
//    private String deviceIdVendor;
//
//    @SerializedName("device_system_version")
//    private String deviceSystemVersion;
//
//    @SerializedName("device_model")
//    private String deviceModel;
//
//    @SerializedName("device_version")
//    private String deviceVersion;
//
//    public int getAppId() {
//        return appId;
//    }
//
//    public String getDeviceName() {
//        return deviceName;
//    }
//
//    public String getLatitude() {
//        return longitude;
//    }
//
//    public String getLongitude() {
//        return longitude;
//    }
//
//    public String getDeviceSystemName() {
//        return deviceSystemName;
//    }
//
//    public String getDeviceIdVendor() {
//        return deviceIdVendor;
//    }
//
//    public String getDeviceSystemVersion() {
//        return deviceSystemVersion;
//    }
//
//    public String getDeviceModel() {
//        return deviceModel;
//    }
//
//    public String getDeviceVersion() {
//        return deviceVersion;
//    }
}
