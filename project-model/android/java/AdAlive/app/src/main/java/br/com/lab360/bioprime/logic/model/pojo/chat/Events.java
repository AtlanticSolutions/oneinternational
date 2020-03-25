package br.com.lab360.bioprime.logic.model.pojo.chat;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;
import java.util.List;

/**
 * AHK Event.
 * Created by Victor Santiago on 10/08/2016.
 */
public class Events implements Parcelable {

    private List<Event> listEvents;

    public Events() {
    }

    public Events(List<Event> listEvents) {
        this.listEvents = listEvents;
    }

    public List<Event> getListEvents() {
        return listEvents == null ? new ArrayList<Event>() : listEvents;
    }

    public void setListEvents(List<Event> listEvents) {
        this.listEvents = listEvents;
    }

    public void setEventRegisteredById(int id) {

        for (Event event : listEvents) {
            if (event.getId() == id) {
                event.setRegistered(true);

            }

        }

    }


    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeTypedList(this.listEvents);
    }

    protected Events(Parcel in) {
        this.listEvents = in.createTypedArrayList(Event.CREATOR);
    }

    public static final Creator<Events> CREATOR = new Creator<Events>() {
        @Override
        public Events createFromParcel(Parcel source) {
            return new Events(source);
        }

        @Override
        public Events[] newArray(int size) {
            return new Events[size];
        }
    };
}
