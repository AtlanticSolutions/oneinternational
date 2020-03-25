package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.videos.Videos;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public interface OnGetVideosListener {
    void onVideosLoadSuccess(Videos videos);
    void onVideosLoadError(String error);
}
