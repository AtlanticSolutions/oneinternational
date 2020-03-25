package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_ProductValue;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class JSON_ProductValue {
    @SerializedName("product_reference_id")
    public long   productReferenceID;

    @SerializedName("price_of")
    public double priceOf;

    @SerializedName("price_per")
    public double pricePer;

    @SerializedName("size")
    public String size;

    /**
     * Translate from REALM to JSON
     *
     * @param data A valid REALM
     */
    public JSON_ProductValue(MA_ProductValue data) {
        setProductReferenceID(data.getProductReferenceID());
        setPriceOf(data.getPriceOf());
        setPricePer(data.getPricePer());
        setSize(data.getSize());
    }

    public long getProductReferenceID() {
        return productReferenceID;
    }

    public void setProductReferenceID(long productReferenceID) {
        this.productReferenceID = productReferenceID;
    }

    public double getPriceOf() {
        return priceOf;
    }

    public void setPriceOf(double priceOf) {
        this.priceOf = priceOf;
    }

    public double getPricePer() {
        return pricePer;
    }

    public void setPricePer(double pricePer) {
        this.pricePer = pricePer;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }
}
