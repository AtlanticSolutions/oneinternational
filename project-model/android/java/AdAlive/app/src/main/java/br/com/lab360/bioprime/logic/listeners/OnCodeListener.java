package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.CodeParam;

/**
 * Created by thiagofaria on 17/01/17.
 */

public interface OnCodeListener {

    void onCodeError();
    void onCodeSuccess(CodeParam code);
}
