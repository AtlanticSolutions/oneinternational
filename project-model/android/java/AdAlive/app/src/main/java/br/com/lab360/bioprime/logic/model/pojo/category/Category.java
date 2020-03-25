package br.com.lab360.bioprime.logic.model.pojo.category;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;


/**
 * Created by Edson on 19/04/2018.
 */

public class Category {

    @SerializedName("id")
    private String id;
    @SerializedName("name")
    private String name;
    @SerializedName("image_url")
    private String image_url;
    @SerializedName("´products_count")
    private String products_count;
    @SerializedName("subcategories")
    private ArrayList<SubCategory> subCategories;

    public String getId () {
        return id;
    }

    public void setId (String id) {
        this.id = id;
    }

    public String getName () {
        return name;
    }

    public void setName (String name) {
        this.name = name;
    }

    public String getImageUrl () {
        return image_url;
    }

    public void setImageUrl (String image_url) {
        this.image_url = image_url;
    }

    public String getProductsCount () {
        return products_count;
    }

    public void setProductsCount (String products_count) {
        this.products_count = products_count;
    }

    public ArrayList<SubCategory> getSubCategories() {
        return subCategories;
    }

    public void setSubCategories(ArrayList<SubCategory> subCategories) {
        this.subCategories = subCategories;
    }
}
