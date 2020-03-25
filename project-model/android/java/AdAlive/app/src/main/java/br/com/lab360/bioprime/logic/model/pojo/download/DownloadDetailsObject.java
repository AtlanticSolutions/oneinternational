package br.com.lab360.bioprime.logic.model.pojo.download;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by Alessandro Valenza on 26/10/2016.
 */

public class DownloadDetailsObject implements Parcelable {
    private String author, price, fileName, company;

    public DownloadDetailsObject(String author, String price, String fileName, String company) {
        this.author = author;
        this.price = price;
        this.fileName = fileName;
        this.company = company;
    }

    public String getPrice() {
        return price;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getCompany() {
        return company;
    }

    public void setCompany(String company) {
        this.company = company;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.author);
        dest.writeString(this.price);
        dest.writeString(this.fileName);
        dest.writeString(this.company);
    }

    protected DownloadDetailsObject(Parcel in) {
        this.author = in.readString();
        this.price = in.readString();
        this.fileName = in.readString();
        this.company = in.readString();
    }

    public static final Creator<DownloadDetailsObject> CREATOR = new Creator<DownloadDetailsObject>() {
        @Override
        public DownloadDetailsObject createFromParcel(Parcel source) {
            return new DownloadDetailsObject(source);
        }

        @Override
        public DownloadDetailsObject[] newArray(int size) {
            return new DownloadDetailsObject[size];
        }
    };
}
