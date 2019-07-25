package br.com.lab360.oneinternacional.logic.model.pojo.product;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.oneinternacional.logic.adalive.Product;


/**
 * Created by Paulo santos on 08/08/2017.
 */

public class ProductLocal extends Product {

    @SerializedName("image_url")
    private String imageUrl;

    public String getImageUrl() {
        return imageUrl;
    }

}
