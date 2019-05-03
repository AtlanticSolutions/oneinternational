
package br.com.lab360.oneinternacional.logic.model.pojo.user;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import br.com.lab360.oneinternacional.logic.model.BeaconModel;
import br.com.lab360.oneinternacional.logic.model.pojo.roles.RoleProfileObject;

public class LayoutParam {
    @SerializedName("master_event_id")
    @Expose
    private Integer masterEventId;

    @SerializedName("id")
    @Expose
    private Integer id;

    @SerializedName("name")
    @Expose
    private String name;

    @SerializedName("version")
    @Expose
    private String version;

    @SerializedName("logo")
    @Expose
    private String logo;

    @SerializedName("background_image")
    @Expose
    private String backgroundImage;

    @SerializedName("head_image")
    @Expose
    private String headImage;

    @SerializedName("homepage_url")
    @Expose
    private String homepageUrl;

    @SerializedName("third_party_url")
    @Expose
    private String thirdPartyUrl;

    @SerializedName("vuforia_access_key")
    @Expose
    private String vuforiaAccessKey;
    @SerializedName("vuforia_secret_key")
    @Expose
    private String vuforiaSecretKey;
    @SerializedName("vuforia_license_key")
    @Expose
    private String vuforiaLicenseKey;
    @SerializedName("product_id")
    @Expose
    private boolean productId;
    @SerializedName("show_code")
    @Expose
    private Boolean showCode;
    @SerializedName("register_user")
    @Expose
    private Boolean registerUser;
    @SerializedName("text_color")
    @Expose
    private String textColor;
    @SerializedName("background_color")
    @Expose
    private String backgroundColor;
    @SerializedName("button_first_color")
    @Expose
    private String buttonFirstColor;
    @SerializedName("button_second_color")
    @Expose
    private String buttonSecondColor;
    @SerializedName("selected_button_first_color")
    @Expose
    private String selectedButtonFirstColor;
    @SerializedName("selected_button_second_color")
    @Expose
    private String selectedButtonSecondColor;
    @SerializedName("title_button_first_color")
    @Expose
    private String titleButtonFirstColor;
    @SerializedName("title_button_second_color")
    @Expose
    private String titleButtonSecondColor;
    @SerializedName("selected_title_button_first_color")
    @Expose
    private String selectedTitleButtonFirstColor;
    @SerializedName("selected_title_button_second_color")
    @Expose
    private String selectedTitleButtonSecondColor;
    @SerializedName("login_error_message")
    @Expose
    private String loginErrorMessage;
    @SerializedName("survey_geral")
    @Expose
    private String surveyGeral;
    @SerializedName("survey_specific")
    @Expose
    private String surveySpecific;
    @SerializedName("beacons")
    @Expose
    private List<BeaconModel> beacons = null;
    @SerializedName("integrations")
    @Expose
    private List<String> integrations = null;
    @SerializedName("geofence_enable")
    @Expose
    private Boolean geofenceEnable;
    @SerializedName("roles")
    @Expose
    private List<RoleProfileObject> roles = null;

    public Integer getMasterEventId() {
        return masterEventId;
    }

    public void setMasterEventId(Integer masterEventId) {
        this.masterEventId = masterEventId;
    }

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

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getBackgroundImage() {
        return backgroundImage;
    }

    public void setBackgroundImage(String backgroundImage) {
        this.backgroundImage = backgroundImage;
    }

    public String getHeadImage() {
        return headImage;
    }

    public void setHeadImage(String headImage) {
        this.headImage = headImage;
    }

    public String getHomepageUrl() {
        return homepageUrl;
    }

    public void setHomepageUrl(String homepageUrl) {
        this.homepageUrl = homepageUrl;
    }

    public String getThirdPartyUrl() {
        return thirdPartyUrl;
    }

    public void setThirdPartyUrl(String thirdPartyUrl) {
        this.thirdPartyUrl = thirdPartyUrl;
    }

    public String getVuforiaAccessKey() {
        return vuforiaAccessKey;
    }

    public void setVuforiaAccessKey(String vuforiaAccessKey) {
        this.vuforiaAccessKey = vuforiaAccessKey;
    }

    public String getVuforiaSecretKey() {
        return vuforiaSecretKey;
    }

