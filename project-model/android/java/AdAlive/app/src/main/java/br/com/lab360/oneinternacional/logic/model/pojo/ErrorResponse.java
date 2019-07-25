package br.com.lab360.oneinternacional.logic.model.pojo;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 23/11/2016.
 */

public class ErrorResponse implements Parcelable {
    private ArrayList<String> email;
    private ArrayList<String> password;

    public String getEmailErrorMessage() {
        return (email != null && email.size() > 0) ? email.get(0) : null;
    }

    public String getPasswordErrorMessage() {
        return (password != null && password.size() > 0) ? password.get(0) : null;
    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeStringList(this.email);
        dest.writeStringList(this.password);
    }

    public ErrorResponse() {
    }

    protected ErrorResponse(Parcel in) {
        this.email = in.createStringArrayList();
        this.password = in.createStringArrayList();
    }

    public static final Parcelable.Creator<ErrorResponse> CREATOR = new Parcelable.Creator<ErrorResponse>() {
        @Override
        public ErrorResponse createFromParcel(Parcel source) {
            return new ErrorResponse(source);
        }

        @Override
        public ErrorResponse[] newArray(int size) {
            return new ErrorResponse[size];
        }
    };
}
