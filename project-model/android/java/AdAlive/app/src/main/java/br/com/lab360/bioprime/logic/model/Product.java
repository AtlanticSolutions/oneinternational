
package br.com.lab360.bioprime.logic.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Product {

    @SerializedName("product_id")
    @Expose
    private int productId;
    @SerializedName("catalog_id")
    @Expose
    private int catalogId;
    @SerializedName("tab_ma_category_id")
    @Expose
    private int tabMaCategoryId;
    @SerializedName("sku")
    @Expose
    private String sku;
    @SerializedName("reference")
    @Expose
    private String reference;
    @SerializedName("size")
    @Expose
    private Object size;
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("category")
    @Expose
    private String category;
    @SerializedName("family")
    @Expose
    private String family;
    @SerializedName("price_of")
    @Expose
    private String priceOf;
    @SerializedName("price_per")
    @Expose
    private String pricePer;
    @SerializedName("local")
    @Expose
    private int local;
    @SerializedName("pagine")
    @Expose
    private int pagine;
    @SerializedName("flg_rescue")
    @Expose
    private int flgRescue;
    @SerializedName("price_point")
    @Expose
    private int pricePoint;
    @SerializedName("status")
    @Expose
    private String status;
    @SerializedName("url_image")
    @Expose
    private String urlImage;
    @SerializedName("product_error")
    @Expose
    private Object productError;
    @SerializedName("msg_valid_digit_1")
    @Expose
    private Object msgValidDigit1;
    @SerializedName("msg_valid_digit_2")
    @Expose
    private String msgValidDigit2;
    @SerializedName("tag")
    @Expose
    private String tag;
    @SerializedName("values")
    @Expose
    private List<Value> values = null;

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCatalogId() {
        return catalogId;
    }

    public void setCatalogId(int catalogId) {
        this.catalogId = catalogId;
    }

    public int getTabMaCategoryId() {
        return tabMaCategoryId;
    }

    public void setTabMaCategoryId(int tabMaCategoryId) {
        this.tabMaCategoryId = tabMaCategoryId;
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

    public Object getSize() {
        return size;
    }

    public void setSize(Object size) {
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

    public int getPricePoint() {
        return pricePoint;
    }

    public void setPricePoint(int pricePoint) {
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

    public Object getProductError() {
        return productError;
    }

    public void setProductError(Object productError) {
        this.productError = productError;
    }

    public Object getMsgValidDigit1() {
        return msgValidDigit1;
    }

    public void setMsgValidDigit1(Object msgValidDigit1) {
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

    public List<Value> getValues() {
        return values;
    }

    public void setValues(List<Value> values) {
        this.values = values;
    }

}
