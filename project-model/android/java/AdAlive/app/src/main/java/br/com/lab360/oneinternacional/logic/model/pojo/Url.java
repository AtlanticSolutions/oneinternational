package br.com.lab360.oneinternacional.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

public class Url {

    @SerializedName("url")
    private String url;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
