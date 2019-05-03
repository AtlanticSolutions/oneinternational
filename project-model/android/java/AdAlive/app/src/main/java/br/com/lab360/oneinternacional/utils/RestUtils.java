package br.com.lab360.oneinternacional.utils;

import android.content.Context;
import android.content.SharedPreferences;

import com.google.common.base.Strings;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import br.com.lab360.oneinternacional.application.AdaliveConstants;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class RestUtils {
    /**
     * Convert string to SHA 512
     */

    public static String convertToSHA512(String passwordToHash, String salt) {
        String generatedPassword = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt.getBytes("UTF-8"));
            byte[] bytes = md.digest(passwordToHash.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < bytes.length; i++) {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            generatedPassword = sb.toString();
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return generatedPassword;
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

}
