package br.com.lab360.bioprime.logic.model.pojo.category;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;


/**
 * Created by Edson on 19/04/2018.
 */

public class SubCategoriesResponse {

    @SerializedName("subcategories")
    ArrayList<Category> subCategories;


    public ArrayList<Category> getSubCategories() {
        return subCategories;
    }

    public void setSubCategories(ArrayList<Category> subCategories) {
        this.subCategories = subCategories;
    }
}
