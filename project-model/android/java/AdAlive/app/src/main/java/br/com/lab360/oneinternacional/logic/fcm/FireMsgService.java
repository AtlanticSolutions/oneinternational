package br.com.lab360.oneinternacional.logic.fcm;

import android.content.Intent;
import androidx.annotation.StringDef;
import android.util.Log;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import net.jokubasdargis.rxbus.Bus;
import net.jokubasdargis.rxbus.RxBus;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.FcmMessageReceivedEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.InteractiveNotification;
import br.com.lab360.oneinternacional.logic.rxbus.events.SectorMessageReceivedEvent;

/**
 * Created by Victor Santiago on 25/11/2016.
 */
public class FireMsgService extends FirebaseMessagingService {

    private static Bus fcmBus = RxBus.create();
    private static final String TAG = "FireMsgService";

    public static Bus getBusInstance() {
        return fcmBus;
    }


    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        super.onMessageReceived(remoteMessage);

        AdaliveApplication.getInstance().setAddNotificationValue(1);

        if (remoteMessage.getData().size() > 0) {
            if (remoteMessage.getData().containsKey("click_action")) {

                Intent intent = new Intent(remoteMessage.getData().get("click_action"));
                intent.putExtra(AdaliveConstants.INTENT_TAG_MESSAGE, remoteMessage.getData().get("message"));
                startActivity(intent);
                return;

            }
            Log.d(TAG, "Message data payload: " + remoteMessage.getData());
            if (remoteMessage.getData().containsKey("type")) {
                switch (remoteMessage.getData().get("type")) {
                    case MessageType.SINGLE_MESSAGE:
                        fcmBus.publish(RxQueues.FCM_MESSAGE_RECEIVED, new FcmMessageReceivedEvent(remoteMessage.getData()));
                        break;
                    case MessageType.SECTOR_MESSAGE:
                        fcmBus.publish(RxQueues.SECTOR_MESSAGE_RECEIVED, new SectorMessageReceivedEvent(remoteMessage.getData()));
                        break;
                    case MessageType.INTERACTIVE:
                        fcmBus.publish(RxQueues.NOTIFICATION_ACTIONS_QUEUE,
                                new InteractiveNotification(remoteMessage.getData()));
                        break;
                }
            }
        }
        
        // Check if message contains a notification payload.
        if (remoteMessage.getNotification() != null) {
            Log.d(TAG, "Message Notification Body: " + remoteMessage.getNotification().getBody());
        }
    }

    @StringDef({MessageType.SINGLE_MESSAGE, MessageType.SECTOR_MESSAGE, MessageType.INTERACTIVE})
    private @interface MessageType {
        String SINGLE_MESSAGE = "SINGLE_MESSAGE";
        String SECTOR_MESSAGE = "SECTOR_MESSAGE";
        String INTERACTIVE = "INTERACTIVE";
    }
}