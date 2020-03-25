package br.com.lab360.bioprime.logic.model.pojo.timeline;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class CommentRequest {
    private Message comment;

    public CommentRequest(Message comment) {
        this.comment = comment;
    }

    public Message getComment() {
        return comment;
    }
}
