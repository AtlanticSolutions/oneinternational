package br.com.lab360.oneinternacional.ui.activity;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.google.android.material.snackbar.Snackbar;
import androidx.core.content.ContextCompat;
import androidx.appcompat.widget.Toolbar;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.common.base.Strings;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.ui.view.IBaseView;
import br.com.lab360.oneinternacional.utils.DateUtils;
import br.com.lab360.oneinternacional.utils.EnumLoginTypeCategory;
import br.com.lab360.oneinternacional.utils.NetworkStatsUtil;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import br.com.lab360.oneinternacional.utils.customdialog.ButtonBuilder;
import br.com.lab360.oneinternacional.utils.customdialog.CustomDialogBuilder;
import br.com.lab360.oneinternacional.utils.customdialog.CustomDialog;
import me.anshulagarwal.simplifypermissions.MarshmallowSupportActivity;
import rx.android.schedulers.AndroidSchedulers;
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 * Update by : Paulo Age --/10/2017
 */
public class BaseActivity extends MarshmallowSupportActivity implements Thread.UncaughtExceptionHandler, IBaseView {
    /* An aux string to debug */
    private ProgressBar progressDialog;
    private Snackbar fixedSnackbar;
    public static final String FULL_TOKEN = "Token token=";
    private static final String kUPDATE_TIME_FORMAT = "MM/dd/yyyy HH:mm:ss";

