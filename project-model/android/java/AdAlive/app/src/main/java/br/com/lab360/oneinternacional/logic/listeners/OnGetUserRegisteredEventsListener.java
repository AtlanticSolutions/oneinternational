package br.com.lab360.oneinternacional.logic.listeners;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */
public interface OnGetUserRegisteredEventsListener {
    void onGetUserRegisteredEventsSuccess(ArrayList<Integer> eventIds);
    void onGetUserRegisteredEventsError(String error);
}
