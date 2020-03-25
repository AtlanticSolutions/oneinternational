
package br.com.lab360.bioprime.logic.model.pojo.roles;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Role {

    @SerializedName("role")
    @Expose
    private String role;
    @SerializedName("master_event_id")
    @Expose
    private Integer masterEventId;
    @SerializedName("logo")
    @Expose
    private String logo;
    @SerializedName("background_image")
    @Expose
    private String backgroundImage;
    @SerializedName("head_image")
    @Expose
    private String headImage;
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
    private Object selectedTitleButtonSecondColor;
    @SerializedName("app")
    @Expose
    private Integer app;
    @SerializedName("flg_post")
    @Expose
    private Boolean flgPost;
    @SerializedName("flg_like")
    @Expose
    private Boolean flgLike;
    @SerializedName("flg_share")
    @Expose
    private Boolean flgShare;
    @SerializedName("flg_comment")
    @Expose
    private Boolean flgComment;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getMasterEventId() {
        return masterEventId;
    }

    public void setMasterEventId(Integer masterEventId) {
        this.masterEventId = masterEventId;
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

    public Object getSelectedTitleButtonSecondColor() {
        return selectedTitleButtonSecondColor;
    }

    public void setSelectedTitleButtonSecondColor(Object selectedTitleButtonSecondColor) {
        this.selectedTitleButtonSecondColor = selectedTitleButtonSecondColor;
    }

    public Integer getApp() {
        return app;
    }

    public void setApp(Integer app) {
        this.app = app;
    }

    public Boolean getFlgPost() {
        return flgPost;
    }

    public void setFlgPost(Boolean flgPost) {
        this.flgPost = flgPost;
    }

    public Boolean getFlgLike() {
        return flgLike;
    }

    public void setFlgLike(Boolean flgLike) {
        this.flgLike = flgLike;
    }

    public Boolean getFlgShare() {
        return flgShare;
    }

    public void setFlgShare(Boolean flgShare) {
        this.flgShare = flgShare;
    }

    public Boolean getFlgComment() {
        return flgComment;
    }

    public void setFlgComment(Boolean flgComment) {
        this.flgComment = flgComment;
    }

}
