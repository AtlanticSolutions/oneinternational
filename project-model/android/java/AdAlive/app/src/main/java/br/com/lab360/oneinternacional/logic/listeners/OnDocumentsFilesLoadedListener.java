package br.com.lab360.oneinternacional.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;

/**
 * Created by Alessandro Valenza on 02/12/2016.
 */
public interface OnDocumentsFilesLoadedListener {
    void onDocumentsFilesLoadSuccess(ArrayList<DownloadInfoObject> files);
    void onDocumentsFilesLoadError(String error);
}
