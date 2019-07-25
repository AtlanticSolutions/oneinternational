package br.com.lab360.oneinternacional.ui.activity.scanner;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.content.ContextCompat;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.Observable;
import java.util.Observer;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.adalive.Action;
import br.com.lab360.oneinternacional.logic.adalive.ClickButtonARListener;
import br.com.lab360.oneinternacional.logic.model.pojo.user.LayoutParam;
import br.com.lab360.oneinternacional.logic.model.pojo.product.ProductLocal;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import br.com.lab360.oneinternacional.ui.activity.webview.WebviewActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import lib.enumeration.ActionType;
import lib.error.AdAliveCameraAccessException;
import lib.error.IllegalSizeException;
import lib.error.NullActionParamException;
import lib.error.NullTargetNameException;
import lib.error.NullUrlServerException;
import br.com.lab360.oneinternacional.logic.adalive.CameraControl;
import br.com.lab360.oneinternacional.logic.adalive.AdAliveCamera;
import lib.ui.AdAliveWS;
import lib.utils.ConstantsAdAlive;
import me.anshulagarwal.simplifypermissions.MarshmallowSupportActivity;

/**
 * AdAlive Scanner by SDK.
 * Created by Victor Santiago on 25/11/2016.
 */
public class ScannerActivity extends MarshmallowSupportActivity implements Observer, ClickButtonARListener {

    private String urlServer;
    private String userEmail;

    private AdAliveCamera mAdAliveCamera;
    private AdAliveWS mAdAliveWS;
    private CameraControl cameraControl;


    @BindView(R.id.ivCustomFlash)
    ImageView imgCustomFlash;

    @BindView(R.id.topbarScanner)
    RelativeLayout topbarScanner;

    @BindView(R.id.ivCustomCamera)
    ImageView imgCustomCamera;

    @BindView(R.id.ivCustomMenu)
    ImageView ivCustomMenu;

    @BindView(R.id.llContainer)
    LinearLayout llContainer;

    public Context mContext;

    public ClickButtonARListener listener;


