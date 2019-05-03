package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.datasummary.DataSummary;


public interface OnDataSummaryListener {

    void onDataSummaryLoadSuccess(DataSummary dataSummary);

    void onDataSummaryLoadError(String message);
}
