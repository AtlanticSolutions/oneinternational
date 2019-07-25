package br.com.lab360.oneinternacional.logic.model.pojo.showcase;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCaseCategory implements Parcelable {

    @SerializedName("id")
    public String id;
    @SerializedName("name")
    public String name;
    @SerializedName("detail")
    public String detail;
    @SerializedName("picture_url")
    public String pictureURL;
    @SerializedName("mask_model_url")
    public String maskModelURL;
    @SerializedName("front_camera_preferable")
    boolean front_camera_preferable;
    @SerializedName("products")
    private List<ShowCaseProduct> products;
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

    public String getMaskModelURL() {
        return maskModelURL;
    }

    public void setMaskModelURL(String maskModelURL) {
        this.maskModelURL = maskModelURL;
    }

    public boolean isFrontCameraPreferable() {
        return front_camera_preferable;
    }

    public void setFrontCameraPreferable(boolean front_camera_preferable) {
        this.front_camera_preferable = front_camera_preferable;
    }

    public List<ShowCaseProduct> getProducts() {
        return products;
    }

    public void setProducts(List<ShowCaseProduct> products) {
        this.products = products;
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
        dest.writeString(this.maskModelURL);
        dest.writeByte(this.front_camera_preferable ? (byte) 1 : (byte) 0);
        dest.writeList(this.products);
    }

    public ShowCaseCategory() {
    }

    protected ShowCaseCategory(Parcel in) {
        this.id = in.readString();
        this.name = in.readString();
        this.detail = in.readString();
        this.pictureURL = in.readString();
        this.maskModelURL = in.readString();
        this.front_camera_preferable = in.readByte() != 0;
        this.products = new ArrayList<ShowCaseProduct>();
        in.readList(this.products, ShowCaseProduct.class.getClassLoader());
    }

    public static final Parcelable.Creator<ShowCaseCategory> CREATOR = new Parcelable.Creator<ShowCaseCategory>() {
        @Override
        public ShowCaseCategory createFromParcel(Parcel source) {
            return new ShowCaseCategory(source);
        }

        @Override
        public ShowCaseCategory[] newArray(int size) {
            return new ShowCaseCategory[size];
        }
    };
}
