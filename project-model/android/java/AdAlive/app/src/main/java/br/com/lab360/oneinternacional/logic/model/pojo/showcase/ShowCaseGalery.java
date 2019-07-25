package br.com.lab360.oneinternacional.logic.model.pojo.showcase;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Edson on 08/05/2018.
 */

public class ShowCaseGalery {

    @SerializedName("message")
    private String message;
    @SerializedName("banner_url")
    private String bannerURL;
    @SerializedName("title")
    private String title;
    @SerializedName("categories")
    private List<ShowCaseCategory> categories;

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getBannerURL() {
        return bannerURL;
    }

    public void setBannerURL(String bannerURL) {
        this.bannerURL = bannerURL;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<ShowCaseCategory> getCategories() {
        return categories;
    }

    public void setCategories(List<ShowCaseCategory> categories) {
        this.categories = categories;
    }
}
