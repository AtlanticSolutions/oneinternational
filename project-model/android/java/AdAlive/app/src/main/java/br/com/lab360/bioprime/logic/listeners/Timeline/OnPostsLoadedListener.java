package br.com.lab360.bioprime.logic.listeners.Timeline;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public interface OnPostsLoadedListener {
    void onLoadPostError(String message);

    void onLoadPostsSuccess(ArrayList<Post> posts);
}
