package br.com.lab360.bioprime.logic.listeners;


import br.com.lab360.bioprime.logic.model.pojo.menu.MenuResponse;

/**
 * Created by Edson on 07/06/2018.
 */

public interface OnMenuLoadedListener {
    void onMenuLoadError(Throwable e);
    void onMenuLoadSuccess(MenuResponse response);
}
