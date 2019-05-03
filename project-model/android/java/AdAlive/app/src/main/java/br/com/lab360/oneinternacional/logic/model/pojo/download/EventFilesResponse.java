package br.com.lab360.oneinternacional.logic.model.pojo.download;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 01/11/2016.
 */

public class EventFilesResponse {

    @SerializedName("event_files")
    private ArrayList<DownloadInfoObject> eventFiles;

    public ArrayList<DownloadInfoObject> getEventFiles() {
        return eventFiles;
    }


}
