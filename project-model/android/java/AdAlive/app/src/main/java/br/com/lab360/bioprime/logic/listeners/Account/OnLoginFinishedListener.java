package br.com.lab360.bioprime.logic.listeners.Account;

import br.com.lab360.bioprime.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 */

public interface OnLoginFinishedListener {
    void onLoginSuccess(User response);
    void onLoginError(String error);
}
