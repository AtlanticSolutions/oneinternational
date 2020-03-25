package br.com.lab360.bioprime.logic.model.pojo.timeline;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class LikeObject implements Parcelable {
    private int id;
    @SerializedName("app_user")
    private BaseObject appUser;

    public int getId() {
        return id;
    }

    public BaseObject getAppUser() {
        return appUser;
    }

    public LikeObject(BaseObject appUser) {
        this.appUser = appUser;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeParcelable(this.appUser, flags);
    }

    public LikeObject() {
    }

    protected LikeObject(Parcel in) {
        this.id = in.readInt();
        this.appUser = in.readParcelable(BaseObject.class.getClassLoader());
    }

    public static final Parcelable.Creator<LikeObject> CREATOR = new Parcelable.Creator<LikeObject>() {
        @Override
        public LikeObject createFromParcel(Parcel source) {
            return new LikeObject(source);
        }

        @Override
        public LikeObject[] newArray(int size) {
            return new LikeObject[size];
        }
    };
}
