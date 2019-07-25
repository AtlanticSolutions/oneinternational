package br.com.lab360.oneinternacional.application;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.RemoteException;
import androidx.multidex.MultiDexApplication;
import androidx.core.app.NotificationCompat;
import android.util.Log;

import com.crashlytics.android.Crashlytics;
import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.sjl.foreground.Foreground;
import com.studioidan.httpagent.U;

import net.jokubasdargis.rxbus.Bus;
import net.jokubasdargis.rxbus.RxBus;

import org.altbeacon.beacon.Beacon;
import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.Identifier;
import org.altbeacon.beacon.RangeNotifier;
import org.altbeacon.beacon.Region;
import org.altbeacon.beacon.powersave.BackgroundPowerSaver;
import org.altbeacon.beacon.startup.BootstrapNotifier;
import org.altbeacon.beacon.startup.RegionBootstrap;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.fcm.ButtonReceiver;
import br.com.lab360.oneinternacional.logic.fcm.FireMsgService;
import br.com.lab360.oneinternacional.logic.fcm.InteractiveNotificationWsService;
import br.com.lab360.oneinternacional.logic.interactor.BeaconInteractor;
import br.com.lab360.oneinternacional.logic.model.BeaconModel;
import br.com.lab360.oneinternacional.logic.model.BeaconResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.CodeParam;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.product.ProductLocal;
import br.com.lab360.oneinternacional.logic.model.v2.realm.MA_Order;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.BadgeMessageUpdateEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.FcmMessageReceivedEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.ProfileChanged;
import br.com.lab360.oneinternacional.logic.rxbus.events.InteractiveNotification;
import br.com.lab360.oneinternacional.ui.activity.SplashScreenActivity;
import br.com.lab360.oneinternacional.ui.activity.chat.ChatActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.TimelineActivity;
import br.com.lab360.oneinternacional.utils.EnumPreferencesCategory;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import io.fabric.sdk.android.Fabric;
import io.realm.Realm;
import io.realm.RealmConfiguration;
import io.realm.RealmResults;
import lib.utils.ConstantsAdAlive;
import rx.Observer;
import rx.Subscription;
import uk.co.chrisjenx.calligraphy.CalligraphyConfig;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */
public class AdaliveApplication extends MultiDexApplication implements BootstrapNotifier, BeaconConsumer,  BeaconInteractor.BeaconMessageInteractorListener{
    private static AdaliveApplication ourInstance;
    private static Bus bus;
    private boolean onlyRegistered;
    private static SharedPrefsHelper sharedPrefsHelper;

    private BroadcastReceiver downloadCompletedReceiver;
    private Map<Long, Integer> pendingDownloads;

    private User user;
    private CodeParam codparametro;
    private String fcmToken;
    private Subscription messageSubscription;
    private Subscription sectorMessageSubscription;
    private Subscription notificationActionsSubscription;
    private boolean chatActive;
    private boolean isResultSignup;
    private ProductLocal product;
    private int totalNotifications = 0;

    public static ArrayList<MA_Order> listaPedido;

    //Beacons
    private static BootstrapNotifier bootstrapNotifier;
    private static BeaconConsumer consumer;
    private static RegionBootstrap regionBootstrap;
    private static BackgroundPowerSaver backgroundPowerSaver;
    private static BeaconManager beaconManager;
    private static List<Region> regionList;
    private static List<Beacon> beaconArrayList;
    private static BeaconResponse beaconsResponse;
    private static Gson gson;
    private static int i;


    public static AdaliveApplication getInstance() {
        return ourInstance;
    }

    public static Realm getInstanceReal() {
        return Realm.getDefaultInstance();
    }

    public static Bus getBus() {
        return bus;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        bus = RxBus.create();
        initSharedPreferences();
        CalligraphyConfig.initDefault(new CalligraphyConfig.Builder()
                .setDefaultFontPath(AdaliveConstants.FONT_MYRIAN_REGULAR)
                .setFontAttrId(R.attr.fontPath)
                .build());

//        JodaTimeAndroid.init(this);

        createMessagesSubscription();
        createNotificationActionsSubscription();

        codparametro = new CodeParam();
        codparametro.setMasterEventId(UserUtils.getMasterEventId(this));

        ourInstance = this;

        /*initialBeaconValues();
        startMonitoringBeacons();
*/
        Fabric.with(this, new Crashlytics());

        //Conforme Watanabe Diniz nao tem geofense
        if (AdaliveConstants.APP_ID != 2) {
            Foreground.init(this);
        }


        Realm.init(this);

        RealmConfiguration config = new RealmConfiguration.Builder()
                .name("maisamigas.realm")
                .deleteRealmIfMigrationNeeded()
                .schemaVersion(10)
                .build();


        Realm.setDefaultConfiguration(config);


        listaPedido = new ArrayList<>();

        androidx.appcompat.app.AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);

