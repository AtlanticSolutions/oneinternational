package br.com.lab360.oneinternacional.logic.model.pojo.roles;


import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;


public class RoleResponse {

    @SerializedName("job_roles")
    private ArrayList<RoleObject> roleObjects;

    public ArrayList<RoleObject> getRoleObjects() {
        return roleObjects;
    }

}
