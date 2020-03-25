package br.com.lab360.bioprime.logic.model.pojo.timeline;

import android.os.Parcel;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */

public class TimelineAppUser extends BaseObject {

    @SerializedName("image_url")
    private String imageUrl;

    public String getImageUrl() {
        return imageUrl;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.imageUrl);
    }

    public TimelineAppUser() {
    }

    protected TimelineAppUser(Parcel in) {
        super(in);
        this.imageUrl = in.readString();
    }

    public static final Creator<TimelineAppUser> CREATOR = new Creator<TimelineAppUser>() {
        @Override
        public TimelineAppUser createFromParcel(Parcel source) {
            return new TimelineAppUser(source);
        }

        @Override
        public TimelineAppUser[] newArray(int size) {
            return new TimelineAppUser[size];
        }
    };
}
