package br.com.lab360.bioprime.logic.rxbus.events;

import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */
public class DownloadFileFinishedEvent {

    private final DownloadInfoObject downloadInfoObject;

    public DownloadFileFinishedEvent(DownloadInfoObject obj) {
        this.downloadInfoObject = obj;
    }

    public DownloadInfoObject getDownalodID() {
        return downloadInfoObject;
    }
}
