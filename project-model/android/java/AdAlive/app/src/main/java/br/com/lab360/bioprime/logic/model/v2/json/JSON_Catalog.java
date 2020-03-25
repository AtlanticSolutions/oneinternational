package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_Catalog;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class JSON_Catalog {
    @SerializedName("id_catalog")
    public long      catalogID;

    @SerializedName("number")
    public String    number;

    @SerializedName("digit")
    public long      digit;

    @SerializedName("description")
    public String    cDescription;

    @SerializedName("date_start")
    public String    startDate;

    @SerializedName("date_end")
    public String    endDate;

    @SerializedName("tolerance")
    public long      tolerance;

    @SerializedName("status")
    public long      status;

    @SerializedName("url_cover")
    public String    urlCover;

    @SerializedName("url_tag")
    public String    urlTag;

    /**
     * Translate from REALM to JSON
     * @param data A valid realm
     */
    public JSON_Catalog(MA_Catalog data) {
        setCatalogID(data.getCatalogID());
        setNumber(data.getNumber());
        setDigit(data.getDigit());
        setcDescription(data.getcDescription());
        setStartDate(data.getStartDate());
        setEndDate(data.getEndDate());
        setTolerance(data.getTolerance());
        setStatus(data.getStatus());
        setUrlCover(getUrlCover());
        setUrlTag(getUrlTag());
    }

    public long getCatalogID() {
        return catalogID;
    }

    public void setCatalogID(long catalogID) {
        this.catalogID = catalogID;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public long getDigit() {
        return digit;
    }

    public void setDigit(long digit) {
        this.digit = digit;
    }

    public String getcDescription() {
        return cDescription;
    }

    public void setcDescription(String cDescription) {
        this.cDescription = cDescription;
    }

    public long getTolerance() {
        return tolerance;
    }

    public void setTolerance(long tolerance) {
        this.tolerance = tolerance;
    }

    public long getStatus() {
        return status;
    }

    public void setStatus(long status) {
        this.status = status;
    }

    public String getUrlCover() {
        return urlCover;
    }

    public void setUrlCover(String urlCover) {
        this.urlCover = urlCover;
    }

    public String getUrlTag() {
        return urlTag;
    }

    public void setUrlTag(String urlTag) {
        this.urlTag = urlTag;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }
}
