package br.com.lab360.bioprime.logic.listeners.Timeline;

import br.com.lab360.bioprime.logic.model.pojo.timeline.MessageResponse;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnPostRemovedListener {
    void onRemovePostError(String message);

    void onPostRemoveSuccess(MessageResponse response);
}