        //initialBeaconValues();
        //BeaconInteractor interactor = new BeaconInteractor();
        //interactor.getBeaconsMessageList(Integer.parseInt(BuildConfig.APP_ID), this);



    }

    @Override
    public void onTerminate() {
        unregisterReceiver(downloadCompletedReceiver);
        downloadCompletedReceiver = null;
        if (!messageSubscription.isUnsubscribed()) {
            messageSubscription.unsubscribe();
        }
        if (!sectorMessageSubscription.isUnsubscribed()) {
            sectorMessageSubscription.unsubscribe();
        }
        super.onTerminate();
    }

    //region Public Methods
    public void enqueueDownloadId(long downloadId, int listIndex) {
        if (pendingDownloads == null) {
            pendingDownloads = new LinkedHashMap<>();
        }
        pendingDownloads.put(downloadId, listIndex);
    }
    //endregion

    private void createMessagesSubscription() {
        messageSubscription = FireMsgService.getBusInstance().subscribe(RxQueues.FCM_MESSAGE_RECEIVED, new Observer<FcmMessageReceivedEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(FcmMessageReceivedEvent fcmMessageReceivedEvent) {

                Log.v(AdaliveConstants.ERROR, "**** messageSubscription ****");

                if (fcmMessageReceivedEvent.getChatMessage() != null && !chatActive) {

//                    Intent intent = new Intent(AdaliveApplication.this, SplashScreenActivity.class);
                    Intent intent = new Intent(AdaliveApplication.this, ChatActivity.class);

                    intent.putExtra(AdaliveConstants.INTENT_TAG_MESSAGE, new Gson().toJson(fcmMessageReceivedEvent.getChatMessage()));
                    PendingIntent pIntent = PendingIntent.getActivity(AdaliveApplication.this, (int) System.currentTimeMillis(), intent, 0);
                    StringBuilder builder = new StringBuilder();

                    String senderName = fcmMessageReceivedEvent.getChatMessage().getSenderName();
                    String chatMessage = fcmMessageReceivedEvent.getChatMessage().getMessage();

                    String contentTitle = fcmMessageReceivedEvent.getChatMessage().getGroupName();
                    if (Strings.isNullOrEmpty(contentTitle)) {
                        contentTitle = getString(R.string.app_name);
                    }

                    builder.append(senderName)
                            .append(": ")
                            .append(chatMessage);

                    Notification notification = new Notification.Builder(AdaliveApplication.this)
                            .setContentTitle(contentTitle)
                            .setContentText(builder.toString())
                            .setContentIntent(pIntent)
                            .setAutoCancel(true)
                            .setSmallIcon(R.drawable.ic_notification).build();

                    NotificationManager notificationManager =
                            (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
                    notificationManager.notify(0, notification);


                    AdaliveApplication.getBus().publish(RxQueues.BADGE_UPDATE_EVENT, new BadgeMessageUpdateEvent(1));
                }
            }
        });
    }

    private void createNotificationActionsSubscription() {
        notificationActionsSubscription = FireMsgService.getBusInstance().subscribe(RxQueues.NOTIFICATION_ACTIONS_QUEUE, new Observer<InteractiveNotification>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(InteractiveNotification interactiveNotification) {

                if (interactiveNotification.getMessage() != null) {

                    Notification notification;

                    Log.v(AdaliveConstants.ERROR, "**** createNotificationActionsSubscription ****");

                    //Main Notification
                    Intent intent = new Intent(AdaliveApplication.this, SplashScreenActivity.class);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK
                            | Intent.FLAG_ACTIVITY_NO_ANIMATION);
                    PendingIntent pIntent = PendingIntent.getActivity(AdaliveApplication.this,
                            (int) System.currentTimeMillis(), intent, 0);

                    //Intents
                    Intent positiveIntent = new Intent(AdaliveApplication.this, InteractiveNotificationWsService.class);
                    positiveIntent.putExtra("notificationId", 0);
                    positiveIntent.putExtra(AdaliveConstants.NOTIFICATION_ID, interactiveNotification.getNotificationId());
                    PendingIntent positivePendingIntent = PendingIntent.getService(AdaliveApplication.this,
                            (int) System.currentTimeMillis(), positiveIntent, PendingIntent.FLAG_CANCEL_CURRENT);

                    Intent negativeIntent = new Intent(AdaliveApplication.this, ButtonReceiver.class);
                    negativeIntent.putExtra("notificationId", 0);
                    PendingIntent negativePendingIntent = PendingIntent.getBroadcast(AdaliveApplication.this, 0, negativeIntent,
                            PendingIntent.FLAG_CANCEL_CURRENT);

                    //Actions
                    NotificationCompat.Action cancelAction =
                            new NotificationCompat.Action.Builder(0, getString(R.string.no),
                                    negativePendingIntent).build();
                    NotificationCompat.Action okAction =
                            new NotificationCompat.Action.Builder(0, getString(R.string.yes),
                                    positivePendingIntent).build();

                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT_WATCH) {

                        notification = new NotificationCompat.Builder(AdaliveApplication.this)
                                .setContentTitle(interactiveNotification.getTitle())
                                .setContentText(interactiveNotification.getMessage())
                                .setAutoCancel(true)
                                .setSmallIcon(R.drawable.ic_notification)
                                .setContentIntent(pIntent)
                                .addAction(cancelAction)
                                .addAction(okAction)
                                .build();

                    } else {

                        notification = new Notification.Builder(AdaliveApplication.this)
                                .setContentTitle(interactiveNotification.getTitle())
                                .setContentText(interactiveNotification.getMessage())
                                .setAutoCancel(true)
                                .setSmallIcon(R.drawable.ic_notification)
                                .setContentIntent(pIntent)
                                .addAction(0, getString(R.string.no), negativePendingIntent)
                                .addAction(0, getString(R.string.yes), positivePendingIntent)
                                .build();
                    }

                    NotificationManager notificationManager =
                            (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

                    notificationManager.notify(0, notification);

                }

            }
        });

    }

    public void setChatActive(boolean chatActive) {
        this.chatActive = chatActive;
    }


    /*
    private RoleProfileObject getConfigurationsByRole(){
        RoleProfileObject roleProfileObject = new RoleProfileObject();
        roleProfileObject.setHeadImage(UserUtils.getCachedBannerUrl(this));
        roleProfileObject.setTextColor(UserUtils.getColorText(this));
        roleProfileObject.setBackgroundColor(UserUtils.getBackgroundColor(this));
        roleProfileObject.setMasterEventID(UserUtils.getMasterEventId(this));
        roleProfileObject.setRole(UserUtils.getRoleProfile(this));
        roleProfileObject.setButtonFirstColor(UserUtils.getButtonColor(this));
        roleProfileObject.setCanCreatePost(UserUtils.getCanCreatePost(this));
        roleProfileObject.setCanLike(UserUtils.getCanLikePost(this));
        roleProfileObject.setCanShare(UserUtils.getCanSharePost(this));
        roleProfileObject.setCanComment(UserUtils.getCanCommentPost(this));
        return roleProfileObject;
    }

    */

    public void setUser(User response) {
        this.user = response;
        bus.publish(RxQueues.USER_PROFILE_CHANGED_QUEUE, new ProfileChanged(this.user));
    }

    public User getUser() {
        return UserUtils.loadUser(this);
    }

    public BroadcastReceiver getDownloadListener() {
        return downloadCompletedReceiver;
    }

    public String getFcmToken() {
        return fcmToken;
    }

    public void setFcmToken(String fcmToken) {
        this.fcmToken = fcmToken;
    }

    public void setShowOnlyRegisteredEvents(boolean onlyRegistered) {
        this.onlyRegistered = onlyRegistered;
    }

    public boolean shouldShowOnlyRegisteredEvents() {
        return onlyRegistered;
    }

    public boolean isResultSignup() {
        return isResultSignup;
    }

    public void setResultSignup(boolean resultSignup) {
        isResultSignup = resultSignup;
    }

    public CodeParam getCodeParams() {
        return codparametro;
    }

    public void setCodparametro(CodeParam codparametro) {
        this.codparametro = codparametro;
        UserUtils.saveMasterEventId(this, codparametro.getMasterEventId());
    }

    //endregion

    public void setProduct(ProductLocal product) {
        this.product = product;
    }

    public ProductLocal getProduct() {
        return product;
    }

    public void setAddNotificationValue(int totalNotifications) {
        this.totalNotifications = this.totalNotifications + totalNotifications;
    }

    public void setClearNotificationValue() {
        this.totalNotifications = 0;
    }

    public int getTotalNotifications() {
        return totalNotifications;
    }

    private void initSharedPreferences(){
        sharedPrefsHelper = new SharedPrefsHelper(getSharedPreferences(EnumPreferencesCategory.LOGIN_CATEGORY.getCategoryType(), MODE_PRIVATE));

    }

    public SharedPrefsHelper getSharedPrefsHelper(){
        return sharedPrefsHelper;
    }

    public void initialBeaconValues(){
        i = 0;
        consumer = this;
        bootstrapNotifier = this;



        beaconArrayList = new ArrayList<>();
        beaconsResponse = new BeaconResponse();
        regionList = new ArrayList<>();
        gson = new Gson();

        if(!sharedPrefsHelper.get("BEACONS_LIST", "").equals("")){
            beaconsResponse.setBeacons(Arrays.asList(gson.fromJson(sharedPrefsHelper.get("BEACONS_LIST", ""), BeaconModel[].class)));
        }else{
            beaconsResponse.setBeacons(new ArrayList<BeaconModel>());
        }
    }

    public static void startMonitoringBeacons(){


        for (BeaconModel savedBeacon : beaconsResponse.getBeacons()) {

            try {
                Region region = new Region(savedBeacon.getId() + "",
                        Identifier.parse(savedBeacon.getProximityUuid()),
                        Identifier.parse(savedBeacon.getMajor()),
                        Identifier.parse(savedBeacon.getMinor()));
                regionBootstrap = new RegionBootstrap(bootstrapNotifier, region); //work to background app
                regionList.add(region);

            } catch (Exception e) {

                Log.e(ConstantsAdAlive.ERROR, "onCreate parse beacon error");

            }
        }
        beaconManager = BeaconManager.getInstanceForApplication(AdaliveApplication.getInstance().getApplicationContext());
        beaconManager.getBeaconParsers().clear();
        beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout(AdaliveConstants.IBEACON_LAYOUT));

        beaconManager.bind(consumer);
        beaconManager.setForegroundScanPeriod(1000L);
        beaconManager.setBackgroundBetweenScanPeriod(1000L);
        backgroundPowerSaver = new BackgroundPowerSaver(AdaliveApplication.getInstance().getApplicationContext());
    }

    @Override
    public void onBeaconServiceConnect() {
        beaconManager.addRangeNotifier(new RangeNotifier() {
            @Override
            public void didRangeBeaconsInRegion(Collection<Beacon> beacons, Region region) {
                //Log.i("BEACONS FOUND", ""+beacons);
                for(Beacon b : beacons){
                    if (region != null && b.getDistance() < 1.5) {

                        BeaconModel connectedBeacon = getBeacon(region.getId1().toString(),
                                region.getId2().toString(),
                                region.getId3().toString());

                        Log.i("BEACON DISTANCE", ""+b.getDistance() + " | msg = " + connectedBeacon.getEntryMessage());

                        Realm realm = Realm.getDefaultInstance();
                        RealmResults<BeaconModel> beaconsRealm = realm.where(BeaconModel.class).equalTo("major",connectedBeacon.getMajor()).findAll();

                        if (beaconsRealm.size() == 0) {

                            sendNotificationBeacon(getString(R.string.app_name), connectedBeacon.getEntryMessage(), connectedBeacon);
                        }

                        realm.close();
//
                    }
                }
            }
        });


        for (Region region : regionList) {
            try {

                beaconManager.startRangingBeaconsInRegion(region);

            } catch (RemoteException e) {
                Log.e(ConstantsAdAlive.ERROR, e.toString());
            }
        }
    }

    @Override
    public void didEnterRegion(Region region) {
        //Toast.makeText(this, "ENTER REGION", Toast.LENGTH_LONG).show();

    }

    @Override
    public void didExitRegion(Region region) {
        //Toast.makeText(this, "EXIT REGION", Toast.LENGTH_LONG).show();
        /*if (region != null) {

            BeaconModel connectedBeacon = getBeacon(region.getId1().toString(),
                    region.getId2().toString(),
                    region.getId3().toString());

            Realm realm = Realm.getDefaultInstance();
            RealmResults<BeaconModel> beacons = realm.where(BeaconModel.class).equalTo("major",connectedBeacon.getMajor()).findAll();


//            if (connectedBeacon != null && !TextUtils.isEmpty(connectedBeacon.getLeaveMessage()) && beacons.size() == 0) {
            if (beacons.size() == 0) {

                //updateReceivedMessageBeacon(connectedBeacon, "LEAVE");
                sendNotificationBeacon(getString(R.string.app_name), connectedBeacon.getLeaveMessage(), connectedBeacon);
            }
            realm.close();
        }*/
    }

    private BeaconModel getBeacon(String uuid, String major, String minor) {
        for (BeaconModel beacon : beaconsResponse.getBeacons()) {

            if (beacon.getProximityUuid().equalsIgnoreCase(uuid) &&
                    beacon.getMajor().equalsIgnoreCase(major) &&
                    beacon.getMinor().equalsIgnoreCase(minor)) {

                return beacon;
            }
        }

        return null;
    }

    private void sendNotificationBeacon(String title, String message, BeaconModel beaconModel){

        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this, "etna"+beaconModel.getMajor());
        Intent ii = new Intent(AdaliveApplication.this, TimelineActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, ii, 0);

        /*NotificationCompat.BigTextStyle bigText = new NotificationCompat.BigTextStyle();
        bigText.bigText(verseurl);
        bigText.setBigContentTitle("Today's Bible Verse");
        bigText.setSummaryText("Text in detail");*/

        mBuilder.setContentIntent(pendingIntent);
        mBuilder.setSmallIcon(R.mipmap.ic_launcher);
        mBuilder.setContentTitle(title);
        mBuilder.setContentText(message);
        mBuilder.setPriority(Notification.PRIORITY_MAX);
        //mBuilder.setStyle(bigText);

        NotificationManager mNotificationManager =
                (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("etna"+beaconModel.getMajor(),
                    "Channel human readable title",
                    NotificationManager.IMPORTANCE_DEFAULT);
            mNotificationManager.createNotificationChannel(channel);
        }

        mNotificationManager.notify(i++, mBuilder.build());




        /*Intent intent = new Intent(AdaliveApplication.this, HomeActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK
                | Intent.FLAG_ACTIVITY_NO_ANIMATION);
        PendingIntent pIntent = PendingIntent.getActivity(AdaliveApplication.this,
                (int) System.currentTimeMillis(), intent, 0);


        Notification notification = new Notification.Builder(AdaliveApplication.this)
                .setContentTitle(title)
                .setContentText(message)
                .setContentIntent(pIntent)
                .setAutoCancel(true)
                .setSmallIcon(R.drawable.ic_notification).build();


        NotificationManager notificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);

        notificationManager.notify(0, notification);*/

        Realm realm = Realm.getDefaultInstance();
        realm.beginTransaction();
        realm.insert(beaconModel);
        realm.commitTransaction();
        realm.close();

        //Toast.makeText(this, message, Toast.LENGTH_LONG).show();

    }

    private void updateReceivedMessageBeacon(BeaconModel beaconModel, String type) {
        for (BeaconModel beacon : beaconsResponse.getBeacons()) {

            if (beaconModel.getProximityUuid().equalsIgnoreCase(beacon.getProximityUuid()) &&
                    beaconModel.getMajor().equalsIgnoreCase(beacon.getMajor()) &&
                    beaconModel.getMinor().equalsIgnoreCase(beacon.getMinor())) {

                if(type.equals("LEAVE")){
                    beaconModel.setReceivedLeaveMessage(true);
                }
                if(type.equals("ENTRY")){
                    beaconModel.setReceivedEntryMessage(true);
                }
            }
        }

        sharedPrefsHelper.put("BEACONS_LIST", gson.toJson(beaconsResponse.getBeacons()));
    }

    @Override
    public void didDetermineStateForRegion(int i, Region region) {
    }

    @Override
    public void onBeaconListSuccess(BeaconResponse beaconsList) {
        sharedPrefsHelper.put("BEACONS_LIST", gson.toJson(beaconsList.getBeacons()));
        AdaliveApplication.startMonitoringBeacons();
    }

    @Override
    public void onBeaconListFailure() {

    }

}
