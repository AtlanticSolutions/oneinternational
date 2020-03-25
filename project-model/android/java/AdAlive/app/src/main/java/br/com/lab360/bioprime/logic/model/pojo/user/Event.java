package br.com.lab360.bioprime.logic.model.pojo.user;

import android.os.Parcel;
import android.os.Parcelable;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class Event implements Parcelable {
    private int id;
    private String name, language, local, schedule, description;

    @SerializedName("image_url")
    private String eventImage;

    @SerializedName("description_speacker")
    private String speackerDetails;

    @SerializedName("name_speacker")
    private String speackerName;

    private boolean registered;

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getLanguage() {
        return language;
    }

    public String getLocal() {
        return local;
    }

    public String getSchedule() {
        return schedule;
    }

    public String getDescription() {
        return description;
    }

    public boolean isRegistered() {
        return registered;
    }

    public void setRegistered(boolean registered) {
        this.registered = registered;
    }

    public String getSpeackerDetails() {
        return speackerDetails;
    }

    public String getEventImage() {
        return eventImage;
    }

    public String getSpeackerName() {
        return speackerName;
    }

    public void setSpeackerName(String speackerName) {
        this.speackerName = speackerName;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.id);
        dest.writeString(this.name);
        dest.writeString(this.language);
        dest.writeString(this.local);
        dest.writeString(this.schedule);
        dest.writeString(this.description);
        dest.writeByte(this.registered ? (byte) 1 : (byte) 0);
        dest.writeString(this.speackerDetails);
        dest.writeString(this.eventImage);
        dest.writeString(this.speackerName);
    }

    public Event() {
    }

    protected Event(Parcel in) {

        this.id = in.readInt();
        this.name = in.readString();
        this.language = in.readString();
        this.local = in.readString();
        this.schedule = in.readString();
        this.description = in.readString();
        this.registered = in.readByte() != 0;

        this.speackerDetails = in.readString();
        this.eventImage = in.readString();
        this.speackerName= in.readString();


    }

    public static final Creator<Event> CREATOR = new Creator<Event>() {
        @Override
        public Event createFromParcel(Parcel source) {
            return new Event(source);
        }

        @Override
        public Event[] newArray(int size) {
            return new Event[size];
        }
    };
}
