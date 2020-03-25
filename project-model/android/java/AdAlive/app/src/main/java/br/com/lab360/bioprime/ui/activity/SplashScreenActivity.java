package br.com.lab360.bioprime.ui.activity;

import android.Manifest;
import android.app.ActivityManager;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.appcompat.app.AlertDialog;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.View;

import com.google.android.gms.location.Geofence;
import com.google.common.base.Strings;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;
import java.util.Observer;

import br.com.lab360.bioprime.BuildConfig;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.geofence.GeolocationService;
import br.com.lab360.bioprime.logic.interactor.LayoutInteractor;
import br.com.lab360.bioprime.logic.interactor.MasterServerInteractor;
import br.com.lab360.bioprime.logic.interactor.MenuInteractor;
import br.com.lab360.bioprime.logic.interactor.TimelineInteractor;
import br.com.lab360.bioprime.logic.interactor.WarningActionsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnBannerLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnLayoutLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnMasterServerDataLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnMenuLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnWarningActionsListener;
import br.com.lab360.bioprime.logic.model.pojo.geofence.GeofenceItem;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Banner;
import br.com.lab360.bioprime.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.bioprime.logic.model.pojo.user.LayoutParam;
import br.com.lab360.bioprime.logic.model.pojo.MasterServerResponse;
import br.com.lab360.bioprime.logic.model.pojo.menu.MenuResponse;
import br.com.lab360.bioprime.logic.model.pojo.roles.RoleProfileObject;
import br.com.lab360.bioprime.logic.model.pojo.warningactions.WarningAction;
import br.com.lab360.bioprime.logic.model.pojo.warningactions.WarningActionsResponse;

import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.ui.activity.login.LoginActivity;
import br.com.lab360.bioprime.utils.NetworkStatsUtil;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;
import br.com.lab360.bioprime.utils.UserUtils;

import br.com.lab360.bioprime.utils.customdialog.CustomDialogBuilder;
import lib.bean.geofence.Region;
import lib.bean.geofence.RegionsResponse;
import lib.error.NullUrlServerException;
import lib.ui.AdAliveGeofence;
import lib.ui.GeofenceMessageCallback;
import lib.utils.ConstantsAdAlive;
import me.anshulagarwal.simplifypermissions.Permission;

/**
 * Refactored by David Canon
 */
