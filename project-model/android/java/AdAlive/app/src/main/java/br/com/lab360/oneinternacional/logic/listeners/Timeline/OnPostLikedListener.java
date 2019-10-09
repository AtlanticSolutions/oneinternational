package br.com.lab360.oneinternacional.logic.listeners.Timeline;

import br.com.lab360.oneinternacional.logic.model.pojo.timeline.Post;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnPostLikedListener {
    void onLikePostError(int post, String message);

    void onLikePostSuccess(Post post);
}