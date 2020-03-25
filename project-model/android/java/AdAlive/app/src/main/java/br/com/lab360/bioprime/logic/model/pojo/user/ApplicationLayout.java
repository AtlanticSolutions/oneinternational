package br.com.lab360.bioprime.logic.model.pojo.user;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Paulo Roberto on 03/08/2017.
 */

public class ApplicationLayout {


    @SerializedName("master_event_id")
    private int masterEventId;

    @SerializedName("id")
    private int id;

    @SerializedName("name")
    private String name;

    @SerializedName("version")
    private String version;

    @SerializedName("logo")
    private String logoImageUrl;

    @SerializedName("background_image")
    private String backgroundImageUrl;

    @SerializedName("head_image")
    private String headerImageUrl;

    @SerializedName("homepage_url")
    private String homePageUrl;

    @SerializedName("third_party_url")
    private String thirdPartyUrl;

    @SerializedName("vuforia_access_key")
    private String vufuriaAccessKey;

    @SerializedName("vuforia_secret_key")
    private String vufuriaSecretKey;

    @SerializedName("vuforia_license_key")
    private String vufuriaLicenseKey;

    @SerializedName("product_id")
    private int productId;

    @SerializedName("show_code")
    private boolean showCode;

    @SerializedName("text_color")
    private String textColor;

    @SerializedName("background_color")
    private String backgroundColor;

    @SerializedName("button_first_color")
    private String buttonFirstColor;

    @SerializedName("button_second_color")
    private String buttonSecondColor;

    @SerializedName("selected_button_first_color")
    private String selectedButtonFirstColor;

    @SerializedName("selected_button_second_color")
    private String selectedButtonSecondColor;

    @SerializedName("title_button_first_color")
    private String titleButtonFirstColor;

    @SerializedName("title_button_second_color")
    private String titleButtonSecondColor;

    @SerializedName("selected_title_button_first_color")
    private String selectedTitleButtonFirstColor;

    @SerializedName("selected_title_button_second_color")
    private String selectedTitleButtonSecondColor;

    @SerializedName("register_user")
    private Boolean registerUser;

    @SerializedName("login_error_message")
    private String loginErrorMessage;

    //Paulo rever, por enquanto diniz nao
//    @SerializedName("beacons")
//    private ArrayList<String> beacons;

    @SerializedName("integrations")
    private ArrayList<String> integrations;


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

    public String getLogoImageUrl() {
        return logoImageUrl;
    }

    public String getBackgroundImageUrl() {
        return backgroundImageUrl;
    }

    public String getHeaderImageUrl() {
        return headerImageUrl;
    }

    public String getHomePageUrl() {
        return homePageUrl;
    }

    public String getThirdPartyUrl() {
        return thirdPartyUrl;
    }

    public String getVufuriaAccessKey() {
        return vufuriaAccessKey;
    }

    public String getVufuriaSecretKey() {
        return vufuriaSecretKey;
    }

    public String getVufuriaLicenseKey() {
        return vufuriaLicenseKey;
    }

    public int getProductId() {
        return productId;
    }

    public boolean getShowCode() {
        return showCode;
    }

    public String getTextColor() {
        return textColor;
    }

    public String getBackgroundColor() {
        return backgroundColor;
    }

    public String getButtonFirstColor() {
        return buttonFirstColor;
    }

    public String getButtonSecondColor() {
        return buttonSecondColor;
    }

    public String getSelectedButtonFirstColor() {
        return selectedButtonFirstColor;
    }

    public String getSelectedButtonSecondColor() {
        return selectedButtonSecondColor;
    }

    public String getTitleButtonFirstColor() {
        return titleButtonFirstColor;
    }

    public String getTitleButtonSecondColor() {
        return titleButtonSecondColor;
    }

    public String getSelectedTitleButtonFirstColor() {
        return selectedTitleButtonFirstColor;
    }

    public String getSelectedTitleButtonSecondColor() {
        return selectedTitleButtonSecondColor;
    }

    public Boolean getRegisterUser() {
        return registerUser;
    }

    public String getLoginErrorMessage() {
        return loginErrorMessage;
    }

    //    public ArrayList<String> getBeacons() {
//        return beacons;
//    }

    public ArrayList<String> getIntegrations() {
        return integrations;
    }
}
