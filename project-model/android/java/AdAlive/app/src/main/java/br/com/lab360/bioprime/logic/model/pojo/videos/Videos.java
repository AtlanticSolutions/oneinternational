package br.com.lab360.bioprime.logic.model.pojo.videos;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class Videos implements Parcelable {

    @SerializedName("videos")
    private List<Video> mVideos;

    public Videos() {
        mVideos = new ArrayList<>();
    }

    public Videos(List<Video> mVideos) {
        this.mVideos = mVideos;
    }

    public List<Video> getmVideos() {
        return mVideos;
    }

    public void setmVideos(List<Video> mVideos) {
        this.mVideos = mVideos;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.mVideos);
    }

    protected Videos(Parcel in) {
        this.mVideos = in.createTypedArrayList(Video.CREATOR);
    }

    public static final Creator<Videos> CREATOR = new Creator<Videos>() {
        @Override
        public Videos createFromParcel(Parcel source) {
            return new Videos(source);
        }

        @Override
        public Videos[] newArray(int size) {
            return new Videos[size];
        }
    };
}
