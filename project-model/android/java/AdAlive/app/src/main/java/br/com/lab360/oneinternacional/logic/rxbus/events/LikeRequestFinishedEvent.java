package br.com.lab360.oneinternacional.logic.rxbus.events;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */
public class LikeRequestFinishedEvent {

    private final int postId;

    public LikeRequestFinishedEvent(int id) {
        this.postId = id;
    }

    public int getPostId() {
        return postId;
    }
}
