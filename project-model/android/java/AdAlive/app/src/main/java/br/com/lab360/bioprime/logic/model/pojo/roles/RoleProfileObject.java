package br.com.lab360.bioprime.logic.model.pojo.roles;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Paulo santos on 14/08/2017.
 */

public class RoleProfileObject {

    @SerializedName("role")
    private String role;

    @SerializedName("master_event_id")
    private int masterEventID;
    
    @SerializedName("logo")
    private String logo;

    @SerializedName("background_image")
    private String backgroundImage;

    @SerializedName("head_image")
    private String headImage;

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

    @SerializedName("app")
    private int app;

    @SerializedName("flg_post")
    private Boolean canCreatePost;

    @SerializedName("flg_like")
    private Boolean canLike;

    @SerializedName("flg_share")
    private Boolean canShare;

    @SerializedName("flg_comment")
    private Boolean canComment;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public int getMasterEventID() {
        return masterEventID;
    }

    public void setMasterEventID(int masterEventID) {
        this.masterEventID = masterEventID;
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

    public String getSelectedTitleButtonSecondColor() {
        return selectedTitleButtonSecondColor;
    }

    public void setSelectedTitleButtonSecondColor(String selectedTitleButtonSecondColor) {
        this.selectedTitleButtonSecondColor = selectedTitleButtonSecondColor;
    }

    public int getApp() {
        return app;
    }

    public void setApp(int app) {
        this.app = app;
    }

    public Boolean getCanCreatePost() {
        return canCreatePost;
    }

    public void setCanCreatePost(Boolean canCreatePost) {
        this.canCreatePost = canCreatePost;
    }

    public Boolean getCanLike() {
        return canLike;
    }

    public void setCanLike(Boolean canLike) {
        this.canLike = canLike;
    }

    public Boolean getCanShare() {
        return canShare;
    }

    public void setCanShare(Boolean canShare) {
        this.canShare = canShare;
    }

    public Boolean getCanComment() {
        return canComment;
    }

    public void setCanComment(Boolean canComment) {
        this.canComment = canComment;
    }
}
