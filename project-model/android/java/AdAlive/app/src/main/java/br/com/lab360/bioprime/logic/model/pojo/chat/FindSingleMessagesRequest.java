package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class FindSingleMessagesRequest extends ChatBaseRequest {
    private int userId1, userId2, total;

    public FindSingleMessagesRequest(int accountId, int userId1, int userId2, int total) {
        super("findSingleMessages", accountId);
        this.userId1 = userId1;
        this.userId2 = userId2;
        this.total = total;
    }
}
