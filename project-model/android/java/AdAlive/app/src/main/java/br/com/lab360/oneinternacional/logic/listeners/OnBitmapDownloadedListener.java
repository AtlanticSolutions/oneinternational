package br.com.lab360.oneinternacional.logic.listeners;

import android.graphics.Bitmap;

/**
 * Created by Alessandro Valenza on 24/11/2016.
 */
public interface OnBitmapDownloadedListener {
    void onBitmapDownloadFinished(Bitmap bitmap);
    void onBitmapDownloadError(String error);
}
