package br.com.lab360.bioprime.logic.beacon;
import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.Observable;
import java.util.Observer;

import br.com.lab360.bioprime.BuildConfig;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.BeaconResponse;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;
import lib.error.NullTargetNameException;
import lib.error.NullUrlServerException;
import lib.ui.AdAliveWS;
import lib.utils.ConstantsAdAlive;

/**
 * Created by Edson on 04/06/2018.
 */

public class BeaconWS {

    private static SharedPrefsHelper sharedPrefsHelper;
    private static AdAliveWS mAdAliveWS;
    private static BeaconResponse beaconsResponse;
    private static Gson gson;

    public static void initAdAliveWS(Context context) {
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        beaconsResponse = new BeaconResponse();
        gson = new Gson();

        String urlServer = ApiManager.getInstance().getUrlAdaliveApi(context);
        String userEmail;

        if(AdaliveApplication.getInstance().getUser() != null && AdaliveApplication.getInstance().getUser().getEmail() != null){
            userEmail = AdaliveApplication.getInstance().getUser().getEmail();
        }else{
            userEmail = "";
        }

        try {

            mAdAliveWS = new AdAliveWS(context, urlServer, userEmail);
            observe(mAdAliveWS);

        } catch (NullUrlServerException e) {

            Log.e(AdaliveConstants.ERROR, "initAdAliveWS: " + e.toString());

        }

        try {
            mAdAliveWS.callGetBeacons(Integer.valueOf(BuildConfig.APP_ID));
        } catch (NullTargetNameException e) {
            e.printStackTrace();
        }
    }

    public static void observe(Observable o) {
        o.addObserver(new Observer() {
            @Override
            public void update(Observable observable, Object data) {
                JsonObject jsonResponse;

                if (observable instanceof AdAliveWS) {
                    jsonResponse = ((AdAliveWS) observable).getJsonResponse();

                    if (jsonResponse != null) {

                        if (!jsonResponse.has(ConstantsAdAlive.TAG_ERRORS_SERVER)) {

                            beaconsResponse = gson.fromJson(jsonResponse, BeaconResponse.class);
                            sharedPrefsHelper.put("BEACONS_LIST", gson.toJson(beaconsResponse.getBeacons()));
                            AdaliveApplication.startMonitoringBeacons();
                        }
                    }

                }
            }
        });
    }

}
