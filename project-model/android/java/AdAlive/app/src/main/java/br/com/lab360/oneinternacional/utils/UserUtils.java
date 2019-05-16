package br.com.lab360.oneinternacional.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestListener;
import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.roles.RoleProfileObject;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.user.LayoutParam;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;

/**
 * Main commands to control user shared preferences.
 * Created by Victor Santiago on 28/11/2016.
 */
public abstract class UserUtils {

    /**
     * Save user to shared preferences.
     *
     * @param context   current context app.
     * @param user user app.
     */
    public static void saveUser(Context context, final User user) {

        final SharedPreferences.Editor editor = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE).edit();
        editor.putInt(AdaliveConstants.ID, user.getId());
        editor.putString(AdaliveConstants.FIRST_NAME, user.getFirstName());
        editor.putString(AdaliveConstants.LAST_NAME, user.getLastName());
        editor.putString(AdaliveConstants.EMAIL, user.getEmail());
        editor.putString(AdaliveConstants.DDD_PHONE, user.getDddPhone());
        editor.putString(AdaliveConstants.PHONE, user.getPhone());
        editor.putString(AdaliveConstants.DDD_CELL_PHONE, user.getDddCellPhone());
        editor.putString(AdaliveConstants.CELL_PHONE, user.getCellPhone());
        editor.putString(AdaliveConstants.ROLE, user.getJobRoleID());
        editor.putString(AdaliveConstants.COMPANY_NAME, user.getCompanyName());
        editor.putString(AdaliveConstants.ADDRESS, user.getAddress());
        editor.putString(AdaliveConstants.NUMBER, user.getNumber());
        editor.putString(AdaliveConstants.COMPLEMENT, user.getComplement());
        editor.putString(AdaliveConstants.DISTRICT, user.getDistrict());
        editor.putString(AdaliveConstants.CITY, user.getCity());
        editor.putString(AdaliveConstants.ZIPCODE, user.getZipcode());
        editor.putString(AdaliveConstants.STATE, user.getState());
        editor.putString(AdaliveConstants.COUNTRY, user.getCountry());
        editor.putInt(AdaliveConstants.SECTOR_ID, user.getSectorId());
        editor.putString(AdaliveConstants.CPF, user.getCpf());
        editor.putString(AdaliveConstants.CNPJ, user.getCnpj());
        editor.putString(AdaliveConstants.RG, user.getRg());
        editor.putString(AdaliveConstants.BIRTHDATE, user.getBirthDate());
        editor.putString(AdaliveConstants.INTEREST_LIST, new Gson().toJson(user.getInterestArea()));
        editor.putString(AdaliveConstants.ROLE_PROFILE, user.getRole());

        SimpleDateFormat toFormat = new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat fromFormat = new SimpleDateFormat("yyyy-MM-dd");

        try {

            if(user.getBirthDate() != null){
                String reformattedString = toFormat.format(fromFormat.parse(user.getBirthDate()));
                editor.putString(AdaliveConstants.BIRTHDATE, reformattedString);
            }
        } catch (ParseException e) {
            editor.putString(AdaliveConstants.BIRTHDATE, user.getBirthDate());
            e.printStackTrace();
        }

        editor.putInt(AdaliveConstants.GENDER, user.getGender());


        if(user.getProfileImageURL() != null && !user.getProfileImageURL().equals("")){
            editor.putString(AdaliveConstants.BASE64_PROFILE_IMAGE, user.getProfileImageURL());
        }else{
            editor.putString(AdaliveConstants.BASE64_PROFILE_IMAGE, user.getProfileImage());
        }

