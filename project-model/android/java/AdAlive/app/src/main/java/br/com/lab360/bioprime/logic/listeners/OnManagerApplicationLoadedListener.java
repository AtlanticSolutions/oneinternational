package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplicationResponse;

/**
 * Created by Edson on 28/06/2018.
 */

public interface OnManagerApplicationLoadedListener {
    void onManagerApplicationLoadError(Throwable e);
    void onManagerApplicationLoadSuccess(ManagerApplicationResponse response);
}
