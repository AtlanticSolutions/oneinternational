package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.user.LayoutParam;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */
public interface OnLayoutLoadedListener {
    void onLayoutLoadError();
    void onLayoutLoadSuccess(LayoutParam params);
}
