package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class JSON_Product {
    @SerializedName("product_id")
    public long productID;

    @SerializedName("catalog_id")
    public long catalogID;

    @SerializedName("tab_ma_category_id")
    public long categoryID;

    @SerializedName("sku")
    public String sku;

    @SerializedName("reference")
    public String reference;

    @SerializedName("size")
    public String size;

    @SerializedName("name")
    public String name;

    @SerializedName("category")
    public String category;

    @SerializedName("family")
    public String family;

    @SerializedName("price_of")
    public double priceOf;

    @SerializedName("price_per")
    public double pricePer;

    @SerializedName("local")
    public int local;

    @SerializedName("pagine")
    public int pagine;

    @SerializedName("flg_rescue")
    public int flgRescue;

    @SerializedName("price_point")
    public double pricePoint;

    @SerializedName("status")
    public String status;

    @SerializedName("url_image")
    public String urlImage;

    @SerializedName("product_error")
    public String productError;

    @SerializedName("msg_valid_digit_1")
    public String msgValidDigit1;

    @SerializedName("msg_valid_digit_2")
    public String msgValidDigit2;

    @SerializedName("tag")
    public String tag;

    @SerializedName("values")
    public List<JSON_ProductValue> productValues;

    public JSON_Product(){

    }


   /* public JSON_Product(MA_Product data) {
        values = new ArrayList<JSON_ProductValue>();

        setProductID(data.getProductID());
        setCatalogID(data.getCatalogID());
        setCategoryID(data.getProductID());
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
        setMsgValidDigit2(data.getMsgValidDigit1());
        setTag(data.getTag());

        if (data.getValues() != null) {
            for (MA_ProductValue p : data.getValues()) {
                values.add(new JSON_ProductValue(p));
            }
        }
    }*/

    public long getProductID() {
        return productID;
    }

    public void setProductID(long productID) {
        this.productID = productID;
    }

    public long getCatalogID() {
        return catalogID;
    }

    public void setCatalogID(long catalogID) {
        this.catalogID = catalogID;
    }

    public long getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(long categoryID) {
        this.categoryID = categoryID;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
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

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
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

    public int getLocal() {
        return local;
    }

    public void setLocal(int local) {
        this.local = local;
    }

    public int getPagine() {
        return pagine;
    }

    public void setPagine(int pagine) {
        this.pagine = pagine;
    }

    public int getFlgRescue() {
        return flgRescue;
    }

    public void setFlgRescue(int flgRescue) {
        this.flgRescue = flgRescue;
    }

    public double getPricePoint() {
        return pricePoint;
    }

    public void setPricePoint(double pricePoint) {
        this.pricePoint = pricePoint;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUrlImage() {
        return urlImage;
    }

    public void setUrlImage(String urlImage) {
        this.urlImage = urlImage;
    }

    public String getProductError() {
        return productError;
    }

    public void setProductError(String productError) {
        this.productError = productError;
    }

    public String getMsgValidDigit1() {
        return msgValidDigit1;
    }

    public void setMsgValidDigit1(String msgValidDigit1) {
        this.msgValidDigit1 = msgValidDigit1;
    }

    public String getMsgValidDigit2() {
        return msgValidDigit2;
    }

    public void setMsgValidDigit2(String msgValidDigit2) {
        this.msgValidDigit2 = msgValidDigit2;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public List<JSON_ProductValue> getProductValues() {
        return productValues;
    }

    public void setProductValues(List<JSON_ProductValue> productValues) {
        this.productValues = productValues;
    }
}
