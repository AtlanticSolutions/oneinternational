package br.com.lab360.oneinternacional.logic.listeners.Timeline;

import br.com.lab360.oneinternacional.logic.model.pojo.timeline.MessageResponse;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnPostRemovedListener {
    void onRemovePostError(String message);

    void onPostRemoveSuccess(MessageResponse response);
}
