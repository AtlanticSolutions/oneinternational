package br.com.lab360.oneinternacional.logic.model.pojo.menu;

import com.google.gson.annotations.SerializedName;
import com.thoughtbot.expandablerecyclerview.models.ExpandableGroup;

import java.util.List;

/**
 * Created by Edson on 07/06/2018.
 */

public class MenuItem {

    @SerializedName("name")
    private String name;
    @SerializedName("url")
    private String url;
    @SerializedName("url_api")
    private String urlApi;
    @SerializedName("identifier")
    private String identifier;
    @SerializedName("menu_type")
    private String menuType;
    @SerializedName("icon_url")
    private String iconUrl;
    @SerializedName("flg_click")
    private boolean flgClick;
    @SerializedName("flg_web_controls")
    private boolean flgWebControls;
    @SerializedName("flg_web_share_button")
    private boolean flgWebShareButton;
    @SerializedName("flg_blocked")
    private boolean flgBlocked;
    @SerializedName("flg_api_adalive")
    private boolean flgApiAdalive;
    @SerializedName("blocked_message")
    private String blockedMessage;
    @SerializedName("flg_highlighted")
    private boolean flgHighlighted;
    @SerializedName("featured_message")
    private String featuredMessage;
    @SerializedName("order")
    private int order;
    @SerializedName("badge")
    private int badge;
    @SerializedName("app_menu_items")
    private List<MenuItem> menuItems;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getMenuType() {
        return menuType;
    }

    public void setMenuType(String menuType) {
        this.menuType = menuType;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public boolean isFlgClick() {
        return flgClick;
    }

    public void setFlgClick(boolean flgClick) {
        this.flgClick = flgClick;
    }

    public boolean isFlgWebControls() {
        return flgWebControls;
    }

    public void setFlgWebControls(boolean flgWebControls) {
        this.flgWebControls = flgWebControls;
    }

    public boolean isFlgWebShareButton() {
        return flgWebShareButton;
    }

    public void setFlgWebShareButton(boolean flgWebShareButton) {
        this.flgWebShareButton = flgWebShareButton;
    }

    public boolean isFlgBlocked() {
        return flgBlocked;
    }

    public void setFlgBlocked(boolean flgBlocked) {
        this.flgBlocked = flgBlocked;
    }

    public String getBlockedMessage() {
        return blockedMessage;
    }

    public void setBlockedMessage(String blockedMessage) {
        this.blockedMessage = blockedMessage;
    }

    public boolean isFlgHighlighted() {
        return flgHighlighted;
    }

    public void setFlgHighlighted(boolean flgHighlighted) {
        this.flgHighlighted = flgHighlighted;
    }

    public String getFeaturedMessage() {
        return featuredMessage;
    }

    public void setFeaturedMessage(String featuredMessage) {
        this.featuredMessage = featuredMessage;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public int getBadge() {
        return badge;
    }

    public void setBadge(int badge) {
        this.badge = badge;
    }

    public List<MenuItem> getMenuItems() {
        return menuItems;
    }

    public void setMenuItems(List<MenuItem> menuItems) {
        this.menuItems = menuItems;
    }

    public boolean isFlgApiAdalive() {
        return flgApiAdalive;
    }

    public void setFlgApiAdalive(boolean flgApiAdalive) {
        this.flgApiAdalive = flgApiAdalive;
    }

    public String getUrlApi() {
        return urlApi;
    }

    public void setUrlApi(String urlApi) {
        this.urlApi = urlApi;
    }
}
