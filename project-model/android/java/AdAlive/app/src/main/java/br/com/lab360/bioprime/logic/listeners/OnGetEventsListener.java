package br.com.lab360.bioprime.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.Event;


/**
 * Created by Alessandro Valenza on 25/11/2016.
 */

public interface OnGetEventsListener {
    void onEventsLoadSuccess(ArrayList<Event> events);
    void onEventsLoadError(String error);
}