    private LinearLayout llButtonsContainer;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_scanner);

        ButterKnife.bind(this);

        mContext = this;
        listener = this;

        urlServer = ApiManager.getInstance().getUrlAdaliveApi(this);
        userEmail = AdaliveApplication.getInstance().getUser().getEmail();

        configStatusBarColor();
        configTopBarColor();
        initAdAliveCamera();
        initAdAliveWS();
        initAdAliveRecognition();
    }



    @OnClick(R.id.ivCustomMenu)
    public void onClickMenu(View v){

        onBackPressed();

    }

    @OnClick(R.id.ivCustomCamera)
    public void onClickCamera(View v){

//        if (mAdAliveCamera != null) {
//            mAdAliveCamera.stopRecognitionService();
//        }
//        cameraControl.switchCamera();


    }

    @OnClick(R.id.ivCustomFlash)
    public void onClickFlash(View v){

        cameraControl.switchFlashlight();

    }

    /**
     * Set color to status bar.
     */
    private void configStatusBarColor() {

        String topColor = UserUtils.getBackgroundColor(ScannerActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);

    }

    private void configTopBarColor() {

        String topColor = UserUtils.getBackgroundColor(ScannerActivity.this);
        topbarScanner.setBackgroundColor(Color.parseColor(topColor));
    }

    /**
     * Init AdAlive Camera.
     */
    public void initAdAliveCamera() {
        try {
            LayoutParam param = UserUtils.getLayoutParam(this);
            if (param == null) {
                throw new Exception(getString(R.string.ERROR_ALERT_MESSAGE_VUFURIA_KEY));
            }
            mAdAliveCamera = new AdAliveCamera(this, R.layout.activity_scanner, R.id.llContainer,
                    param.getVuforiaAccessKey(), param.getVuforiaSecretKey(), param.getVuforiaLicenseKey(),
                    urlServer, userEmail);


            cameraControl = new CameraControl(this, mAdAliveCamera, mAdAliveCamera.getAdAliveAppSession());

        } catch (NullUrlServerException e) {
            Log.e(AdaliveConstants.ERROR, "initAdAliveCamera: " + e.toString());
        } catch (Exception e) {
            Log.e(AdaliveConstants.ERROR, "initAdAliveCamera: " + e.toString());
            finish();
        }
    }

    /**
     * Init AdAlive WS.
     */
    public void initAdAliveWS() {
        try {

            mAdAliveWS = new AdAliveWS(this, urlServer, userEmail);

        } catch (NullUrlServerException e) {

            Log.e(AdaliveConstants.ERROR, "initAdAliveWS: " + e.toString());

        }
    }

    /**
     * After init AdAlive camera and ws init recognition service and start observers.
     */
    private void initAdAliveRecognition() {

        try {
            mAdAliveCamera.startRecognitionService();

            observe(mAdAliveCamera);
            observe(mAdAliveWS);

        } catch (AdAliveCameraAccessException e) {
            Log.e(AdaliveConstants.ERROR, "initAdAliveRecognition: " + e);
        }

    }

    //region Activity life cycle.

    /**
     * Resume operations of the recognition
     */
    @Override
    public void onResume() {

        super.onResume();
        mAdAliveCamera.resumeRecognitionService();

    }

    /**
     * Callback for configuration changes the activity handles itself
     *
     * @param config new configuration activity
     */
    @Override
    public void onConfigurationChanged(Configuration config) {

        super.onConfigurationChanged(config);
        mAdAliveCamera.updateConfigurationService();

    }

    /**
     * Pause operations of the recognition
     */
    @Override
    public void onPause() {
        super.onPause();

        mAdAliveCamera.pauseRecognitionService();

    }

    /**
     * Stop operations of the recognition
     */
    @Override
    public void onDestroy() {

        super.onDestroy();
        if (mAdAliveCamera != null) {
            mAdAliveCamera.stopRecognitionService();
        }

    }



    //endregion

    //region Observer
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////// Observer ////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////

    /**
     * Add {@code Observable} object.
     *
     * @param o {@code Observable} object to add.
     */
    public void observe(Observable o) {

        o.addObserver(this);

    }

    /**
     * This method is called if the specified {@code Observable} object's
     * {@code notifyObservers} method is called (because the {@code Observable}
     * object has been updated.
     * The {@code AdAliveService} is the {@code Observable} object.
     *
     * @param observable the {@link Observable} object, in this case {@code String} code object recognized.
     * @param data       the data passed to {@link Observable#notifyObservers(Object)}.
     */
    @Override
    public void update(Observable observable, Object data) {

        String targetName = null;
        JsonObject jsonResponse;

        if (observable instanceof AdAliveCamera) {

            targetName = ((AdAliveCamera) observable).getTargetName();

        } else if (observable instanceof AdAliveWS) {

            jsonResponse = ((AdAliveWS) observable).getJsonResponse();

            if (jsonResponse != null) {

                if (!jsonResponse.has(ConstantsAdAlive.TAG_ERRORS_SERVER)) {

                    if (jsonResponse.has(ConstantsAdAlive.TAG_ACTION)) {
                        procJsonActionsV2(jsonResponse);
                    } else {
                        procJsonProductV2(jsonResponse);
                    }

                } else {

                    Log.e(AdaliveConstants.ERROR, "update: " + jsonResponse.toString());

                }

            }

        }

        if (targetName != null) {

            Log.i(AdaliveConstants.INFO, "update targetName: " + targetName);

            try {

                mAdAliveWS.callFindProductByTargetName(String.valueOf(AdaliveConstants.APP_ID), targetName);

            } catch (NullTargetNameException e) {

                Log.e(AdaliveConstants.ERROR, "update: " + e);

            }

        }

    }
    //endregion

    //region Endpoint v2
    /*****************************************************************/
    /*****************************************************************/
    /************************      V2    *****************************/
    /*****************************************************************/
    /*****************************************************************/

    /**
     * Sample how mapping and identification products.
     *
     * @param jsonResponse server json response.
     */
    private void procJsonProductV2(JsonObject jsonResponse) {

        Gson gson = new Gson();
        ProductLocal product = gson.fromJson(jsonResponse.get(ConstantsAdAlive.TAG_PRODUCT), ProductLocal.class);

        if (product != null) {

            //Intent it = new Intent(this, ProductActivity.class);

            AdaliveApplication.getInstance().setProduct(product);
            //startActivity(it);

            Action mAction = product.getActions().get(0);
            mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), mAction.getId());
        }
    }

    /**
     * Sample how mapping and identification actions.
     *
     * @param jsonResponse server json response.
     */
    private void procJsonActionsV2(JsonObject jsonResponse) {
        Gson gson = new Gson();
        Action action = gson.fromJson(jsonResponse.get(ConstantsAdAlive.TAG_ACTION), Action.class);

        if (action != null) {
            if (action.getActionType() == ActionType.VIDEO_ACTION.getActionType()) {
                playVideoActionV2(action);
            } else if (action.getActionType() == ActionType.INFO_ACTION.getActionType()) {
                openUrl(action.getHref());
            } else if (action.getActionType() == ActionType.LINK_ACTION.getActionType()) {
                openUrl(action.getHref());
            } else if (action.getActionType() == ActionType.VIDEO_AR_TRANSP_ACTION.getActionType()){
                playVideoAr(action);
            } else if (action.getActionType() == ActionType.VIDEO_AR_ACTION.getActionType()){
                playVideoAr(action);
            }
        }
    }

    /**
     * Open URL in custom Tabs
     */
    private void openUrl(String href) {
        Uri uri = Uri.parse(href);
        CustomTabsIntent.Builder customTabsIntentBuilder = new CustomTabsIntent.Builder(null);
        CustomTabsIntent customTabsIntent = customTabsIntentBuilder.build();
        customTabsIntentBuilder.setToolbarColor(ContextCompat.getColor(this, R.color.blueEditText));
        customTabsIntent.launchUrl(this, uri);
    }

    /**
     * Sample v2 how start/ play video action.
     *
     * @param action action to play video.
     */
    private void playVideoActionV2(Action action) {
        String videoUrl = action.getHref() == null ? "" : action.getHref();

        try {
            mAdAliveCamera.playVideoAction(videoUrl, ScannerActivity.this, null, true);
        } catch (NullActionParamException e) {
            Log.e(AdaliveConstants.ERROR, "playVideoActionV2: " + e.toString());
        }
    }

    private void playVideoAr(Action action) {
        boolean transp = false;
        if (action.getActionType() == ActionType.VIDEO_AR_TRANSP_ACTION.getActionType()){
            transp = true;
        } else if (action.getActionType() == ActionType.VIDEO_AR_ACTION.getActionType()){
            transp = false;
        }

        try {
            mAdAliveCamera.playVideoAR(action.getActionType(), action.getHref(), transp, action.getMetadata().getButtons(), listener);
            //mAdAliveCamera.playVideoAR(action.getActionType(), "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", false, null);
        } catch (NullActionParamException e) {
            Log.e(AdaliveConstants.ERROR, "playVideoActionV2: " + e.toString());
        } catch (IllegalSizeException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onClickButtonARListener(String url) {
        Intent intent = new Intent(mContext, WebviewActivity.class);
        intent.putExtra(AdaliveConstants.TAG_ACTION_URL, url);
        startActivity(intent);
    }
    //endregion
}