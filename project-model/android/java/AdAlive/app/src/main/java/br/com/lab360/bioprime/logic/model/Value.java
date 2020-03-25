
package br.com.lab360.bioprime.logic.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Value {



    @SerializedName("product_reference_id")
    public long   productReferenceID;

    @SerializedName("size")
    @Expose
    private Object size;
    @SerializedName("price_of")
    @Expose
    private String priceOf;
    @SerializedName("price_per")
    @Expose
    private String pricePer;



    public Object getSize() {
        return size;
    }

    public void setSize(Object size) {
        this.size = size;
    }

    public String getPriceOf() {
        return priceOf;
    }

    public void setPriceOf(String priceOf) {
        this.priceOf = priceOf;
    }

    public String getPricePer() {
        return pricePer;
    }

    public void setPricePer(String pricePer) {
        this.pricePer = pricePer;
    }

    public long getProductReferenceID() {
        return productReferenceID;
    }

    public void setProductReferenceID(long productReferenceID) {
        this.productReferenceID = productReferenceID;
    }
}
