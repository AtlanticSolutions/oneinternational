package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseResponse;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public interface OnShowCaseListener {
    void onShowCaseLoadSuccess(ShowCaseResponse response);

    void onShowCaseLoadError(String error);
}
