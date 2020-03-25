package br.com.lab360.bioprime.logic.fcm;

import android.app.IntentService;
import android.content.Intent;
import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;

import br.com.lab360.bioprime.application.AdaliveApplication;

/**
 * Created by Atlantic Solutions on 02/11/2016.
 */
public class RegistrationInstanceIDService extends IntentService {

    private static final String TAG = "REGISTER_INTENT_SERVICE";
    public RegistrationInstanceIDService() {
        super(TAG);
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        try {
            synchronized (TAG) {
                String fcmToken = FirebaseInstanceId.getInstance().getToken();

                Log.i(TAG, "Registration gcmId: " + fcmToken);
                if (fcmToken != null) {
                    if(AdaliveApplication.getInstance() != null){
                        AdaliveApplication.getInstance().setFcmToken(fcmToken);
                    }
                }
            }

        } catch (Exception e) {
            Log.e(TAG, "Failed to complete gcmId refresh", e);
        }
    }
}
