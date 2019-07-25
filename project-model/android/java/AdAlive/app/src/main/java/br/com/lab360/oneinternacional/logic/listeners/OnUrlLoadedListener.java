package br.com.lab360.oneinternacional.logic.listeners;


import br.com.lab360.oneinternacional.logic.model.pojo.Url;

/**
 * Created by Edson on 07/06/2018.
 */

public interface OnUrlLoadedListener {
    void onUrlLoadError(Throwable e);
    void onUrlLoadSuccess(Url response);
}
