package br.com.lab360.oneinternacional.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.Pair;
import android.view.View;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 */

public class ImageUtils {
    /**
     * Map image path to gallery
     *
     * @param context
     * @param mCurrentPhotoPath
     */
    public static void addPhotoToGallery(Context context, String mCurrentPhotoPath) {
        Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        File f = new File(mCurrentPhotoPath);
        Uri contentUri = Uri.fromFile(f);
        mediaScanIntent.setData(contentUri);
        context.sendBroadcast(mediaScanIntent);
    }

    /**
     * Resize bitmap
     *
     * @param targetW
     * @param targetH
     * @return
     * @params dimensions of the View
     */
    public static Bitmap resizePic(int targetW, int targetH, String mCurrentPhotoPath) {
        // Get the dimensions of the bitmap
        BitmapFactory.Options bmOptions = new BitmapFactory.Options();
        bmOptions.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
        int photoW = bmOptions.outWidth;
        int photoH = bmOptions.outHeight;


        // Determine how much to scale down the image
        int scaleFactor = Math.min(photoW / targetW, photoH / targetH);

        // Decode the image file into a Bitmap sized to fill the View
        bmOptions.inJustDecodeBounds = false;
        bmOptions.inSampleSize = scaleFactor;
        return BitmapFactory.decodeFile(mCurrentPhotoPath, bmOptions);
    }

    public static Bitmap resizePic(Context context, int targetW, int targetH, Bitmap bitmap) {
        float lengthbmp = bitmap.getHeight();
        float widthbmp = bitmap.getWidth();

        // Get Screen width
        DisplayMetrics displaymetrics = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(displaymetrics);
        float hight = displaymetrics.heightPixels / 3;
        float width = displaymetrics.widthPixels / 3;

        int convertHighet = (int) hight, convertWidth = (int) width;

        // high length
        if (lengthbmp > hight) {
            convertHighet = (int) hight - 20;
            bitmap = Bitmap.createScaledBitmap(bitmap, convertWidth,
                    convertHighet, true);
        }

        // high width
        if (widthbmp > width) {
            convertWidth = (int) width - 20;
            bitmap = Bitmap.createScaledBitmap(bitmap, convertWidth,
                    convertHighet, true);
        }

        return bitmap;
    }


    public static Pair<File, String> createImageFile(Context context) throws IOException {
        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "GSMD_" + timeStamp + "_";
        File storageDir = context.getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        String mCurrentPhotoPath = image.getAbsolutePath();
        return new Pair<>(image, mCurrentPhotoPath);
    }

    public static String getRealPathFromUri(Context context, Uri contentUri) {
        String[] projection = {MediaStore.Images.Media.DATA};
        Cursor cursor = null;
        try {
            if (Build.VERSION.SDK_INT > 19) {
                // Will return "image:x*"
                String wholeID = DocumentsContract.getDocumentId(contentUri);
                // Split at colon, use second item in the array
                String id = wholeID.split(":")[1];
                // where id is equal to
                String sel = MediaStore.Images.Media._ID + "=?";

                cursor = context.getContentResolver().query(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        projection, sel, new String[]{id}, null);
            } else {
                cursor = context.getContentResolver().query(contentUri,
                        projection, null, null, null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String path = null;
        try {
            int column_index = cursor
                    .getColumnIndex(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            path = cursor.getString(column_index).toString();
            cursor.close();
        } catch (NullPointerException e) {
            e.printStackTrace();
        }
        return path;
    }

    /**
     * Return uri from bitmap saved from the device.
     *
     * @param bmp     bitmap saved.
     * @param context current context.
     * @return uri.
     */
    public static Uri getLocalBitmapUri(Bitmap bmp, Context context) {
        Uri bmpUri = null;
        try {
            File file = new File(context.getExternalFilesDir(Environment.DIRECTORY_PICTURES),
                    "share_image_" + System.currentTimeMillis() + ".png");
            FileOutputStream out = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.PNG, 90, out);
            out.close();
            bmpUri = Uri.fromFile(file);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return bmpUri;
    }

    /**
     * Creates a image file from a view
     *
     * @param v the view to be converted to an image
     * @return a Bitmap file from the view
     */
    @SuppressLint("NewApi")
    public static Bitmap getViewBitmap(View v) {
        v.clearFocus();
        v.setPressed(false);

        boolean willNotCache = v.willNotCacheDrawing();
        v.setWillNotCacheDrawing(false);
        try {
            v.setForeground(null);
        } catch (Exception ignored) {
        }

        // Reset the drawing cache background color to fully transparent
        // for the duration of this operation
        int color = v.getDrawingCacheBackgroundColor();
        v.setDrawingCacheBackgroundColor(0);

        if (color != 0) {
            v.destroyDrawingCache();
        }
        v.buildDrawingCache();
        Bitmap cacheBitmap = v.getDrawingCache();
        if (cacheBitmap == null) {
            Log.e("BITMAP", "failed getViewBitmap(" + v + ")", new RuntimeException());
            return null;
        }

        Bitmap bitmap = Bitmap.createBitmap(cacheBitmap);

        // Restore the view
        v.destroyDrawingCache();
        v.setWillNotCacheDrawing(willNotCache);
        v.setDrawingCacheBackgroundColor(color);

        return bitmap;
    }

    /**
     * Generates a single image from two bitmaps
     *
     * @param backImage  the image that will be behind
     * @param frontImage the front image
     * @return an combined images with the firstImage in the back and the secondImage in front
     */
    public static Bitmap mergeTwoBitmaps(Bitmap backImage, Bitmap frontImage) {
        Bitmap result = Bitmap.createBitmap(backImage.getWidth(), backImage.getHeight(), backImage.getConfig());
        Canvas canvas = new Canvas(result);
        canvas.drawBitmap(backImage, 0f, 0f, null);
        canvas.drawBitmap(frontImage, 0, 0, null);
        return result;
    }

    /**
     * Converts a bitmap to byte array
     *
     * @param bitmap bitmap to be converted
     * @return byte array from bitmap
     */
    public static byte[] bitmapToByte(Bitmap bitmap) {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
        byte[] byteArray = stream.toByteArray();
        return byteArray;
    }

    public static Uri getFileProviderBitmapUri(Context inContext, Bitmap inImage) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        String path = MediaStore.Images.Media.insertImage(inContext.getContentResolver(), inImage, "temp", null);
        return Uri.parse(path);
    }

    /**
     * Share multiples bitmaps at once
     *
     * @param activity
     * @param bitmapArray
     */
    public static void shareBitmapArray(BaseActivity activity, ArrayList<Bitmap> bitmapArray) {
        ArrayList<Uri> filesToShare = new ArrayList<>();
        for (Bitmap b : bitmapArray) {
            filesToShare.add(getFileProviderBitmapUri(activity, b));
        }

        Intent i = new Intent(Intent.ACTION_SEND_MULTIPLE);
        i.setType("image/*");
        i.putExtra(Intent.EXTRA_STREAM, filesToShare);
        activity.startActivity(Intent.createChooser(i, activity.getString(R.string.com_facebook_share_button_text)));
    }

    /**
     * Share a single bitmap
     *
     * @param activity
     * @param bitmap
     */
    public static void shareBitmap(BaseActivity activity, Bitmap bitmap) {
        ArrayList<Bitmap> arrayList = new ArrayList<>();
        arrayList.add(bitmap);
        shareBitmapArray(activity, arrayList);
    }

}
