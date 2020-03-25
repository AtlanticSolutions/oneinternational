package br.com.lab360.bioprime.logic.model.pojo.showcase;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 08/05/2018.
 */

public class ShowCaseProduct implements Parcelable {

    @SerializedName("id")
    public String id;
    @SerializedName("name")
    public String name;
    @SerializedName("detail")
    public String detail;
    @SerializedName("picture_url")
    public String pictureURL;
    @SerializedName("mask_url")
    public String maskURL;
    @SerializedName("eyes_position")
    ShowCaseEyesPosition showCaseEyesPosition;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getPictureURL() {
        return pictureURL;
    }

    public void setPictureURL(String pictureURL) {
        this.pictureURL = pictureURL;
    }

    public String getMaskURL() {
        return maskURL;
    }

    public void setMaskURL(String maskURL) {
        this.maskURL = maskURL;
    }

    public ShowCaseEyesPosition getShowCaseEyesPosition() {
        return showCaseEyesPosition;
    }

    public void setShowCaseEyesPosition(ShowCaseEyesPosition showCaseEyesPosition) {
        this.showCaseEyesPosition = showCaseEyesPosition;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.id);
        dest.writeString(this.name);
        dest.writeString(this.detail);
        dest.writeString(this.pictureURL);
        dest.writeString(this.maskURL);
        dest.writeParcelable(this.showCaseEyesPosition, flags);
    }

    public ShowCaseProduct() {
    }

    protected ShowCaseProduct(Parcel in) {
        this.id = in.readString();
        this.name = in.readString();
        this.detail = in.readString();
        this.pictureURL = in.readString();
        this.maskURL = in.readString();
        this.showCaseEyesPosition = in.readParcelable(ShowCaseEyesPosition.class.getClassLoader());
    }

    public static final Parcelable.Creator<ShowCaseProduct> CREATOR = new Parcelable.Creator<ShowCaseProduct>() {
        @Override
        public ShowCaseProduct createFromParcel(Parcel source) {
            return new ShowCaseProduct(source);
        }

        @Override
        public ShowCaseProduct[] newArray(int size) {
            return new ShowCaseProduct[size];
        }
    };
}