    public void setVuforiaSecretKey(String vuforiaSecretKey) {
        this.vuforiaSecretKey = vuforiaSecretKey;
    }

    public String getVuforiaLicenseKey() {
        return vuforiaLicenseKey;
    }

    public void setVuforiaLicenseKey(String vuforiaLicenseKey) {
        this.vuforiaLicenseKey = vuforiaLicenseKey;
    }

    public boolean isProductId() {
        return productId;
    }

    public void setProductId(boolean productId) {
        this.productId = productId;
    }

    public Boolean getShowCode() {
        return showCode;
    }

    public void setShowCode(Boolean showCode) {
        this.showCode = showCode;
    }

    public Boolean getRegisterUser() {
        return registerUser;
    }

    public void setRegisterUser(Boolean registerUser) {
        this.registerUser = registerUser;
    }

    public String getTextColor() {
        return textColor;
    }

    public void setTextColor(String textColor) {
        this.textColor = textColor;
    }

    public String getBackgroundColor() {
        return backgroundColor;
    }

    public void setBackgroundColor(String backgroundColor) {
        this.backgroundColor = backgroundColor;
    }

    public String getButtonFirstColor() {
        return buttonFirstColor;
    }

    public void setButtonFirstColor(String buttonFirstColor) {
        this.buttonFirstColor = buttonFirstColor;
    }

    public String getButtonSecondColor() {
        return buttonSecondColor;
    }

    public void setButtonSecondColor(String buttonSecondColor) {
        this.buttonSecondColor = buttonSecondColor;
    }

    public String getSelectedButtonFirstColor() {
        return selectedButtonFirstColor;
    }

    public void setSelectedButtonFirstColor(String selectedButtonFirstColor) {
        this.selectedButtonFirstColor = selectedButtonFirstColor;
    }

    public String getSelectedButtonSecondColor() {
        return selectedButtonSecondColor;
    }

    public void setSelectedButtonSecondColor(String selectedButtonSecondColor) {
        this.selectedButtonSecondColor = selectedButtonSecondColor;
    }

    public String getTitleButtonFirstColor() {
        return titleButtonFirstColor;
    }

    public void setTitleButtonFirstColor(String titleButtonFirstColor) {
        this.titleButtonFirstColor = titleButtonFirstColor;
    }

    public String getTitleButtonSecondColor() {
        return titleButtonSecondColor;
    }

    public void setTitleButtonSecondColor(String titleButtonSecondColor) {
        this.titleButtonSecondColor = titleButtonSecondColor;
    }

    public String getSelectedTitleButtonFirstColor() {
        return selectedTitleButtonFirstColor;
    }

    public void setSelectedTitleButtonFirstColor(String selectedTitleButtonFirstColor) {
        this.selectedTitleButtonFirstColor = selectedTitleButtonFirstColor;
    }

    public String getSelectedTitleButtonSecondColor() {
        return selectedTitleButtonSecondColor;
    }

    public void setSelectedTitleButtonSecondColor(String selectedTitleButtonSecondColor) {
        this.selectedTitleButtonSecondColor = selectedTitleButtonSecondColor;
    }

    public String getLoginErrorMessage() {
        return loginErrorMessage;
    }

    public void setLoginErrorMessage(String loginErrorMessage) {
        this.loginErrorMessage = loginErrorMessage;
    }

    public String getSurveyGeral() {
        return surveyGeral;
    }

    public void setSurveyGeral(String surveyGeral) {
        this.surveyGeral = surveyGeral;
    }

    public String getSurveySpecific() {
        return surveySpecific;
    }

    public void setSurveySpecific(String surveySpecific) {
        this.surveySpecific = surveySpecific;
    }

    public List<BeaconModel> getBeacons() {
        return beacons;
    }

    public void setBeacons(List<BeaconModel> beacons) {
        this.beacons = beacons;
    }

    public List<String> getIntegrations() {
        return integrations;
    }

    public void setIntegrations(List<String> integrations) {
        this.integrations = integrations;
    }

    public Boolean getGeofenceEnable() {
        return geofenceEnable;
    }

    public void setGeofenceEnable(Boolean geofenceEnable) {
        this.geofenceEnable = geofenceEnable;
    }

    public List<RoleProfileObject> getRoles() {
        return roles;
    }

    public void setRoles(List<RoleProfileObject> roles) {
        this.roles = roles;
    }
}
