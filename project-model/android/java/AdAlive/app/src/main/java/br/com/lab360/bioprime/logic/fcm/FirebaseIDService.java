package br.com.lab360.bioprime.logic.fcm;

import android.content.Intent;

import com.google.firebase.iid.FirebaseInstanceIdService;

/**
 * Created by Victor Santiago on 25/11/2016.
 */
public class FirebaseIDService extends FirebaseInstanceIdService {

    private static final String TAG = "REGISTER_INTENT_SERVICE";

    @Override
    public void onTokenRefresh() {
        super.onTokenRefresh();
        Intent intent = new Intent(this, RegistrationInstanceIDService.class);
        startService(intent);
    }
}
