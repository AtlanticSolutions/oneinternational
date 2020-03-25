package br.com.lab360.bioprime.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class ChatBaseRequest {
    private String action;
    private int accountId;

    public ChatBaseRequest(String action, int accountId) {
        this.action = action;
        this.accountId = accountId;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}
