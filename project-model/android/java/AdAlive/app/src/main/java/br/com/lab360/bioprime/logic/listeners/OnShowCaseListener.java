package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseResponse;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public interface OnShowCaseListener {
    void onShowCaseLoadSuccess(ShowCaseResponse response);

    void onShowCaseLoadError(String error);
}
