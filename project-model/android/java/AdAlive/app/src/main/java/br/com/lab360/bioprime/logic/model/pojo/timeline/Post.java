package br.com.lab360.bioprime.logic.model.pojo.timeline;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */

public class Post implements Parcelable {
    private String title, message;
    private boolean denunciation;
    private int id;

    @SerializedName("account_id")
    private int accountId;
    @SerializedName("app_user_id")
    private int appUserId;
    @SerializedName("app_id")
    private int appId;
    @SerializedName("picture_url")
    private String pictureUrl;
    @SerializedName("base64_picture")
    private String pictureBase64;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("app_user")
    private TimelineAppUser appUser;

    private boolean sponsor;
    @SerializedName("sponsor_url")
    private String sponsorUrl;

    @SerializedName("href_video")
    private String hrefVideo;

    private ArrayList<LikeObject> like;
    private ArrayList<CommentObject> comment;

    private boolean errors;

    public Post() {
    }

    public Post(String title, String message, int accountId, int appUserId, int appId, String pictureBase64) {
        this.title = title;
        this.message = message;
        this.accountId = accountId;
        this.appUserId = appUserId;
        this.appId = appId;
        this.pictureBase64 = pictureBase64;
    }

    public boolean hasErrors() {
        return errors;
    }

    public String getSponsorUrl() {
        return sponsorUrl;
    }

    public boolean isSponsor() {
        return sponsor;
    }

    public void setPictureBase64(String pictureBase64) {
        this.pictureBase64 = pictureBase64;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getMessage() {
        return message;
    }

    public boolean isDenunciation() {
        return denunciation;
    }

    public int getAccountId() {
        return accountId;
    }

    public int getAppUserId() {
        return appUserId;
    }

    public int getAppId() {
        return appId;
    }

    public String getPictureUrl() {
        return pictureUrl;
    }

    public String getPictureBase64() {
        return pictureBase64;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public TimelineAppUser getAppUser() {
        return appUser;
    }

    public ArrayList<LikeObject> getLike() {
        return like;
    }

    public ArrayList<CommentObject> getComment() {
        return comment;
    }

    public String getHrefVideo() {
        return hrefVideo;
    }

    public void setHrefVideo(String hrefVideo) {
        this.hrefVideo = hrefVideo;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.title);
        dest.writeString(this.message);
        dest.writeByte(this.denunciation ? (byte) 1 : (byte) 0);
        dest.writeInt(this.id);
        dest.writeInt(this.accountId);
        dest.writeInt(this.appUserId);
        dest.writeInt(this.appId);
        dest.writeString(this.pictureUrl);
        dest.writeString(this.hrefVideo);
        dest.writeString(this.pictureBase64);
        dest.writeString(this.createdAt);
        dest.writeParcelable(this.appUser, flags);
        dest.writeByte(this.sponsor ? (byte) 1 : (byte) 0);
        dest.writeString(this.sponsorUrl);
        dest.writeTypedList(this.like);
        dest.writeTypedList(this.comment);
        dest.writeByte(this.errors ? (byte) 1 : (byte) 0);
    }

    protected Post(Parcel in) {
        this.title = in.readString();
        this.message = in.readString();
        this.denunciation = in.readByte() != 0;
        this.id = in.readInt();
        this.accountId = in.readInt();
        this.appUserId = in.readInt();
        this.appId = in.readInt();
        this.pictureUrl = in.readString();
        this.hrefVideo = in.readString();
        this.pictureBase64 = in.readString();
        this.createdAt = in.readString();
        this.appUser = in.readParcelable(TimelineAppUser.class.getClassLoader());
        this.sponsor = in.readByte() != 0;
        this.sponsorUrl = in.readString();
        this.like = in.createTypedArrayList(LikeObject.CREATOR);
        this.comment = in.createTypedArrayList(CommentObject.CREATOR);
        this.errors = in.readByte() != 0;
    }

    public static final Creator<Post> CREATOR = new Creator<Post>() {
        @Override
        public Post createFromParcel(Parcel source) {
            return new Post(source);
        }

        @Override
        public Post[] newArray(int size) {
            return new Post[size];
        }
    };
}
