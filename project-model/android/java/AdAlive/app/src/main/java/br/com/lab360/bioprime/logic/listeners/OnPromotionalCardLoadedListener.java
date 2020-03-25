package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.promotionalcard.Plist;

public interface OnPromotionalCardLoadedListener {
    void onPromotionalCardLoadSuccess(Plist response);
    void onPromotionalCardLoadError(String message);
}
