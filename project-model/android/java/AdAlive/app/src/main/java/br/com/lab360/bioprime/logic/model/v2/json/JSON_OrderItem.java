package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_OrderItem;

/**
 * Created by Paulo Age on 23/10/17.
 */

public class JSON_OrderItem {
    /* @SerializedName("order_item") */
    @SerializedName("product_id")
    public long   productID;

    @SerializedName("product_reference_id")
    public long   productReferenceID;

    @SerializedName("amount")
    public long   amount;

    @SerializedName("size")
    public String size;

    @SerializedName("name")
    public String name;

    @SerializedName("price")
    public double price;

    @SerializedName("points")
    public long   points;

    @SerializedName("status")
    public String status;

    /**
     * Translate from REALM to JSON
     *
     * @param data A valid REALM
     */
    public JSON_OrderItem(MA_OrderItem data) {
        setProductID(data.getProductID());
        setProductReferenceID(data.getProductReferenceID());
        setAmount(data.getAmount());
        setSize(data.getSize());
        setName(data.getName());
        setPrice(data.getPrice());
        setPoints(data.getPoints());
        setStatus(data.getStatus());
    }

    public long getProductID() {
        return productID;
    }

    public void setProductID(long productID) {
        this.productID = productID;
    }

    public long getProductReferenceID() {
        return productReferenceID;
    }

    public void setProductReferenceID(long productReferenceID) {
        this.productReferenceID = productReferenceID;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public long getPoints() {
        return points;
    }

    public void setPoints(long points) {
        this.points = points;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
