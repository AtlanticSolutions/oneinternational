package br.com.lab360.oneinternacional.logic.listeners;


import br.com.lab360.oneinternacional.logic.model.pojo.warningactions.WarningActionsResponse;

/**
 * Created by Edson on 11/05/2018.
 */

public interface OnWarningActionsListener {

    void onWarningActionsLoadSuccess(WarningActionsResponse response);
    void onWarningActionsLoadError(String message);
}
