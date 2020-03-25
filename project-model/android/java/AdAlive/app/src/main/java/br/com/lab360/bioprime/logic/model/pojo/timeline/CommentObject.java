package br.com.lab360.bioprime.logic.model.pojo.timeline;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class CommentObject implements Parcelable {
    private int id;
    private String message;
    @SerializedName("app_user")
    private CommentUserObject user;
    @SerializedName("created_at")
    private String createdAt;

    public String getCreatedAt() {
        return createdAt;
    }

    public int getId() {
        return id;
    }

    public String getMessage() {
        return message;
    }

    public CommentUserObject getUser() {
        return user;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.message);
        dest.writeParcelable(this.user, flags);
        dest.writeString(this.createdAt);
    }

    public CommentObject() {
    }

    protected CommentObject(Parcel in) {
        this.id = in.readInt();
        this.message = in.readString();
        this.user = in.readParcelable(CommentUserObject.class.getClassLoader());
        this.createdAt = in.readString();
    }

    public static final Creator<CommentObject> CREATOR = new Creator<CommentObject>() {
        @Override
        public CommentObject createFromParcel(Parcel source) {
            return new CommentObject(source);
        }

        @Override
        public CommentObject[] newArray(int size) {
            return new CommentObject[size];
        }
    };
}