public class SplashScreenActivity extends BaseActivity implements
        OnMasterServerDataLoadedListener, OnLayoutLoadedListener, OnWarningActionsListener, OnMenuLoadedListener, Observer, OnBannerLoadedListener {

    //region Vars
    private static final String[] ACTIVITY_PERMISSIONS = {
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.ACCESS_COARSE_LOCATION,
    };
    public static final String MENU_OBJECTS = "MENU_OBJECTS";
    private static final int PERMISSION_REQUEST_READ_PHONE_STATE = 0x33;
    private static final int PERMISSION_REQUEST_COARSE_LOCATION = 0X34;
    private static final int PERMISSION_REQUEST_ACCESS_FINE_LOCATION = 0x35;


    private static final long GEOFENCE_EXPIRATION_IN_HOURS = 12;
    public static final long GEOFENCE_EXPIRATION_IN_MILLISECONDS = GEOFENCE_EXPIRATION_IN_HOURS * DateUtils.HOUR_IN_MILLIS;
    public static int COUNT_GEOFENCE = 20000;

    protected AdAliveGeofence adAliveGeofence;
    private boolean hasWarning = false;
    private SharedPrefsHelper sharedPrefsHelper;
    private WarningAction warningAction;
    //endregion

    //region LifeCycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume() {
        super.onResume();
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        checkPermissions();
    }
    //endregion


    //region MasterServer response
    @Override
    public void onMasterServerDataLoadError() {
        attemptRetrieveConfig();
    }

    @Override
    public void onMasterServerDataLoadSuccess(MasterServerResponse params) {
        ApiManager.getInstance().setAdaliveApi(params.getUrlAdalive(), this);
        ApiManager.getInstance().setAdaliveChatApi(params.getUrlChat(), this);
        ApiManager.getInstance().setAmazonApi(AdaliveConstants.AMAZON_URL, this);

        //Getting layout Params
        LayoutInteractor layoutInteractor = new LayoutInteractor(this);
        layoutInteractor.getLayoutParams(AdaliveConstants.APP_ID, this);

        if(ApiManager.getInstance().getAdaliveApiInstance(this) != null){
            new WarningActionsInteractor(this).retrieveAllWarningApp(BuildConfig.VERSION_NAME.split("-")[0],BuildConfig.APP_ID, this);
            retrieveMenu();
            retrieveBanner();
        }
        //BeaconWS.initAdAliveWS(this);
    }

    //endregion

    //region Layout Response
    @Override
    public void onLayoutLoadError() {
        attemptRetrieveConfig();
    }

    @Override
    public void onLayoutLoadSuccess(LayoutParam params) {
        hideProgress();
        //attemptCallAdAliveGeofence(this);
        //Save layout configurations
        UserUtils.setLayoutParam(params, this);
        String roleProfile = UserUtils.getRoleProfile(SplashScreenActivity.this);

        // Check for the user role
        if (!Strings.isNullOrEmpty(roleProfile)) {
            //Busca os dados do role
            for (RoleProfileObject item : UserUtils.getLayoutParam(this).getRoles()) {
                if (item.getRole().equals(roleProfile)) {

                    UserUtils.setConfigurationsByRole(item, this);
                    break;
                }
            }
        }

        /* Set master event on start application */
        else {
            UserUtils.saveMasterEventId(this, params.getMasterEventId());
        }

    }


    //endregion


    //region Utils
    private void attemptRetrieveConfig() {
        if (!NetworkStatsUtil.isConnected(this)) {

            new AlertDialog.Builder(this)
                    .setTitle(getString(R.string.DIALOG_INTERNET_TITLE))
                    .setMessage(getString(R.string.DIALOG_INTERNET_MESSAGE))
                    .setCancelable(false)
                    .setPositiveButton(android.R.string.ok, new Dialog.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            cldRetrieveServeConf();

                        }
                    })
                    .setNegativeButton(android.R.string.cancel, new Dialog.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            cldRetrieveServeConf();
                            finish();

                        }
                    })
                    .create()
                    .show();
        }else {
            cldRetrieveServeConf();
        }
    }

    private boolean isGeofenceServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

    private void attemptCallAdAliveGeofence(final Context context) {
        if(!isGeofenceServiceRunning(GeolocationService.class)){
            if (AdaliveApplication.getInstance().getUser() != null && !Strings.isNullOrEmpty(AdaliveApplication.getInstance().getUser().getEmail())) {
                try {
                    adAliveGeofence = new AdAliveGeofence(context, ApiManager.getInstance().getUrlAdaliveApi(this), AdaliveApplication.getInstance().getUser().getEmail());
                    adAliveGeofence.callGetRegions(AdaliveConstants.APP_ID);
                    observe(adAliveGeofence);
                    observe(GeofenceMessageCallback.getInstance());
                } catch (NullUrlServerException e) {
                    e.printStackTrace();
                }
            }
        }else {
            stopService(new Intent(SplashScreenActivity.this, GeolocationService.class));
        }
    }

    /**
     * Add {@code Observable} object.
     *
     * @param o {@code Observable} object to add.
     */

    public void observe(java.util.Observable o) {
        o.addObserver(this);
    }

    @Override
    public void update(java.util.Observable observable, Object o) {
        if (observable instanceof GeofenceMessageCallback) {

        } else if (observable instanceof AdAliveGeofence) {
            RegionsResponse regionsResponse = ((AdAliveGeofence) observable).getRegions();
            if (regionsResponse != null && regionsResponse.getRegions() != null) {

                Gson gson = new Gson();
                List<GeofenceItem> items = new ArrayList<>();
                for (Region region : regionsResponse.getRegions()){

                    GeofenceItem item = new GeofenceItem(String.valueOf(region.getId()),
                            Double.parseDouble(region.getLatitude()),
                            Double.parseDouble(region.getLongitude()),
                            Float.parseFloat(region.getRadius()),
                            GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                            Geofence.GEOFENCE_TRANSITION_ENTER
                                    | Geofence.GEOFENCE_TRANSITION_DWELL
                                    | Geofence.GEOFENCE_TRANSITION_EXIT);
                    items.add(item);

                }

                COUNT_GEOFENCE = regionsResponse.getGeofenceTime();
                sharedPrefsHelper.put("GEOFENCE", gson.toJson(items));
                startService(new Intent(this, GeolocationService.class));
            }

            try {

                adAliveGeofence.registerRegions(this, getString(R.string.app_name));

            } catch (Exception ex) {

                Log.e(ConstantsAdAlive.ERROR, "registerRegions: " + ex.toString());

            }

        }
    }

    /**
     * Retrieve the server configuration
     */
    public void cldRetrieveServeConf() {
        //showRunningProgress(this);
        MasterServerInteractor masterServerInteractor = new MasterServerInteractor();
        masterServerInteractor.getMasterServerData(AdaliveConstants.APP_ID, Build.DEVICE,
                "0", "0", "Android", this.getDeviceId(), retrieveBaseOSParameter(),
                Build.MODEL, Build.PRODUCT, this);
    }

    public void retrieveMenu() {
        MenuInteractor menuInteractor = new MenuInteractor(this);
        menuInteractor.getMenu(AdaliveConstants.APP_ID, this);
    }

    public void retrieveBanner() {
        TimelineInteractor interactor = new TimelineInteractor(this);
        interactor.loadBanner(this);
    }
    /**
     * Check permission.
     */
    public void checkPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if (checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {
                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                    }
                };

                Permission.PermissionBuilder permissionBuilder =
                        new Permission.PermissionBuilder(
                                ACTIVITY_PERMISSIONS,
                                PERMISSION_REQUEST_COARSE_LOCATION,
                                mPermissionCallback);

                requestAppPermissions(permissionBuilder.build());
            }


            if (checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {
                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                    }
                };

                Permission.PermissionBuilder permissionBuilder = new Permission.PermissionBuilder(ACTIVITY_PERMISSIONS,
                        PERMISSION_REQUEST_ACCESS_FINE_LOCATION,
                        mPermissionCallback).enableDefaultRationalDialog("PERMISSÃO",
                        "PERMISSÃO");

                requestAppPermissions(permissionBuilder.build());

            }

            if (checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {
                        attemptRetrieveConfig();
                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                    }
                };

                Permission.PermissionBuilder permissionBuilder =
                        new Permission.PermissionBuilder(
                                ACTIVITY_PERMISSIONS,
                                PERMISSION_REQUEST_READ_PHONE_STATE,
                                mPermissionCallback)
                                .enableDefaultRationalDialog(
                                        getString(R.string.DIALOG_TITLE_PERMISSION),
                                        getString(R.string.DIALOG_PHONE_STATE_MESSAGE_PERMISSION)
                                );

                requestAppPermissions(permissionBuilder.build());
            } else {
                attemptRetrieveConfig();
            }

            return;
        }

        attemptRetrieveConfig();
    }

    private void openLoginActivity() {
        Intent i = new Intent(SplashScreenActivity.this, LoginActivity.class);
        i.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(i);
        finish();
    }

    @Override
    public void onWarningActionsLoadSuccess(WarningActionsResponse warningActionsResponse) {

        if (warningActionsResponse.getConfigs().size() == 0 || warningActionsResponse.getConfigs().isEmpty())
        {
            hasWarning = false;
            openLoginActivity();
        }

        for (WarningAction warningAction : warningActionsResponse.getConfigs())
        {
            if (warningAction.isCmdLock() && warningAction.getPlataform().contains("A"))
            {
                onCmdLock(warningAction);
                hasWarning = true;
                return;
            }

            if (warningActionsResponse.getConfigs().isEmpty())
            {
                hasWarning = false;
                openLoginActivity();
            }
        }

        for (WarningAction warningAction : warningActionsResponse.getConfigs())
        {
            if (warningAction.isCmdPersistentWarning() && warningAction.getPlataform().contains("A"))
            {
                onCmdPersistent(warningAction);
                hasWarning = true;
            }

            //TODO OTHER WARNINGS
        }

        if(!hasWarning){
            openLoginActivity();
        }
    }

    @Override
    public void onWarningActionsLoadError(String message) {
        openLoginActivity();
    }

    private void onCmdPersistent(final WarningAction warningAction) {
        this.warningAction = warningAction;

        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ATENTION,
                getString(R.string.TITLE_MESSAGE_UPDATE),
                warningAction.getAppMessage(),
                0
        );

        customDialogButton(
                getString(R.string.BUTTON_UPDATE),
                R.color.white,
                R.drawable.background_button_yellow,
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CANCEL),
                R.color.white,
                R.drawable.gray_button_background,
                onClickDialogButton(R.id.DIALOG_BUTTON_2)
        );

        showCustomDialog();
    }

    private void onCmdLock(final WarningAction warningAction) {
        this.warningAction = warningAction;
        atentionDialog(getString(R.string.TITLE_MESSAGE_UPDATE), warningAction.getAppMessage(),onClickDialogButton(R.id.DIALOG_BUTTON_3));
    }

    private void dismissAndLoadPlayStore(String url) {
        if (!url.contains("http")) {
            url = "http://" + url;
        }

        try {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        } catch (Exception ex) {
            //TODO
        }
    }

    @Override
    public void onMenuLoadError(Throwable e) {

    }

    @Override
    public void onMenuLoadSuccess(MenuResponse response) {
        if(response != null){
            Gson gson = new Gson();
            sharedPrefsHelper.put(MENU_OBJECTS, gson.toJson(response));
        }
    }

    @Override
    public void onBannerLoadError(Throwable e) {

    }

    @Override
    public void onBannerLoadSuccess(BannerResponse response) {
        if(response == null || response.getBanners() == null){
            BannerResponse bannerResponse = new BannerResponse();
            List<Banner> banners = new ArrayList<>();
            bannerResponse.setBanners(banners);
            UserUtils.saveSliderBanner(this, bannerResponse);
        }else{
            UserUtils.saveSliderBanner(this, response);
        }
    }

    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        dismissAndLoadPlayStore(warningAction.getExternalAddr());
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        openLoginActivity();
                        break;
                    case R.id.DIALOG_BUTTON_3:
                        dismissAndLoadPlayStore(warningAction.getExternalAddr());
                        break;
                }
            }
        };
    }
}