package br.com.lab360.oneinternacional.logic.model.pojo.menu;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Edson on 07/06/2018.
 */

public class AppMenu {

    @SerializedName("app_menu_items")
    private List<MenuItem> menuItems;
    @SerializedName("flg_app_version")
    private String flgAppVersion;
    @SerializedName("flg_return_buttom")
    private String flgReturnButton;
    @SerializedName("flg_user_photo")
    private String flgUserPhoto;
    @SerializedName("flg_icons")
    private String flgIcons;

    public List<MenuItem> getMenuItems() {
        return menuItems;
    }

    public void setMenuItems(List<MenuItem> menuItems) {
        this.menuItems = menuItems;
    }

    public String getFlgAppVersion() {
        return flgAppVersion;
    }

    public void setFlgAppVersion(String flgAppVersion) {
        this.flgAppVersion = flgAppVersion;
    }

    public String getFlgReturnButton() {
        return flgReturnButton;
    }

    public void setFlgReturnButton(String flgReturnButton) {
        this.flgReturnButton = flgReturnButton;
    }

    public String getFlgUserPhoto() {
        return flgUserPhoto;
    }

    public void setFlgUserPhoto(String flgUserPhoto) {
        this.flgUserPhoto = flgUserPhoto;
    }

    public String getFlgIcons() {
        return flgIcons;
    }

    public void setFlgIcons(String flgIcons) {
        this.flgIcons = flgIcons;
    }

}
