package br.com.lab360.oneinternacional.logic;

import android.content.Context;
import com.google.gson.JsonObject;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.listeners.OnRegionMessageLoadedListener;
import lib.utils.UtilsAdAlive;
import lib.web.AdAliveService;
import lib.web.MethodsAdAliveManager;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class GeofenceWS{

    public static void attemptCallRegionMessage(int geofenceId, int type, int deviceIdVendor, String email, double latitude, double longitude, Context context, final OnRegionMessageLoadedListener listener) {
        if (UtilsAdAlive.isNetworkAvailable(context)) {
            String userEmail = AdaliveApplication.getInstance().getUser().getEmail();
            MethodsAdAliveManager.getInstance().initDeviceLogHeader(true, context, userEmail);
            AdAliveService service = MethodsAdAliveManager.getInstance().getAdAliveService();
            service.getRegionMessage(geofenceId, type, deviceIdVendor, email, latitude,longitude).enqueue(new Callback<JsonObject>() {
                public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                    listener.onRegionMessageLoadSuccess(response);
                }

                public void onFailure(Call<JsonObject> call, Throwable t) {
                    MethodsAdAliveManager.getInstance().initDeviceLogHeader(false, (Context)null, (String)null);
                    listener.onRegionMessageLoadError(t.getMessage());
                }
            });
        } else {
            MethodsAdAliveManager.getInstance().initDeviceLogHeader(false, (Context)null, (String)null);
        }
    }
}
