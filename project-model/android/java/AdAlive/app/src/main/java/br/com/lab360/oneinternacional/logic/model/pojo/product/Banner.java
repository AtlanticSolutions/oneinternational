package br.com.lab360.oneinternacional.logic.model.pojo.product;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

/**
 * Represents banner object from server.
 * Created by Victor on 17/02/2016.
 */
public class Banner implements Serializable {

    private static final long serialVersionUID = -6242954026962202839L;

    @SerializedName("id")
    private int id;

    @SerializedName("image_url")
    private String imageURL;

    @SerializedName("href")
    private String href;

    @SerializedName("timer")
    private int timer;

    public String getHref() {
        return href == null ? "" : href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImageURL() {
        return imageURL == null ? "" : imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public int getTimer() {
        return timer;
    }

    public void setTimer(int timer) {
        this.timer = timer;
    }

}
