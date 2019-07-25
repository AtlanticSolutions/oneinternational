package br.com.lab360.oneinternacional.logic.model.pojo.timeline;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */

public class CreatePostRequest {
    @SerializedName("post_logs")
    private PostLog log;
    private PostCreation post;

    public CreatePostRequest(PostLog log, PostCreation post) {
        this.log = log;
        this.post = post;
    }
}
