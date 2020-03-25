package br.com.lab360.bioprime.logic.fcm;

import android.app.IntentService;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;

import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.interactor.InteractiveNotificationInteractor;
import br.com.lab360.bioprime.utils.NetworkStatsUtil;

/**
 * Created by Victor Santiago on 17/01/2017.
 */
public class InteractiveNotificationWsService extends IntentService {

    public InteractiveNotificationWsService() {

        super("InteractiveNotificationWsService");

    }

    public InteractiveNotificationWsService(String name) {

        super(name);

    }

    @Override
    public void onHandleIntent(Intent intent) {

        if (intent != null) {

            if(NetworkStatsUtil.isConnected(this)) {

                int notifId = intent.getIntExtra("notificationId", 0);

                NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                manager.cancel(notifId);

                String notificationId = intent.getExtras().getString(AdaliveConstants.NOTIFICATION_ID);

                InteractiveNotificationInteractor.postNotificationAction(this, notificationId);

            }

        }

    }

}
