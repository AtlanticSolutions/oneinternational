package br.com.lab360.bioprime.logic.listeners.Account;

import br.com.lab360.bioprime.logic.model.pojo.StatusResponse;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public interface OnForgotPasswordListener {
    void onForgotPassError(String error);
    void onForgotPasswordSuccess(StatusResponse response);
}
