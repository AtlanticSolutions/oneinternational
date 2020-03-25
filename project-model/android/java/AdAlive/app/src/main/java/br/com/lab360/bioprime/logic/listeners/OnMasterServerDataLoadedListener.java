package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.MasterServerResponse;

/**
 * Created by Paulo Roberto on 03/08/2017.
 */
public interface OnMasterServerDataLoadedListener {
    void onMasterServerDataLoadError();
    void onMasterServerDataLoadSuccess(MasterServerResponse params);
}
