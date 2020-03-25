package br.com.lab360.bioprime.logic.model.pojo.download;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 26/10/2016.
 */

public class DownloadInfoObject implements Parcelable {
    @SerializedName("event_id")
    private int eventId;

    @SerializedName("file_extension")
    private String fileExtension;

    @SerializedName("url_file")
    private String urlFile;

    @SerializedName("url_image")
    private String urlImage;


    @SerializedName("number_of_pages")
    private int numberOfPages;

    private String author, language, title, description;
    private int id;
    private boolean visible;


    public int getId() {
        return id;
    }

    public int getEventId() {
        return eventId;
    }

    public String getFileExtension() {
        return fileExtension;
    }

    public String getUrlFile() {
        return urlFile;
    }

    public String getUrlImage() {
        return urlImage;
    }

    public void setUrlImage(String urlImage) {
        this.urlImage = urlImage;
    }

    public int getNumberOfPages() {
        return numberOfPages;
    }

    public String getLanguage() {
        return language;
    }

    public String getAuthor() {
        return author;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public boolean isVisible() {
        return visible;
    }

    public void setVisible(boolean visible) {
        this.visible = visible;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.eventId);
        dest.writeString(this.fileExtension);
        dest.writeString(this.urlFile);
        dest.writeInt(this.numberOfPages);
        dest.writeString(this.author);
        dest.writeString(this.language);
        dest.writeString(this.title);
        dest.writeString(this.description);
        dest.writeInt(this.id);
        dest.writeByte(this.visible ? (byte) 1 : (byte) 0);
    }

    public DownloadInfoObject() {
    }

    protected DownloadInfoObject(Parcel in) {
        this.eventId = in.readInt();
        this.fileExtension = in.readString();
        this.urlFile = in.readString();
        this.numberOfPages = in.readInt();
        this.author = in.readString();
        this.language = in.readString();
        this.title = in.readString();
        this.description = in.readString();
        this.id = in.readInt();
        this.visible = in.readByte() != 0;
    }

    public static final Creator<DownloadInfoObject> CREATOR = new Creator<DownloadInfoObject>() {
        @Override
        public DownloadInfoObject createFromParcel(Parcel source) {
            return new DownloadInfoObject(source);
        }

        @Override
        public DownloadInfoObject[] newArray(int size) {
            return new DownloadInfoObject[size];
        }
    };
}
