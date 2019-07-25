package br.com.lab360.oneinternacional.logic.model.pojo.timeline;

import com.google.gson.annotations.SerializedName;

public class Banner {
    @SerializedName("id")
    int id;
    @SerializedName("href")
    String href;
    @SerializedName("image_url")
    String image_url;

    @SerializedName("time")
    int time;


    public String getImageUrl() {
        return image_url;
    }

    public void setImageUrl(String image_url) {
        this.image_url = image_url;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }
}
