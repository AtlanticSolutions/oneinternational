package br.com.lab360.bioprime.logic.model.pojo.datasummary;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;


public class DataSummary implements Parcelable {

    @SerializedName("notification_not_read")
    private int notificationUnread;

    @SerializedName("chat_not_read")
    private int chatUnread;


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.notificationUnread);
        dest.writeInt(this.chatUnread);
    }

    protected DataSummary(Parcel in) {
        this.notificationUnread = in.readInt();
        this.chatUnread = in.readInt();
    }

    public static final Creator<DataSummary> CREATOR = new Creator<DataSummary>() {
        @Override
        public DataSummary createFromParcel(Parcel source) {
            return new DataSummary(source);
        }

        @Override
        public DataSummary[] newArray(int size) {
            return new DataSummary[size];
        }
    };

    public int getChatUnread() {
        return chatUnread;
    }

    public int getNotificationUnread() {
        return notificationUnread;
    }
}
