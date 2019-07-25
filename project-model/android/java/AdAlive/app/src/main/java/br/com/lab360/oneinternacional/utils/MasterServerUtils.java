package br.com.lab360.oneinternacional.utils;

import android.content.Context;
import android.content.SharedPreferences;

import br.com.lab360.oneinternacional.application.AdaliveConstants;

public class MasterServerUtils {

    public static String getUrlAdaliveApi(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.URL_ADALIVE_API, "");
    }


    public static void saveUrlAdaliveApi(Context context, String urlAdalive) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.URL_ADALIVE_API, urlAdalive).apply();
    }


    public static String getUrlAmazonApi(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.URL_AMAZON_API, "");
    }


    public static void saveUrlAmazonApi(Context context, String urlAmazon) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.URL_AMAZON_API, urlAmazon).apply();
    }

    public static String getUrlChatApi(Context context) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        return preferences.getString(AdaliveConstants.URL_CHAT_API, "");
    }


    public static void saveUrlChatApi(Context context, String urlChat) {
        SharedPreferences preferences = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        preferences.edit().putString(AdaliveConstants.URL_CHAT_API, urlChat).apply();
    }
}
