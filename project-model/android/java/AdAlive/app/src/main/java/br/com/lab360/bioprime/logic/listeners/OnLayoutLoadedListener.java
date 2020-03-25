package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.user.LayoutParam;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */
public interface OnLayoutLoadedListener {
    void onLayoutLoadError();
    void onLayoutLoadSuccess(LayoutParam params);
}
