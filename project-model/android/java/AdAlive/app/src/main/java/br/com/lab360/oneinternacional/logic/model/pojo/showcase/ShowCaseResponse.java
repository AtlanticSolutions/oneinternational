package br.com.lab360.oneinternacional.logic.model.pojo.showcase;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 08/05/2018.
 */

public class ShowCaseResponse {

    @SerializedName("virtual_showcase_gallery")
    ShowCaseGalery showCaseGalery;

    public ShowCaseGalery getShowCaseGalery() {
        return showCaseGalery;
    }

    public void setShowCaseGalery(ShowCaseGalery showCaseGalery) {
        this.showCaseGalery = showCaseGalery;
    }
}
