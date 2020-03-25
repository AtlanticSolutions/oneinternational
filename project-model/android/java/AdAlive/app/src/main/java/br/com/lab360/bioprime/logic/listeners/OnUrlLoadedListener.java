package br.com.lab360.bioprime.logic.listeners;


import br.com.lab360.bioprime.logic.model.pojo.Url;

/**
 * Created by Edson on 07/06/2018.
 */

public interface OnUrlLoadedListener {
    void onUrlLoadError(Throwable e);
    void onUrlLoadSuccess(Url response);
}
