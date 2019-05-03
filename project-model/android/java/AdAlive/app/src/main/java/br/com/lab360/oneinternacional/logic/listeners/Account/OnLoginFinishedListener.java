package br.com.lab360.oneinternacional.logic.listeners.Account;

import br.com.lab360.oneinternacional.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 */

public interface OnLoginFinishedListener {
    void onLoginSuccess(User response);
    void onLoginError(String error);
}
