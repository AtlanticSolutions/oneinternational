package br.com.lab360.bioprime.logic.adalive;

import android.content.Context;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.util.Observable;
import lib.location.GPSTracker;
import lib.manager.LogManager;

class AdAliveBase extends Observable {
    String urlServer;
    String userEmail;
    Context context;
    JsonArray jsonArrayResponse;
    JsonObject jsonResponse;
    LogManager logManager;
    GPSTracker gpsTracker;

    AdAliveBase() {
    }

    public String getUrlServer() {
        return this.urlServer;
    }

    public void setUrlServer(String urlServer) {
        this.urlServer = urlServer;
    }

    public String getUserEmail() {
        return this.userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
}