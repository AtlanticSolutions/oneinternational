package br.com.lab360.oneinternacional.logic.geofence;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import androidx.core.app.NotificationCompat;
import android.widget.Toast;

import com.google.android.gms.location.Geofence;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.geofence.GeofenceMessage;

public class GeofenceNotification {
    public static final int NOTIFICATION_ID = 20;

    protected Context context;

    protected NotificationManager notificationManager;
    protected Notification notification;

    public GeofenceNotification(Context context) {
        this.context = context;

        this.notificationManager = (NotificationManager) context
                .getSystemService(Context.NOTIFICATION_SERVICE);
    }

    protected void buildNotificaction(GeofenceMessage message, int transitionType) {

        String notificationText = "";
        //Object[] notificationTextParams = new Object[] { region.getId() };

        switch (transitionType) {
            case Geofence.GEOFENCE_TRANSITION_DWELL:
		    /*
			notificationText = String.format(
					context.getString(R.string.geofence_dwell),
					notificationTextParams);
			*/
                break;

            case Geofence.GEOFENCE_TRANSITION_ENTER:
                notificationText = message.getMessage();
                break;

            case Geofence.GEOFENCE_TRANSITION_EXIT:
                notificationText =  message.getMessage();
                break;
        }

        Toast.makeText(context, notificationText, Toast.LENGTH_LONG).show();

        if(!notificationText.equals("")){
            NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(
                    context)
                    .setSmallIcon(R.drawable.ic_launcher)
                    .setContentTitle(context.getString(R.string.app_name))
                    .setContentText(notificationText).setAutoCancel(true);
            notification = notificationBuilder.build();
            notification.defaults |= Notification.DEFAULT_LIGHTS;
            notification.defaults |= Notification.DEFAULT_SOUND;
            notification.defaults |= Notification.DEFAULT_VIBRATE;
        }

    }

    public void displayNotification(GeofenceMessage message,
                                    int transitionType) {
        buildNotificaction(message, transitionType);

        if(notification != null){
            notificationManager.notify(NOTIFICATION_ID, notification);
        }
    }
}
