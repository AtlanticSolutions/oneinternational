package br.com.lab360.oneinternacional.logic.rxbus.events;

import br.com.lab360.oneinternacional.logic.model.pojo.user.Event;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */

public class EventChanged {
    private Event event;

    public EventChanged(Event event) {
        this.event = event;
    }

    public Event getEvent() {
        return event;
    }
}
