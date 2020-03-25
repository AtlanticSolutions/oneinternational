package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class SendSingleMessageRequest extends ChatBaseRequest {
    private int senderId, receiverId;
    private String message;

    public SendSingleMessageRequest(int accountId, int senderId, int receiverId, String message) {
        super("sendSingleMessage", accountId);
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.message = message;
    }
}
