package br.com.lab360.oneinternacional.logic.adalive;

import com.google.gson.annotations.SerializedName;
import java.util.ArrayList;
import java.util.List;

import lib.bean.Campaign;

public class Product {
    @SerializedName("id")
    private int id;
    @SerializedName("name")
    private String name;
    @SerializedName("title")
    private String title;
    @SerializedName("subtitle")
    private String subtitle;
    @SerializedName("price")
    private String price;
    @SerializedName("campaigns")
    private List<Campaign> campaigns = new ArrayList();
    @SerializedName("actions")
    private List<Action> actions = new ArrayList();

    public Product() {
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return this.name == null ? "" : this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return this.title == null ? "" : this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return this.subtitle == null ? "" : this.subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getPrice() {
        return this.price == null ? "" : this.price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public List<Campaign> getCampaigns() {
        return (List)(this.campaigns == null ? new ArrayList() : this.campaigns);
    }

    public void setCampaigns(List<Campaign> campaigns) {
        this.campaigns = campaigns;
    }

    public List<Action> getActions() {
        return (List)(this.actions == null ? new ArrayList() : this.actions);
    }

    public void setActions(List<Action> actions) {
        this.actions = actions;
    }
}
