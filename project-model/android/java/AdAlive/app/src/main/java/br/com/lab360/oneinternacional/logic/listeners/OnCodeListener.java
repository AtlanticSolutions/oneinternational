package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.CodeParam;

/**
 * Created by thiagofaria on 17/01/17.
 */

public interface OnCodeListener {

    void onCodeError();
    void onCodeSuccess(CodeParam code);
}
