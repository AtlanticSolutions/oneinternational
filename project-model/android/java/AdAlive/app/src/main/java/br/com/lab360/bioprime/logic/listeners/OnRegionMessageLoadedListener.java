package br.com.lab360.bioprime.logic.listeners;

import com.google.gson.JsonObject;
import retrofit2.Response;

public interface OnRegionMessageLoadedListener {
    void onRegionMessageLoadSuccess(Response<JsonObject> response);
    void onRegionMessageLoadError(String message);
}