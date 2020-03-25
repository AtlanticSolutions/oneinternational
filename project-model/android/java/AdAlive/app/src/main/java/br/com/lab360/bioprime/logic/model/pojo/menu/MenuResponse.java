package br.com.lab360.bioprime.logic.model.pojo.menu;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 07/06/2018.
 */

public class MenuResponse {

    @SerializedName("app_menus")
    private AppMenu appMenu;

    public AppMenu getAppMenu() {
        return appMenu;
    }

    public void setAppMenu(AppMenu appMenu) {
        this.appMenu = appMenu;
    }

}
