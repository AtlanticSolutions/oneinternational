package br.com.lab360.oneinternacional.logic.listeners.Timeline;

import br.com.lab360.oneinternacional.logic.model.pojo.timeline.Post;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnPostCreatedListener {
    void onCreatePostError(String message);

    void onCreatePostSuccess(Post post);
}
