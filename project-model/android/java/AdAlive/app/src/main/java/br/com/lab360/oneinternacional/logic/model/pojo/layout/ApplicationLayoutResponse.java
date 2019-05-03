package br.com.lab360.oneinternacional.logic.model.pojo.layout;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.oneinternacional.logic.model.pojo.user.ApplicationLayout;

/**
 * Created by Paulo Roberto on 03/08/2017.
 */

public class ApplicationLayoutResponse {
    @SerializedName("app")
    private ApplicationLayout params;

    public ApplicationLayout getParams() {
        return params;
    }
}
