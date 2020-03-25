package br.com.lab360.bioprime.logic.model.v2.realm;

import br.com.lab360.bioprime.logic.model.v2.json.JSON_Product;
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_Product extends RealmObject{

    @PrimaryKey
    public long productID;
    public long catalogID;
    public long categoryID;
    public String sku;
    public String reference;
    public String size;
    public String name;
    public String category;
    public String family;
    public double priceOf;
    public double pricePer;
    public int local;
    public int pagine;
    public int flgRescue;
    public double pricePoint;
    public String status;
    public String urlImage;
    public String productError;
    public String msgValidDigit1;
    public String msgValidDigit2;
    public String tag;
    public RealmList<MA_ProductValue> values;

    public MA_Product(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_Product(JSON_Product data) {
        setProductID(data.getProductID());
        setCatalogID(data.getCatalogID());
        setCategoryID(data.getCategoryID());
        setSku(data.getSku());
        setReference(data.getReference());
        setSize(data.getSize());
        setName(data.getName());
        setCategory(data.getCategory());
        setFamily(data.getFamily());
        setPriceOf(data.getPriceOf());
        setPricePer(data.getPricePer());
        setLocal(data.getLocal());
        setPagine(data.getPagine());
        setFlgRescue(data.getFlgRescue());
        setPricePoint(data.getPricePoint());
        setStatus(data.getStatus());
        setUrlImage(data.getUrlImage());
        setProductError(data.getProductError());
        setMsgValidDigit1(data.getMsgValidDigit1());
        setMsgValidDigit2(data.getMsgValidDigit2());
        setTag(data.getTag());
    }

    public long getProductID() {
        return productID;
    }

    public long getCatalogID() {
        return catalogID;
    }

    public long getCategoryID() {
        return categoryID;
    }

    public String getSku() {
        return sku;
    }

    public String getReference() {
        return reference;
    }

    public String getSize() {
        return size;
    }

    public String getName() {
        return name;
    }

    public String getCategory() {
        return category;
    }

    public String getFamily() {
        return family;
    }

    public double getPriceOf() {
        return priceOf;
    }

    public double getPricePer() {
        return pricePer;
    }

    public int getLocal() {
        return local;
    }

    public int getPagine() {
        return pagine;
    }

    public int getFlgRescue() {
        return flgRescue;
    }

    public double getPricePoint() {
        return pricePoint;
    }

    public String getStatus() {
        return status;
    }

    public String getUrlImage() {
        return urlImage;
    }

    public String getProductError() {
        return productError;
    }

    public String getMsgValidDigit1() {
        return msgValidDigit1;
    }

    public String getMsgValidDigit2() {
        return msgValidDigit2;
    }

    public String getTag() {
        return tag;
    }

    public RealmList<MA_ProductValue> getValues() {
        return values;
    }

    public void setProductID(long productID) {
        this.productID = productID;
    }

    public void setCatalogID(long catalogID) {
        this.catalogID = catalogID;
    }

    public void setCategoryID(long categoryID) {
        this.categoryID = categoryID;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public void setPriceOf(double priceOf) {
        this.priceOf = priceOf;
    }

    public void setPricePer(double pricePer) {
        this.pricePer = pricePer;
    }

    public void setLocal(int local) {
        this.local = local;
    }

    public void setPagine(int pagine) {
        this.pagine = pagine;
    }

    public void setFlgRescue(int flgRescue) {
        this.flgRescue = flgRescue;
    }

    public void setPricePoint(double pricePoint) {
        this.pricePoint = pricePoint;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setUrlImage(String urlImage) {
        this.urlImage = urlImage;
    }

    public void setProductError(String productError) {
        this.productError = productError;
    }

    public void setMsgValidDigit1(String msgValidDigit1) {
        this.msgValidDigit1 = msgValidDigit1;
    }

    public void setMsgValidDigit2(String msgValidDigit2) {
        this.msgValidDigit2 = msgValidDigit2;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public void setValues(RealmList<MA_ProductValue> values) {
        this.values = values;
    }
}
