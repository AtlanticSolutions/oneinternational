package br.com.lab360.bioprime.ui.activity.product;

import android.app.Activity;
import android.os.Handler;
import androidx.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.google.gson.JsonObject;

import br.com.lab360.bioprime.logic.model.pojo.product.Banner;
import br.com.lab360.bioprime.logic.rest.ApiManager;


/**
 * Banner component. Has default app image banner and make calls to the server to get new image banner.
 * Created by Victor on 16/02/2016.
 */
public class BannerComponent implements View.OnClickListener {

    private Activity activity;
    private int visibility;
    private String url;
    private ImageView ivBanner;
    private Banner mBanner;
    private Handler mHandler;
    private Runnable mRunnable;

    public BannerComponent(Activity activity, ImageView ivBanner) {

        this.activity = activity;
        this.ivBanner = ivBanner;
        this.visibility = View.VISIBLE;

        url = ApiManager.getInstance().getUrlAdaliveApi(activity);

        configDefaultBanner();

        configBanner();
    }

    /**
     * Config default banner image and href.
     */
    private void configDefaultBanner() {

        mBanner = null;

        if (mHandler != null && mRunnable != null) {

            mHandler.removeCallbacks(mRunnable);

        }


//        PicassoCache.getPicassoInstance(activity).load(br.com.lab360.adalive.R.drawable.default_banner)
//                .error(br.com.lab360.adalive.R.drawable.default_banner)
//                .into(ivBanner);

        ivBanner.setOnClickListener(this);

    }

    /**
     * Config banner.
     * Create a default image banner and verify if has banner in the server.
     */
    private void configBanner() {

//        if (visibility == View.VISIBLE) {
//
//            JsonObject jsonObject = getJsonObjectLog();
//
//            AdAliveService service = MethodsAdAliveManager.getMethodGetService();
//
//            service.getBanner(jsonObject, new Callback<JsonObject>() {
//                @Override
//                public void success(JsonObject jsonObject, Response response) {
//
//                    if (jsonObject != null) {
//
//                        Gson gson = new Gson();
//                        JsonObject jObject = jsonObject.getAsJsonObject(ConstantsAdAlive.BANNER);
//                        mBanner = gson.fromJson(jObject, Banner.class);
//
//                        if (mBanner != null) {
//
//                            if (mBanner.getHref() != null && mBanner.getImageURL() != null) {
//
//                                if (!mBanner.getHref().equals("") && !mBanner.getImageURL().equals("")) {
//
//                                    url = mBanner.getHref();
//
//                                    //TODO - não utilizado no momento.
//                                    //configBannerTimer();
//
//                                    int bannerWidth = (int) activity.getResources().getDimension(br.com.lab360.adalive.R.dimen.banner_width);
//                                    int bannerHeight = (int) activity.getResources().getDimension(br.com.lab360.adalive.R.dimen.banner_height);
//
//
//                                    PicassoCache.getPicassoInstance(activity).load(mBanner.getImageURL())
//                                            .resize(bannerWidth, bannerHeight)
//                                            .error(br.com.lab360.adalive.R.drawable.default_banner)
//                                            .into(ivBanner);
//
//                                } else {
//
//                                    configDefaultBanner();
//
//                                }
//
//                            } else {
//
//                                configDefaultBanner();
//
//                            }
//
//                        } else {
//
//                            Errors errors = gson.fromJson(jsonObject, Errors.class);
//
//                            if (errors.getListError().size() > 0) {
//                                MethodsAdAliveManager.showSuccessJsonAPIError(activity, errors, false);
//                            }
//
//                            configDefaultBanner();
//
//                        }
//
//                    } else {
//
//                        configDefaultBanner();
//
//                    }
//
//                }
//
//                @Override
//                public void failure(RetrofitError error) {
//
//                    if (error.getMessage() != null && !error.getMessage().equals("")) {
//                        MethodsAdAliveManager.jsonAPIError(activity, error, false);
//                    }
//
//                    configDefaultBanner();
//
//                }
//            });
//
//        }

    }

