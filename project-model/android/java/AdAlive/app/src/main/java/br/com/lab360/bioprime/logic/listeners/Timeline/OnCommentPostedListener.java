package br.com.lab360.bioprime.logic.listeners.Timeline;

import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnCommentPostedListener {
    void onPostCommentError(String message);

    void onPostCommentSuccess(Post post);
}
