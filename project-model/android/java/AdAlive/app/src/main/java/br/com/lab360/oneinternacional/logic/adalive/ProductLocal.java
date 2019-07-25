package br.com.lab360.oneinternacional.logic.adalive;

import com.google.gson.annotations.SerializedName;


public class ProductLocal extends Product {

    @SerializedName("image_url")
    private String imageUrl;

    public String getImageUrl() {
        return imageUrl;
    }

}