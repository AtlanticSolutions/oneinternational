package br.com.lab360.oneinternacional.logic.model.pojo.videos;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class Video implements Parcelable {

    @SerializedName("id")
    private int id;
    @SerializedName("title")
    private String title;
    @SerializedName("thumbnail_url")
    private String thumb;
    @SerializedName("url")
    private String url;
    @SerializedName("name")
    private String name;
    @SerializedName("duration")
    private int duration;
    @SerializedName("author")
    private String author;
    @SerializedName("date")
    private String date;
    @SerializedName("description")
    private String description;
    @SerializedName("href_video")
    private String hrefVideo;

    public Video() {
    }

    public Video(int id, String title, String thumb, String url, String name,
                 int duration, String author, String date, String description) {
        this.id = id;
        this.title = title;
        this.thumb = thumb;
        this.url = url;
        this.name = name;
        this.duration = duration;
        this.author = author;
        this.date = date;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title == null ? "" : title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumb() {
        return thumb == null ? "" : thumb;
    }

    public void setThumb(String thumb) {
        this.thumb = thumb;
    }

    public String getUrl() {
        return url == null ? "" : url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getName() {
        return name == null ? "" : name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getAuthor() {
        return author == null ? "" : author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getDate() {
        return date == null ? "" : date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDescription() {
        return description == null ? "" : description;
    }

    public void setDescription(String description) {
        this.description = description;
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
        dest.writeInt(this.id);
        dest.writeString(this.title);
        dest.writeString(this.thumb);
        dest.writeString(this.url);
        dest.writeString(this.name);
        dest.writeInt(this.duration);
        dest.writeString(this.author);
        dest.writeString(this.date);
        dest.writeString(this.description);
    }

    protected Video(Parcel in) {
        this.id = in.readInt();
        this.title = in.readString();
        this.thumb = in.readString();
        this.url = in.readString();
        this.name = in.readString();
        this.duration = in.readInt();
        this.author = in.readString();
        this.date = in.readString();
        this.description = in.readString();
    }

    public static final Creator<Video> CREATOR = new Creator<Video>() {
        @Override
        public Video createFromParcel(Parcel source) {
            return new Video(source);
        }

        @Override
        public Video[] newArray(int size) {
            return new Video[size];
        }
    };
}
