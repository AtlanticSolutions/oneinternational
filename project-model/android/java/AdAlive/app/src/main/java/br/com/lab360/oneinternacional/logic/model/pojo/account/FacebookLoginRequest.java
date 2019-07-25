package br.com.lab360.oneinternacional.logic.model.pojo.account;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */
public class FacebookLoginRequest {

    @SerializedName("master_event_id")
    private int masterEventId;
    @SerializedName("fb_access_token")
    private String token;
    @SerializedName("fb_id")
    private String fbid;
    @SerializedName("first_name")
    private String name;

    private boolean create;

    private String email;

    public FacebookLoginRequest(int masterEventId, String token, String fbid, String name, String email) {
        this.masterEventId = masterEventId;
        this.token = token;
        this.fbid = fbid;
        this.name = name;
        this.create = true;
        this.email = email;
    }

}
