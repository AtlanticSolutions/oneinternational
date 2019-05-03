package br.com.lab360.oneinternacional.logic.listeners;


import br.com.lab360.oneinternacional.logic.model.pojo.menu.MenuResponse;

/**
 * Created by Edson on 07/06/2018.
 */

public interface OnMenuLoadedListener {
    void onMenuLoadError(Throwable e);
    void onMenuLoadSuccess(MenuResponse response);
}
