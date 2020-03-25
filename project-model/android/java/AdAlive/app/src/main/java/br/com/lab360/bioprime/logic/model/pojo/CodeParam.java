package br.com.lab360.bioprime.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

/**
 * Created by thiagofaria on 17/01/17.
 */
public class CodeParam {

    private int id;
    private String name;
    private String version;
    private String logo;

    @SerializedName("master_event_id")
    private int masterEventId;
    @SerializedName("head_image")
    private String headerImageUrl;
    @SerializedName("background_image")
    private String backgroundimage;
    @SerializedName("homepage_url")
    private String homepageurl;
    @SerializedName("third_party_url")
    private String thirdpartyurl;
    @SerializedName("vuforia_access_key")
    private String vuforiaAccessKey;
    @SerializedName("vuforia_secret_key")
    private String vuforiaSecretKey;
    @SerializedName("vuforia_license_key")
    private String vuforiaLicenseKey;


    //Paulo - Por enquanto DINIZ nao
//    @SerializedName("beacons")
//    private ArrayList<String> beacons;

    public void setMasterEventId(int masterEventId) {
        this.masterEventId = masterEventId;
    }

    public int getMasterEventId() {
        return masterEventId;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getVersion() {
        return version;
    }

    public String getLogo() {
        return logo;
    }

    public String getBackgroundimage() {
        return backgroundimage;
    }

    public String getHeaderImageUrl() {
        return headerImageUrl;
    }

    public String getHomepageurl() {
        return homepageurl;
    }

    public String getThirdpartyurl() {
        return thirdpartyurl;
    }

    public String getVuforiaAccessKey() {
        return vuforiaAccessKey;
    }

    public String getVuforiaSecretKey() {
        return vuforiaSecretKey;
    }

    public String getVuforiaLicenseKey() {
        return vuforiaLicenseKey;
    }

//    public ArrayList<String> getBeacons() {
//        return beacons;
//    }
}
