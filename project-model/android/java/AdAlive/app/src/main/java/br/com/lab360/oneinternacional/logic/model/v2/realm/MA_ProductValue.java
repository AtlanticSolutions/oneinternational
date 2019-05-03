package br.com.lab360.oneinternacional.logic.model.v2.realm;

import br.com.lab360.oneinternacional.logic.model.v2.json.JSON_ProductValue;
import io.realm.RealmObject;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_ProductValue extends RealmObject{
    public long   productReferenceID;
    public double priceOf;
    public double pricePer;
    public String size;

    public MA_ProductValue(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_ProductValue(JSON_ProductValue data) {
        setProductReferenceID(data.getProductReferenceID());
        setPriceOf(data.getPriceOf());
        setPricePer(data.getPricePer());
        setSize(data.getSize());
    }

    public long getProductReferenceID() {
        return productReferenceID;
    }

    public double getPriceOf() {
        return priceOf;
    }

    public double getPricePer() {
        return pricePer;
    }

    public String getSize() {
        return size;
    }

    public void setProductReferenceID(long productReferenceID) {
        this.productReferenceID = productReferenceID;
    }

    public void setPriceOf(double priceOf) {
        this.priceOf = priceOf;
    }

    public void setPricePer(double pricePer) {
        this.pricePer = pricePer;
    }

    public void setSize(String size) {
        this.size = size;
    }
}
