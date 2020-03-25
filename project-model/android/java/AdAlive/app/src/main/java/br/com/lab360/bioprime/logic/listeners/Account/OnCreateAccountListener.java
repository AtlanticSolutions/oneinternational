package br.com.lab360.bioprime.logic.listeners.Account;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public interface OnCreateAccountListener {
    void onCreateAccountSuccess(User response);
    void onCreateAccountError(String message);
    void onCreateAccountError(ArrayList<Integer> errorFields);
}
