package br.com.lab360.oneinternacional.logic.model.pojo.sponsor;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class Sponsors implements Parcelable {

    @SerializedName("sponsors")
    private List<Sponsor> mSponsors;

    public Sponsors() {
        mSponsors = new ArrayList<>();
    }

    public Sponsors(List<Sponsor> mSponsors) {
        this.mSponsors = mSponsors;
    }

    public List<Sponsor> getmSponsors() {
        return mSponsors;
    }

    public void setSponsors(List<Sponsor> mSponsors) {
        this.mSponsors = mSponsors;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.mSponsors);
    }

    protected Sponsors(Parcel in) {
        this.mSponsors = in.createTypedArrayList(Sponsor.CREATOR);
    }

    public static final Creator<Sponsors> CREATOR = new Creator<Sponsors>() {
        @Override
        public Sponsors createFromParcel(Parcel source) {
            return new Sponsors(source);
        }

        @Override
        public Sponsors[] newArray(int size) {
            return new Sponsors[size];
        }
    };
}
