package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.datasummary.DataSummary;


public interface OnDataSummaryListener {

    void onDataSummaryLoadSuccess(DataSummary dataSummary);

    void onDataSummaryLoadError(String message);
}
