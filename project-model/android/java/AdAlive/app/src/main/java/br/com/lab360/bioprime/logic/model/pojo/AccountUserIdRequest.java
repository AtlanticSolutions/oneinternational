package br.com.lab360.bioprime.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 09/12/2016.
 */
public class AccountUserIdRequest {
    @SerializedName("account_id")
    private int accountId;
    @SerializedName("app_user_id")
    private int userId;

    public AccountUserIdRequest(int accountId, int userId) {
        this.accountId = accountId;
        this.userId = userId;
    }
}
