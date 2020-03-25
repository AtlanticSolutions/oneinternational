package br.com.lab360.bioprime.logic.model.pojo.sponsor;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsPlan implements Parcelable {

    @SerializedName("id")
    private int id;

    @SerializedName("name")
    private String name;

    @SerializedName("order")
    private int order;

    @SerializedName("sponsors")
    private List<Sponsor> mSponsors;

    public SponsorsPlan() {
        mSponsors = new ArrayList<>();
    }

    public SponsorsPlan(List<Sponsor> mSponsors) {
        this.mSponsors = mSponsors;
    }

    public List<Sponsor> getmSponsors() {
        return mSponsors;
    }

    public void setSponsors(List<Sponsor> mSponsors) {
        this.mSponsors = mSponsors;
    }

    public int getId() {
        return id;
    }

    public int getOrder() {
        return order;
    }


    public String getName() {
        return name;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.mSponsors);
    }

    protected SponsorsPlan(Parcel in) {
        this.mSponsors = in.createTypedArrayList(Sponsor.CREATOR);
    }

    public static final Creator<SponsorsPlan> CREATOR = new Creator<SponsorsPlan>() {
        @Override
        public SponsorsPlan createFromParcel(Parcel source) {
            return new SponsorsPlan(source);
        }

        @Override
        public SponsorsPlan[] newArray(int size) {
            return new SponsorsPlan[size];
        }
    };
}
