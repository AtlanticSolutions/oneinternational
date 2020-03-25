package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class SendGroupMessageRequest extends ChatBaseRequest {

    private int userId, groupId;
    private String message, deviceId;

    public SendGroupMessageRequest(int accountId, int userId, int groupId, String deviceId, String message) {
        super("sendGroupMessage", accountId);
        this.userId = userId;
        this.groupId = groupId;
        this.deviceId = deviceId;
        this.message = message;
    }
}
