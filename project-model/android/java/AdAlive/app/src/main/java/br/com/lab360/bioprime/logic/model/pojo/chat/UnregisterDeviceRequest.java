package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class UnregisterDeviceRequest extends ChatBaseRequest{

    private int userId;
    private String deviceId;

    public UnregisterDeviceRequest(int accountId, int userId, String deviceId) {
        super("unregisterDeviceId", accountId);
        this.userId = userId;
        this.deviceId = deviceId;
    }
}
