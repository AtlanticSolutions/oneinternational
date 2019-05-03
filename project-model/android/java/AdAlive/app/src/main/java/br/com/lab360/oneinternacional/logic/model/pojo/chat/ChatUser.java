package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class ChatUser {
    private int id;

    @SerializedName("first_name")
    private String firstName;

    @SerializedName("last_name")
    private String lastName;

    @SerializedName("email")
    private String email;

    @SerializedName("city")
    private String city;

    @SerializedName("state")
    private String state;

    @SerializedName("job_role")
    private String jobRole;

    public int getId() {
        return id;
    }

    public String getFirstName() {
        return firstName == null ? "" : firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getEmail() {
        return email;
    }

    public String getState() {
        return state;
    }

    public String getCity() {
        return city;
    }

    public String getJobRole() {
        return jobRole;
    }
}
