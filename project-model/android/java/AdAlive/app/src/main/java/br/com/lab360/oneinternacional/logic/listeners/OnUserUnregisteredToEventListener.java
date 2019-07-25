package br.com.lab360.oneinternacional.logic.listeners;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */
public interface OnUserUnregisteredToEventListener {
    void onUnregisterSuccess(ArrayList<Integer> events);
    void onUnregisterError(String error);
}
