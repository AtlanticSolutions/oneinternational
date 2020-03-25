package br.com.lab360.bioprime.logic.model.pojo.chat;

import br.com.lab360.bioprime.application.AdaliveConstants;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class RegisterDeviceRequest extends ChatBaseRequest{

    private int userId;
    private String deviceId;
    private String platform;

    public RegisterDeviceRequest(int accountId, int userId, String deviceId) {
        super("registerDeviceId", accountId);
        this.userId = userId;
        this.deviceId = deviceId;
        this.platform = AdaliveConstants.PLATFORM;
    }
}
