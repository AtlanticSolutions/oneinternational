package br.com.lab360.oneinternacional.logic.listeners;

import com.google.gson.JsonArray;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public interface OnGetSponsorsListener {
    void onSponsorsLoadSuccess(JsonArray sponsors);
    void onSponsorsLoadError(String error);
}
