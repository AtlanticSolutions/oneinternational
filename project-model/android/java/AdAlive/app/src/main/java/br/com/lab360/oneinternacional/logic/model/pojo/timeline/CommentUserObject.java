package br.com.lab360.oneinternacional.logic.model.pojo.timeline;

import android.os.Parcel;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Pryds on 20/01/2017.
 */
public class CommentUserObject extends BaseObject {

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

    public CommentUserObject() {
    }

    protected CommentUserObject(Parcel in) {
        super(in);
        this.imageUrl = in.readString();
    }

    public static final Creator<CommentUserObject> CREATOR = new Creator<CommentUserObject>() {
        @Override
        public CommentUserObject createFromParcel(Parcel source) {
            return new CommentUserObject(source);
        }

        @Override
        public CommentUserObject[] newArray(int size) {
            return new CommentUserObject[size];
        }
    };
}
