package br.com.lab360.oneinternacional.logic.model.pojo.roles;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Paulo santos on 14/08/2017.
 */

public class RoleObject {

    @SerializedName("id")
    private int id;

    @SerializedName("description")
    private String description;

    public int getId() {
        return id;
    }

    public String getDescription() {
        return description;
    }
}
