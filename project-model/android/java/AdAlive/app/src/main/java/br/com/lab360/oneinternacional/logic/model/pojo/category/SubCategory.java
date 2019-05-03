package br.com.lab360.oneinternacional.logic.model.pojo.category;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 19/04/2018.
 */

public class SubCategory {

    @SerializedName("id")
    private int id;
    @SerializedName("image_url")
    private String image_url;
    @SerializedName("name")
    private String name;
    @SerializedName("category_id")
    private String category_id;
    @SerializedName("type_subcategory")
    private String type_subcategory;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImageUrl() {
        return image_url;
    }

    public void setImageUrl(String image_url) {
        this.image_url = image_url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCategoryId() {
        return category_id;
    }

    public void setCategoryId(String category_id) {
        this.category_id = category_id;
    }

    public String getTypeSubCategory() {
        return type_subcategory;
    }

    public void setTypeSubCategory(String type_subcategory) {
        this.type_subcategory = type_subcategory;
    }

}
