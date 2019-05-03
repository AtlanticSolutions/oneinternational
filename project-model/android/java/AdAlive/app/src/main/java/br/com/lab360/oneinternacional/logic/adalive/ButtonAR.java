//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package br.com.lab360.oneinternacional.logic.adalive;

import com.google.gson.annotations.SerializedName;

public class ButtonAR {
    @SerializedName("id")
    private int id;
    @SerializedName("label")
    private String title;
    @SerializedName("href")
    private String href;
    @SerializedName("background_color")
    private String bgColor;
    @SerializedName("foreground_color")
    private String titleColor;
    private int actionId;
    private ClickButtonARListener clickButtonARListener;

    public ButtonAR(int id, String title, String titleColor, String bgColor, String href, ClickButtonARListener clickButtonARListener) {
        this.bgColor = bgColor;
        this.clickButtonARListener = clickButtonARListener;
        this.href = href;
        this.id = id;
        this.title = title;
        this.titleColor = titleColor;
    }

    public ButtonAR(int id, String title, String href, ClickButtonARListener clickButtonARListener) {
        this.id = id;
        this.href = href;
        this.clickButtonARListener = clickButtonARListener;
        this.title = title;
    }

    public String getBgColor() {
        return this.bgColor != null && this.bgColor.length() > 4 ? this.bgColor : "#ADB1B3";
    }

    public void setBgColor(String bgColor) {
        this.bgColor = bgColor;
    }

    public ClickButtonARListener getClickButtonARListener() {
        return this.clickButtonARListener;
    }

    public void setClickButtonARListener(ClickButtonARListener clickButtonARListener) {
        this.clickButtonARListener = clickButtonARListener;
    }

    public String getTitle() {
        return this.title == null ? "Button" : this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTitleColor() {
        return this.titleColor != null && this.titleColor.length() > 4 ? this.titleColor : "#FFFFFF";
    }

    public void setTitleColor(String titleColor) {
        this.titleColor = titleColor;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHref() {
        return this.href == null ? "" : this.href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public int getActionId() {
        return this.actionId;
    }

    public void setActionId(int actionId) {
        this.actionId = actionId;
    }
}
