package br.com.lab360.oneinternacional.logic.listeners.Account;

import br.com.lab360.oneinternacional.logic.model.pojo.StatusResponse;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public interface OnForgotPasswordListener {
    void onForgotPassError(String error);
    void onForgotPasswordSuccess(StatusResponse response);
}
