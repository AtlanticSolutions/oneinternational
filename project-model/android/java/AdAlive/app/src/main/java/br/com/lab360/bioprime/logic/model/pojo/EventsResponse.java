package br.com.lab360.bioprime.logic.model.pojo;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.Event;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class EventsResponse {
    private ArrayList<Event> events;

    public EventsResponse() {
        events = new ArrayList<>();
    }

    public ArrayList<Event> getEvents() {
        return events;
    }
}
