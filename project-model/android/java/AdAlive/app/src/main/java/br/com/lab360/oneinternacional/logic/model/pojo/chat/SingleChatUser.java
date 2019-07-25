package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import androidx.annotation.StringDef;

import com.google.common.base.Strings;
import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public class SingleChatUser {
    @SerializedName("app_user_id")
    private int id;

    @SerializedName("profile_image")
    private String profileImageUrl;

    private String name;
    private String email;
    private transient boolean selected;
    private String status;

    @SerializedName("job_role")
    private String jobRole;

    @SerializedName("city")
    private String city;

    @SerializedName("state")
    private String state;

    @SerializedName("not_read")
    private int unRead;

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isSelected() {
        return selected;
    }

    public String getProfileImageUrl() {
        return profileImageUrl;
    }

    public String getStatus() {
        return status;
    }

    public void changeStatus() {
        status = status.equals(UserStatus.ACTIVE) ? UserStatus.BLOCKED : UserStatus.ACTIVE;
    }

    public String getCity() {
        return Strings.isNullOrEmpty(city) ? "" : city;
    }

    public String getJobRole() {
        return Strings.isNullOrEmpty(jobRole) ? "" : jobRole;
    }

    public String getState() {
        return Strings.isNullOrEmpty(state) ? "" : state;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setJobRole(String jobRole) {
        this.jobRole = jobRole;
    }

    public void setState(String state) {
        this.state = state;
    }

    public int getUnRead() {
        return unRead;
    }

    @StringDef({UserStatus.ACTIVE, UserStatus.BLOCKED})
    public @interface UserStatus {
        String ACTIVE = "active";
        String BLOCKED = "blocked";
    }
}
