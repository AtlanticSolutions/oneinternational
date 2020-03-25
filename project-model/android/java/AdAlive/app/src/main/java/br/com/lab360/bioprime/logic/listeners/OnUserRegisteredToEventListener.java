package br.com.lab360.bioprime.logic.listeners;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */
public interface OnUserRegisteredToEventListener {
    void onRegisterError(String error);
    void onRegisterSuccess(ArrayList<Integer> events);
}