    CustomDialog customDialog;
    CustomDialogBuilder customDialogBuilder;
    ButtonBuilder buttonBuilder;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            String color = UserUtils.getBackgroundColor(this);
            if (!Strings.isNullOrEmpty(color)) {
                try {
                    ActivityManager.TaskDescription tDesc =
                            new ActivityManager.TaskDescription(null,
                                    null,
                                    Color.parseColor(color));
                    setTaskDescription(tDesc);
                } catch (Exception ignored) {
                }
            }
        }
    }

    @Override
    protected void attachBaseContext(Context newBase) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase));
    }

    //region Debug
    /**
     * A simple wrap around the Log.d to debug purposes
     * @param content The content to be printed
     */
    public void dbg(String content) {
        Log.d("[DBG] =========>" + getClass().getCanonicalName(), content);
    }
    //endregion

    //region UI - Basic configuration
    /**
     * This method configures the custom Toolbar that will be used
     * through out the entire application
     */
    public void configureBasicToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ScreenUtils.updateStatusBarcolor(this, topColor);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    public void configureToolbarWithTitle(String title) {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle(title);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ScreenUtils.updateStatusBarcolor(this, topColor);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    /**
     * Retrieve a basic color to be used as background (i.e.: btn.setBackground(...))
     * @return A colorDrawable based on the build specs.
     */
    public ColorDrawable getBasicButtonColor() {
        return new ColorDrawable(Color.parseColor(UserUtils.getButtonColor(this)));
    }
    //endregion

    /**
     * Init the toolbar with a custom title.
     * @param title The title to be set on the toolbar.
     */
    public void initToolbar(String title) {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        if(title != null){
            getSupportActionBar().setTitle(title);
        }

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ScreenUtils.updateStatusBarcolor(this, topColor);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    public void dialogInstance(){
        customDialog = new CustomDialog(this);
        customDialogBuilder = customDialog.builder(this);
        buttonBuilder =  new br.com.lab360.oneinternacional.utils.customdialog.ButtonBuilder(this);
    }

    public void errorDialog(String title, String message, View.OnClickListener listener){
        dialogInstance();
        getCustomDialogBuilder()
                .setType(CustomDialogBuilder.DIALOG_TYPE.ERROR)
                .setTitle(title)
                .setMessage(message);

        getButtonBuilder()
                .newInstance()
                .setTextButton(getString(R.string.DIALOG_BUTTON_OK))
                .setTextColor(R.color.white)
                .setColorButton(R.drawable.red_button_background)
                .setListener(customButtomListener(listener))
                .create(getCustomDialogBuilder());

        showCustomDialog();
    }

    public void successDialog(String title, String message, View.OnClickListener listener){
        dialogInstance();
        getCustomDialogBuilder()
                .setType(CustomDialogBuilder.DIALOG_TYPE.SUCCESS)
                .setTitle(title)
                .setMessage(message);

        getButtonBuilder()
                .newInstance()
                .setTextButton(getString(R.string.DIALOG_BUTTON_OK))
                .setTextColor(R.color.white)
                .setColorButton(R.drawable.background_button_green)
                .setListener(customButtomListener(listener))
                .create(getCustomDialogBuilder());


        showCustomDialog();
    }

    public void atentionDialog(String title, String message, View.OnClickListener listener){
        dialogInstance();
        getCustomDialogBuilder()
                .setType(CustomDialogBuilder.DIALOG_TYPE.ATENTION)
                .setTitle(title)
                .setMessage(message);

        getButtonBuilder()
                .newInstance()
                .setTextButton(getString(R.string.DIALOG_BUTTON_OK))
                .setTextColor(R.color.white)
                .setColorButton(R.drawable.background_button_yellow)
                .setListener(customButtomListener(listener))
                .create(getCustomDialogBuilder());

        showCustomDialog();
    }

    public void infoDialog(String title, String message, View.OnClickListener listener){
        dialogInstance();
        getCustomDialogBuilder()
                .setType(CustomDialogBuilder.DIALOG_TYPE.INFORMATION)
                .setTitle(title)
                .setMessage(message);

        getButtonBuilder()
                .newInstance()
                .setTextButton(getString(R.string.DIALOG_BUTTON_OK))
                .setTextColor(R.color.white)
                .setColorButton(R.drawable.blue_button_background)
                .setListener(customButtomListener(listener))
                .create(getCustomDialogBuilder());

        showCustomDialog();
    }

    public void customDialog(CustomDialogBuilder.DIALOG_TYPE type, String title, String message, int image){
        dialogInstance();
        getCustomDialogBuilder()
                .setType(type)
                .setTitle(title)
                .setMessage(message)
                .setImage(image);

    }

    public void customDialogButton(String textButton, int textColor, int colorButton, View.OnClickListener listener){
        getButtonBuilder()
                .newInstance()
                .setTextButton(textButton)
                .setTextColor(textColor)
                .setColorButton(colorButton)
                .setListener(customButtomListener(listener))
                .create(getCustomDialogBuilder());
    }

    public CustomDialogBuilder getCustomDialogBuilder() {
        return customDialogBuilder;
    }

    public ButtonBuilder getButtonBuilder() {
        return buttonBuilder;
    }

    public View.OnClickListener customButtomListener(View.OnClickListener listener){
        if (listener == null){
            listener = new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    dismissCustomDialog();
                }
            };
        }
        return listener;
    }

    public void showCustomDialog() {
        if(!(isFinishing())) {
            customDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            customDialog.show();
        }
    }

    public void dismissCustomDialog() {
        customDialog.dismiss();
    }

    @Override
    public void showProgress() {
        if (progressDialog == null) {
            showProgressDlg();
        } else if(!progressDialog.isShown()) {
            showProgressDlg();
        }
    }

    /**
     * Fire the progress dialog
     */
    private void showProgressDlg(){
        progressDialog = new ProgressBar(this,null,android.R.attr.progressBarStyleLarge);
        progressDialog.getIndeterminateDrawable().setColorFilter(Color.parseColor(UserUtils.getBackgroundColor(this)), android.graphics.PorterDuff.Mode.MULTIPLY);
        progressDialog.setIndeterminate(true);
        progressDialog.setVisibility(View.VISIBLE);
        RelativeLayout relativeLayout = new RelativeLayout(this);
        RelativeLayout.LayoutParams rlp = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.MATCH_PARENT);

        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(180,180);
        params.addRule(RelativeLayout.CENTER_IN_PARENT);
        progressDialog.setLayoutParams(params);
        relativeLayout.addView(progressDialog);
        this.addContentView(relativeLayout, rlp);
        /*progressDialog = ProgressDialog.show(this, null, getText(R.string.MESSAGE_ACTIVITY_INDICATOR_LOADING),
                true, false);*/
    }

    @Override
    public void hideProgress() {
        if (progressDialog != null) {
            progressDialog.setVisibility(View.GONE);
        }
    }

    public void showRunningProgress() {
        if (progressDialog != null && !progressDialog.isShown()) {
            showProgressDlg();
            return;
        }

        showProgress();
    }

    @Override
    public void showToastMessage(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    public void showSnackMessage(String message) {
        Snackbar snackbar = Snackbar.make(findViewById(R.id.coordinator_layout), message, Snackbar.LENGTH_LONG);
        TextView txtMessage = (TextView) snackbar.getView().findViewById(com.google.android.material.R.id.snackbar_text);
        txtMessage.setTextColor(ContextCompat.getColor(this, R.color.white));
        snackbar.show();
    }

    @Override
    public void showNoConnectionSnackMessage() {
        Snackbar snackbar = Snackbar.make(findViewById(R.id.coordinator_layout), getText(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION), Snackbar.LENGTH_LONG);
        TextView txtMessage = (TextView) snackbar.getView().findViewById(com.google.android.material.R.id.snackbar_text);
        txtMessage.setTextColor(ContextCompat.getColor(this, R.color.no_connection_yellow));
        snackbar.show();
    }

    @Override
    public void showFixedSnackMessage(String message) {
        fixedSnackbar = Snackbar.make(findViewById(R.id.coordinator_layout), message, Snackbar.LENGTH_INDEFINITE);
        fixedSnackbar.show();
    }

    @Override
    public void hideFixedSnackMessage() {
        if (fixedSnackbar == null)
            return;
        fixedSnackbar.dismiss();
        fixedSnackbar = null;
    }
    //endregion

    //region Events
    @Override
    public void hideKeyboard() {
        try {
            View view = this.getCurrentFocus();
            if (view != null) {
                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    //endregion

    //region Services and more
    /**
     * Retrieve the user token
     *
     * @return Retrieve the user token as string.
     */
    public static String getUserToken(){
        SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        StringBuilder fullToken = new StringBuilder();
        String tokenAux = null;
        if(sharedPrefsHelper != null) {
            tokenAux =  sharedPrefsHelper.get(EnumLoginTypeCategory.USER_TOKEN.getUserToken, "");
        }

        return fullToken.append(FULL_TOKEN).append(tokenAux).toString();
    }

    /**
     * Requires Google Play Services API in Gradle
     * https://developers.google.com/android/guides/setup
     */
    public boolean isGooglePlayServicesAvailable() {
        return false;
        /*GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
        int status = googleApiAvailability.isGooglePlayServicesAvailable(this);
        if(status != ConnectionResult.SUCCESS) {
            if(googleApiAvailability.isUserResolvableError(status)) {
                googleApiAvailability.getErrorDialog(this, status, 2404).show();
            }
            return false;
        }
        return true;*/
    }

    @Override
    public boolean isOnline() {
        return NetworkStatsUtil.isConnected(this);
    }

    @Override
    public String getResourceString(int resourceId) {
        return getString(resourceId);
    }


    @Override
    public void saveUserIntoSharedPreferences(User response) {
        UserUtils.saveUser(this, response);
    }

    @Override
    public void userLogOut() {
        UserUtils.clearSharedPrefs(this);
    }

    @Override
    public void loadApplicationBackground() {
        String backgroundUrl = UserUtils.getLayoutParam(this).getBackgroundImage();
        loadBackground(backgroundUrl);
    }

    @Override
    public void loadCachedBackground() {
        String backgroundUrl = UserUtils.getCachedBackgroundUrl(this);
        loadBackground(backgroundUrl);
    }

    @Override
    public void loadBackground(final String backgroundUrl) {
        Glide.with(this)
                .load(backgroundUrl)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        CoordinatorLayout layout = findViewById(R.id.coordinator_layout);
                        if (layout != null) {
                            layout.setBackground(resource);
                        }
                        UserUtils.saveBackgroundUrl(BaseActivity.this, backgroundUrl);
                        return false;
                    }
                }).preload();
    }


    @Override
    public String getDeviceId() {
        final TelephonyManager tm = (TelephonyManager) getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);

        final String tmDevice, tmSerial, androidId;
        tmDevice = "" + tm.getDeviceId();
        tmSerial = "" + tm.getSimSerialNumber();
        androidId = "" + android.provider.Settings.Secure.getString(getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

        UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
        return deviceUuid.toString();
    }

    @Override
    public Activity getContext() {
        return this;
    }

    public String getTheLastUpdateProductList(){
        Date lastDate = UserUtils.getLastUpdateDate(AdaliveApplication.getInstance().getApplicationContext());
        return DateUtils.dateToString(lastDate, "yyyy-MM-dd 00:00:00");
    }
    //endregion

    //region Date Utils
        /**
     * Retrieve the actual timestamp
     * @return
     */
    public String getActualTimestamp() {
        DateFormat df = new SimpleDateFormat(kUPDATE_TIME_FORMAT);
        Date today = Calendar.getInstance().getTime();

        return df.format(today);
    }

    /**
     * Convert a string to date
     * @param date
     * @return
     */
    public Date convertToDate(String date) {
        DateFormat df = new SimpleDateFormat(kUPDATE_TIME_FORMAT);

        try {
            return df.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return null;
    }
    //endregion

    //region Permissions
    /**
     * Retrieve the base of the OS.
     *
     * @return The base base os version.
     */
    public String retrieveBaseOSParameter(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
             return Build.VERSION.BASE_OS;

        return "";
    }
    //endregion

    //region Utils

    /**
     * Craft a seven digits reference
     * @param ref
     * @return
     */
    public static String getSevenDigitsRef(String ref) {
        String newRef = ref;

        /* Add zeros on left */
        for(int i=ref.length(); i < 7; i++) {
            newRef = "0" + newRef;
        }

        return newRef;
    }

    public static String formatPhone(String phone) {
        if (phone != null) {
            if (phone.length() == 10) {
                return "(" + phone.substring(0, 2) + ") " + phone.substring(2, 6) + "-" + phone.substring(6, phone.length());
            }

            if (phone.length() == 11) {
                return "(" + phone.substring(0, 2) + ") " + phone.substring(2, 3) + "-" + phone.substring(3, 7)
                        + "-" + phone.substring(7, phone.length());
            }
        }

        return phone;
    }

    public static String formatCpf(String cpf) {
        if (cpf != null) {
            if (cpf.length() == 11) {
                return cpf.substring(0, 3) + "." + cpf.substring(3, 6) + "." + cpf.substring(6, 9) + "-" + cpf.substring(9, cpf.length());
            }
        }

        return cpf;
    }

    @Override
    public void uncaughtException(Thread t, Throwable e) {
        this.finishAffinity();
    }
    //endregion

}