    /**
     * Return configured json object log.
     *
     * @return json object log
     */
    @NonNull
    private JsonObject getJsonObjectLog() {

//        GPSTracker gpsTracker = new GPSTracker(activity);
//        SharedPreferences prefs = activity.getSharedPreferences(BuildConfig.SHARED_PREFS, Context.MODE_PRIVATE);
//
//        String email = prefs.getString(ConstantsAdAlive.PREFS_TAG_EMAIL, "");
//
//        double latitude = gpsTracker.getLatitude();
//        double longitude = gpsTracker.getLongitude();
//        String deviceId = DeviceHelper.getDeviceId(activity);
//        String mobileId = prefs.getString(ConstantsAdAlive.PREFS_MOBILE_ID, "");
//
//        JsonObject jsonObject = new JsonObject();
//        JsonObject jsonInternalData = new JsonObject();
//
//        jsonInternalData.addProperty(ConstantsAdAlive.TAG_LOG_DEVICE_ID_VENDOR, deviceId);
//        jsonInternalData.addProperty(ConstantsAdAlive.TAG_LOG_LATITUDE, latitude);
//        jsonInternalData.addProperty(ConstantsAdAlive.TAG_LOG_LONGITUDE, longitude);
//        jsonInternalData.addProperty(ConstantsAdAlive.PREFS_MOBILE_ID, mobileId);
//
//        jsonObject.add(ConstantsAdAlive.TAG_LOG_BANNER_LOG, jsonInternalData);
//        jsonObject.addProperty(ConstantsAdAlive.PREFS_TAG_EMAIL, email);
//        jsonObject.addProperty(ConstantsAdAlive.TAG_APP_ID, BuildConfig.APP_ID);
//
//        return jsonObject;

        return null;

    }

    /**
     * Config the timer for the new image call to server.
     */
    private void configBannerTimer() {

        configBanner();

        mHandler = new Handler();
        mRunnable = new Runnable() {

            @Override
            public void run() {
                long timer = mBanner.getTimer() * 1000;

                mHandler.postDelayed(this, timer);

            }
        };
    }

    /**
     * Control component visibility.
     *
     * @param visibility if visible, invisible or gone.
     */
    public void setVisibility(int visibility) {

        this.visibility = visibility;
        ivBanner.setVisibility(visibility);

    }

    /**
     * Adjust hide banner in the product screen.
     *
     * @param flPortrait FrameLayout.
     * @param params     ViewGroup.MarginLayoutParams.
     * @param llBanner   layout banner.
     */
    public void hideBannerProductScreen(FrameLayout flPortrait, ViewGroup.MarginLayoutParams params, LinearLayout llBanner) {

        params.setMargins(0, 0, 0, 0);
        flPortrait.setVisibility(View.GONE);
        llBanner.setVisibility(View.GONE);
        setVisibility(View.GONE);

        flPortrait.setLayoutParams(params);
        flPortrait.requestLayout();
        llBanner.requestLayout();

    }


    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {

//        switch (v.getId()) {
//
//            case br.com.lab360.adalive.R.id.ivBanner:
//
//                if (mBanner != null) {
//
//                    LogManager logManager = new LogManager(activity);
//                    logManager.callBannerClickLog(mBanner.getId(), mBanner.getHref());
//
//                }
//
//                if (!url.startsWith("http://") && !url.startsWith("https://")) {
//                    url = "http://" + url;
//                }
//
//                UtilsAdAlive.openBrowserURL(activity, Uri.parse(url));
//
//                break;
//
//        }

    }

    /**
     * Return Handler.
     *
     * @return {@link Handler}
     */
    public Handler getHandler() {

        return mHandler;

    }

    /**
     * Return Runnable.
     *
     * @return {@link Runnable}
     */
    public Runnable getRunnable() {

        return mRunnable;

    }

}
