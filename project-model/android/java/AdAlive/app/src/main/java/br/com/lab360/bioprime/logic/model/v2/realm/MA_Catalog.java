package br.com.lab360.bioprime.logic.model.v2.realm;


import br.com.lab360.bioprime.logic.model.v2.json.JSON_Catalog;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_Catalog extends RealmObject{
    @PrimaryKey
    public long      catalogID;
    public String    number;
    public long      digit;
    public String    cDescription;
    public String    startDate;
    public String    endDate;
    public long      tolerance;
    public long      status;
    public String    urlCover;
    public String    urlTag;

    public MA_Catalog(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_Catalog(JSON_Catalog data) {
        setCatalogID(data.getCatalogID());
        setNumber(data.getNumber());
        setDigit(data.getDigit());
        setcDescription(data.getcDescription());
        setStartDate(getStartDate());
        setEndDate(getStartDate());
        setTolerance(getTolerance());
        setStatus(getStatus());
        setUrlCover(getUrlTag());
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
