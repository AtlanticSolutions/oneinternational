package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.MasterServerResponse;

/**
 * Created by Paulo Roberto on 03/08/2017.
 */
public interface OnMasterServerDataLoadedListener {
    void onMasterServerDataLoadError();
    void onMasterServerDataLoadSuccess(MasterServerResponse params);
}