        editor.apply();
    }

    /**
     * Get saved user from the shared preferences.
     *
     * @param context current context app.
     */
    public static User loadUser(Context context) {

        User user = new User();

        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        user.setId(preferences.getInt(AdaliveConstants.ID, 0));
        user.setFirstName(preferences.getString(AdaliveConstants.FIRST_NAME, ""));
        user.setLastName(preferences.getString(AdaliveConstants.LAST_NAME, ""));
        user.setEmail(preferences.getString(AdaliveConstants.EMAIL, ""));
        user.setDddPhone(preferences.getString(AdaliveConstants.DDD_PHONE, ""));
        user.setPhone(preferences.getString(AdaliveConstants.PHONE, ""));
        user.setDddCellPhone(preferences.getString(AdaliveConstants.DDD_CELL_PHONE, ""));
        user.setCellPhone(preferences.getString(AdaliveConstants.CELL_PHONE, ""));
        user.setJobRoleID(preferences.getString(AdaliveConstants.ROLE, ""));
        user.setCompanyName(preferences.getString(AdaliveConstants.COMPANY_NAME, ""));
        user.setAddress(preferences.getString(AdaliveConstants.ADDRESS, ""));
        user.setNumber(preferences.getString(AdaliveConstants.NUMBER, ""));
        user.setComplement(preferences.getString(AdaliveConstants.COMPLEMENT, ""));
        user.setDistrict(preferences.getString(AdaliveConstants.DISTRICT, ""));
        user.setCity(preferences.getString(AdaliveConstants.CITY, ""));
        user.setZipcode(preferences.getString(AdaliveConstants.ZIPCODE, ""));
        user.setState(preferences.getString(AdaliveConstants.STATE, ""));
        user.setCountry(preferences.getString(AdaliveConstants.COUNTRY, ""));
        user.setSectorId(preferences.getInt(AdaliveConstants.SECTOR_ID, 0));
        user.setCpf(preferences.getString(AdaliveConstants.CPF, ""));
        user.setCnpj(preferences.getString(AdaliveConstants.CNPJ, ""));
        user.setRg(preferences.getString(AdaliveConstants.RG, ""));
        user.setBirthDate(preferences.getString(AdaliveConstants.BIRTHDATE, ""));
        user.setGender(preferences.getInt(AdaliveConstants.GENDER, 99));
        user.setProfileImage(preferences.getString(AdaliveConstants.BASE64_PROFILE_IMAGE, ""));
        user.setRole(preferences.getString(AdaliveConstants.ROLE_PROFILE, ""));

        String interestJson = preferences.getString(AdaliveConstants.INTEREST_LIST, "");
        if (!TextUtils.isEmpty(interestJson)) {
            user.setInterestArea((ArrayList<Integer>) new Gson().fromJson(interestJson, new TypeToken<ArrayList<Integer>>() {
            }.getType()));
        }
        return user;
    }


    /**
     * Clear saved user from the shared preferences.
     *
     * @param context current context app.
     */
    public static void clearSharedPrefs(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().clear().apply();
    }

    public static void saveNameApp(Context context, String nameApp) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (!Strings.isNullOrEmpty(nameApp)){
            preferences.edit().putString(AdaliveConstants.NAME_APP, nameApp).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.NAME_APP, context.getResources().getString(R.string.SCREEN_TITLE_MAIN)).apply();
        }
    }

    public static String getNameApp(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.NAME_APP, null);
    }

    public static void saveVersion(Context context, String versionApp) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (!Strings.isNullOrEmpty(versionApp)){
            preferences.edit().putString(AdaliveConstants.VERSION_APP, versionApp).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.VERSION_APP, "").apply();
        }
    }

    public static String getVersion(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.VERSION_APP, null);
    }


    public static void saveBackgroundUrl(Context context, String backgroundUrl) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (!Strings.isNullOrEmpty(backgroundUrl)){
            preferences.edit().putString(AdaliveConstants.BACKGROUND, backgroundUrl).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.BACKGROUND, "").apply();
        }
    }

    public static String getBackgroundUrl(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.BACKGROUND, null);
    }

    public static void saveSliderBanner(Context context, BannerResponse response) {
        Gson gson = new Gson();
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (response != null){
            preferences.edit().putString(AdaliveConstants.SLIDER_BANNER, gson.toJson(response)).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.SLIDER_BANNER, gson.toJson(new BannerResponse())).apply();
        }
    }

    public static BannerResponse getSliderBanner(Context context) {
        Gson gson = new Gson();
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return gson.fromJson(preferences.getString(AdaliveConstants.SLIDER_BANNER, null), BannerResponse.class);
    }

    public static void saveBannerUrl(Context context, String bannerUrl) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (!Strings.isNullOrEmpty(bannerUrl)){
            preferences.edit().putString(AdaliveConstants.BANNER, bannerUrl).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.BANNER, "").apply();
        }
    }

    public static void saveBannerLinkUrl(Context context, String homepageurl) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (!Strings.isNullOrEmpty(homepageurl)){
            preferences.edit().putString(AdaliveConstants.BANNER_LINK, homepageurl).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.BANNER_LINK, "").apply();
        }
    }

    public static String getCachedBackgroundUrl(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.BACKGROUND, null);
    }
    public static String getCachedBannerUrl(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.BANNER, null);
    }
    public static String getCachedBannerLinkUrl(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.BANNER_LINK, null);
    }

    public static void saveAppId(Context context, int appId) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putInt(AdaliveConstants.TAG_APP_ID, appId).apply();
    }

    public static int getAppId(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getInt(AdaliveConstants.TAG_APP_ID, 1);
    }

    public static void saveVuforiaAccessKey(Context context, String vuforiaAccessKey){
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.VUFORIA_ACCESS_KEY, vuforiaAccessKey).apply();
    }

    public static String getVuforiaAccessKey(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.VUFORIA_ACCESS_KEY, "");
    }

    public static void saveVuforiaSecretKey(Context context, String vuforiaSecretKey){
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.VUFORIA_SECRET_KEY, vuforiaSecretKey).apply();
    }

    public static String getVuforiaSecretKey(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.VUFORIA_SECRET_KEY, "");
    }

    public static void saveVuforiaLicenseKey(Context context, String vuforiaLicenseKey){
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.VUFORIA_LICENSE_KEY, vuforiaLicenseKey).apply();
    }

    public static String getVuforiaLicenseKey(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.VUFORIA_LICENSE_KEY, "");
    }

    public static void saveMasterEventId(Context context, int masterEventId) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putInt(AdaliveConstants.MASTER_EVENT_ID, masterEventId).apply();
    }

    public static int getMasterEventId(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getInt(AdaliveConstants.MASTER_EVENT_ID, 1);
    }

    public static void saveRoles(Context context, List<RoleProfileObject> roleProfileObjects) {
        Gson gson = new Gson();
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        if (roleProfileObjects != null){
            preferences.edit().putString(AdaliveConstants.ROLES, gson.toJson(roleProfileObjects)).apply();
        }else{
            preferences.edit().putString(AdaliveConstants.ROLES, gson.toJson(new ArrayList<RoleProfileObject>())).apply();
        }
    }

    public static List<RoleProfileObject> getRoles(Context context) {
        Gson gson = new Gson();
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        String preferencesString = preferences.getString(AdaliveConstants.ROLES, "[]");
        RoleProfileObject[] roleProfileObjects = gson.fromJson(preferencesString, RoleProfileObject[].class);
        return Arrays.asList(roleProfileObjects);
    }

    public static void saveLogoUrl(Context context, String logoUrl) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.LOGO_URL, logoUrl).apply();
    }

    public static String getLogoUrl(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.LOGO_URL, null);
    }

    public static void saveTextColor(Context context, String logoUrl) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.TEXT_COLOR, logoUrl).apply();
    }

    public static String getColorText(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.TEXT_COLOR, null);
    }

    public static void saveBackgroundColor(Context context, String color) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);

        if (!color.contains("#") && !Strings.isNullOrEmpty(color)){
            color = "#" + color;
        }

        preferences.edit().putString(AdaliveConstants.BACKGROUND_COLOR, color).apply();
    }

    public static String getBackgroundColor(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.BACKGROUND_COLOR, context.getResources().getString(R.color.colorAccent));
    }

    public static void saveShowCode(Context context, boolean showEvent) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.SHOW_EVENT_SCREAN, showEvent).apply();
    }

    public static boolean getShowCode(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.SHOW_EVENT_SCREAN, false);
    }


    public static void saveRegisterUser(Context context, boolean showEvent) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.REGISTER_USER, showEvent).apply();
    }

    public static boolean getRegisterUser(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.REGISTER_USER, false);
    }

    public static void saveRoleProfile(Context context, String roleProfile) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.ROLE_PROFILE, roleProfile).apply();
    }

    public static String getRoleProfile(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.ROLE_PROFILE, "");
    }

    /**
     * CanPost : User can/can't post on the timeline
     * @param ctx
     * @param canPost
     */
    public static void saveCanCreatePost(Context ctx, Boolean canPost) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.CAN_POST, canPost).apply();
    }

    /**
     * Check if the user can or can' post : @see{@link #saveCanCreatePost(Context, Boolean)}
     * @param ctx
     */
    public static boolean getCanCreatePost(Context ctx) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.CAN_POST, true);
    }

    public static void saveCanLikePost(Context ctx, Boolean canLike) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.CAN_LIKE, canLike).apply();
    }

    public static boolean getCanLikePost(Context ctx) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.CAN_LIKE, true);
    }

    public static void saveCanSharePost(Context ctx, Boolean canShare) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.CAN_SHARE, canShare).apply();
    }

    public static boolean getCanSharePost(Context ctx) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.CAN_SHARE, true);
    }

    public static void saveCanCommentPost(Context ctx, Boolean canComment) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putBoolean(AdaliveConstants.CAN_COMMENT, canComment).apply();
    }

    public static boolean getCanCommentPost(Context ctx) {
        SharedPreferences preferences = ctx.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getBoolean(AdaliveConstants.CAN_COMMENT, true);
    }

    public static void saveButtonColor(Context context, String color) {
        if (!color.contains("#") && !Strings.isNullOrEmpty(color)){
            color = "#" + color;
        }

        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.TEXT_COLOR_FIRST, color).apply();
    }

    public static String getButtonColor(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.TEXT_COLOR_FIRST, context.getResources().getString(R.color.colorAccent));
    }

    public static String getLoginErrorMessge(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.LOGIN_ERROR_MESSAGE, "");
    }


    public static void saveLoginErrorMessage(Context context, String roleProfile) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.LOGIN_ERROR_MESSAGE, roleProfile).apply();
    }

    public static Date getLastUpdateDate(Context context) {

        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);

        long lastDate = preferences.getLong(AdaliveConstants.LAST_UPDATE, 0);

        if (lastDate == 0){
            Date datetemp = new DateUtils().stringToDate("2001-01-01 00:00:00", "yyyy-MM-dd 00:00:00");
            lastDate = datetemp.getTime();
        }

        return new Date(lastDate);
    }

    public static void setLastUpdateDate(Context context, Date lastUpdate) {

        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putLong (AdaliveConstants.LAST_UPDATE, lastUpdate.getTime()).apply();

    }

    public static LayoutParam getLayoutParam(Context context) {
        LayoutParam layoutParam = new LayoutParam();
        layoutParam.setMasterEventId(UserUtils.getMasterEventId(context));
        layoutParam.setRoles(UserUtils.getRoles(context));
        layoutParam.setName(UserUtils.getNameApp(context));
        layoutParam.setVersion(UserUtils.getVersion(context));
        layoutParam.setLogo(UserUtils.getLogoUrl(context));
        layoutParam.setBackgroundImage(UserUtils.getBackgroundUrl(context));
        layoutParam.setHeadImage(UserUtils.getCachedBannerUrl(context));
        layoutParam.setVuforiaAccessKey(UserUtils.getVuforiaAccessKey(context));
        layoutParam.setVuforiaSecretKey(UserUtils.getVuforiaSecretKey(context));
        layoutParam.setVuforiaLicenseKey(UserUtils.getVuforiaLicenseKey(context));
        layoutParam.setShowCode(UserUtils.getShowCode(context));
        layoutParam.setRegisterUser(UserUtils.getRegisterUser(context));
        layoutParam.setTextColor(UserUtils.getColorText(context));
        layoutParam.setBackgroundColor(UserUtils.getBackgroundColor(context));
        layoutParam.setButtonFirstColor(UserUtils.getButtonColor(context));
        layoutParam.setLoginErrorMessage(UserUtils.getLoginErrorMessge(context));
        return layoutParam;
    }

    public static void setLayoutParam(LayoutParam layoutParam, Context context) {
        UserUtils.saveMasterEventId(context, layoutParam.getMasterEventId());
        UserUtils.saveRoles(context, layoutParam.getRoles());
        UserUtils.saveNameApp(context, layoutParam.getName());
        UserUtils.saveVersion(context, layoutParam.getVersion());
        UserUtils.saveLogoUrl(context, layoutParam.getLogo());
        UserUtils.saveBackgroundUrl(context, layoutParam.getBackgroundImage());
        UserUtils.saveBannerUrl(context, layoutParam.getHeadImage());
        UserUtils.saveBannerLinkUrl(context, layoutParam.getHomepageUrl());
        UserUtils.saveVuforiaAccessKey(context, layoutParam.getVuforiaAccessKey());
        UserUtils.saveVuforiaSecretKey(context, layoutParam.getVuforiaSecretKey());
        UserUtils.saveVuforiaLicenseKey(context, layoutParam.getVuforiaLicenseKey());
        UserUtils.saveShowCode(context, layoutParam.getShowCode());
        UserUtils.saveRegisterUser(context, layoutParam.getRegisterUser());
        UserUtils.saveTextColor(context, layoutParam.getTextColor());
        UserUtils.saveBackgroundColor(context, layoutParam.getBackgroundColor());
        UserUtils.saveButtonColor(context, layoutParam.getButtonFirstColor());
        UserUtils.saveLoginErrorMessage(context, layoutParam.getLoginErrorMessage());
    }

    public static void setConfigurationsByRole(RoleProfileObject roleProfileObject, Context context) {
        UserUtils.saveBannerUrl(context, roleProfileObject.getHeadImage());
        UserUtils.saveTextColor(context, roleProfileObject.getTextColor());
        UserUtils.saveBackgroundColor(context, roleProfileObject.getBackgroundColor());
        UserUtils.saveMasterEventId(context, roleProfileObject.getMasterEventID());
        UserUtils.saveRoleProfile(context, roleProfileObject.getRole());
        UserUtils.saveButtonColor(context, roleProfileObject.getButtonFirstColor());
        UserUtils.saveCanCreatePost(context, roleProfileObject.getCanCreatePost());
        UserUtils.saveCanLikePost(context, roleProfileObject.getCanLike());
        UserUtils.saveCanSharePost(context, roleProfileObject.getCanShare());
        UserUtils.saveCanCommentPost(context, roleProfileObject.getCanComment());
    }

    public static RoleProfileObject getCurrentUserRole(Context context){
        RoleProfileObject roleProfileObject = new RoleProfileObject();
        for (RoleProfileObject roleProfile: getLayoutParam(context).getRoles()) {
            roleProfileObject = roleProfile;
        }

        return roleProfileObject;
    }
}
