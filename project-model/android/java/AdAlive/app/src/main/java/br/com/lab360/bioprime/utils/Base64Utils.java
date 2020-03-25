package br.com.lab360.bioprime.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;

import java.io.ByteArrayOutputStream;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */

public class Base64Utils {
    /**
     * Encode image to string base64.
     *
     * @param image          normaly user photo avatar.
     * @param compressFormat compress image format.
     * @param quality        photo quality to save.
     * @return string base64.
     */
    public static String encodeFileToBase64(Bitmap image, Bitmap.CompressFormat compressFormat, int quality) {
        ByteArrayOutputStream byteArrayOS = new ByteArrayOutputStream();
        image.compress(compressFormat, quality, byteArrayOS);
        return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.DEFAULT);
    }

    /**
     * Decode base64 to bitmap image.
     *
     * @param input string base64.
     * @return bitmap photo.
     */
    public static Bitmap decodeBase64(String input) {
        byte[] decodedBytes = Base64.decode(input, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
    }

    public static String encodeFileToBase64(String mCurrentPhotoPath) {
        BitmapFactory.Options bmOptions = new BitmapFactory.Options();
        Bitmap image = BitmapFactory.decodeFile(mCurrentPhotoPath,bmOptions);

        ByteArrayOutputStream byteArrayOS = new ByteArrayOutputStream();
        image.compress(Bitmap.CompressFormat.JPEG, 70, byteArrayOS);
        image.recycle();
        image = null;
        return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.NO_WRAP);
    }
}
