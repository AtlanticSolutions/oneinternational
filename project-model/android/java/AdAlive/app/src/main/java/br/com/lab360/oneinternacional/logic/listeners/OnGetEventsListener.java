package br.com.lab360.oneinternacional.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.user.Event;


/**
 * Created by Alessandro Valenza on 25/11/2016.
 */

public interface OnGetEventsListener {
    void onEventsLoadSuccess(ArrayList<Event> events);
    void onEventsLoadError(String error);
}
