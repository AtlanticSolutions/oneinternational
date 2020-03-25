package br.com.lab360.bioprime.logic.model.pojo.layout;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.pojo.user.LayoutParam;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */

public class LayoutConfigResponse {

    @SerializedName("app")
    private LayoutParam params;

    public LayoutParam getParams() {
        return params;
    }

}
