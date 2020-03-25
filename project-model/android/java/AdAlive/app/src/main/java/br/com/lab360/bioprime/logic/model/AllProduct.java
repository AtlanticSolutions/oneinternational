package br.com.lab360.bioprime.logic.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

import br.com.lab360.bioprime.logic.model.v2.json.JSON_Product;

public class AllProduct {

    @SerializedName("products")
    @Expose
    private List<JSON_Product> products = null;

    public List<JSON_Product> getProducts() {
        return products;
    }

    public void setProducts(List<JSON_Product> products) {
        this.products = products;
    }

}
