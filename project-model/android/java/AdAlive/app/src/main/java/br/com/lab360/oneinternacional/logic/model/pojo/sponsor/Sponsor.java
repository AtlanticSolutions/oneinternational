package br.com.lab360.oneinternacional.logic.model.pojo.sponsor;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class Sponsor implements Parcelable {

    @SerializedName("id")
    private int id;

    @SerializedName("name")
    private String name;

    @SerializedName("image_url")
    private String urlImage;

    @SerializedName("link")
    private String urlSponsorPage;

    public Sponsor() {
    }

    public Sponsor(int id, String name, String urlImage, String urlSponsorPage) {
        this.id = id;
        this.name = name;
        this.urlImage = urlImage;
        this.urlSponsorPage = urlSponsorPage;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name == null ? "" : name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrlImage() {
        return urlImage == null ? "" : urlImage;
    }

    public void setUrlImage(String urlImage) {
        this.urlImage = urlImage;
    }

    public String getUrlSponsorPage() {
        return urlSponsorPage == null ? "" : urlSponsorPage;
    }

    public void setUrlSponsorPage(String urlSponsorPage) {
        this.urlSponsorPage = urlSponsorPage;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.name);
        dest.writeString(this.urlImage);
        dest.writeString(this.urlSponsorPage);
    }

    protected Sponsor(Parcel in) {
        this.id = in.readInt();
        this.name = in.readString();
        this.urlImage = in.readString();
        this.urlSponsorPage = in.readString();
    }

    public static final Creator<Sponsor> CREATOR = new Creator<Sponsor>() {
        @Override
        public Sponsor createFromParcel(Parcel source) {
            return new Sponsor(source);
        }

        @Override
        public Sponsor[] newArray(int size) {
            return new Sponsor[size];
        }
    };
}
