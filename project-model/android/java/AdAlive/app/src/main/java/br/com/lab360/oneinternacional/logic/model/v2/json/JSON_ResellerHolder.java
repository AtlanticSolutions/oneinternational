package br.com.lab360.oneinternacional.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

/**
 * Created by paulo on 03/11/2017.
 */

public class JSON_ResellerHolder {
    @SerializedName("reseller")
    public JSON_Reseller reseller;

    public JSON_Reseller getReseller() {
        return reseller;
    }

    public void setReseller(JSON_Reseller reseller) {
        this.reseller = reseller;
    }
}
