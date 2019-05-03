package br.com.lab360.oneinternacional.logic.model.pojo.datasummary;

import com.google.gson.annotations.SerializedName;

public class DataSummaryResponse {

    @SerializedName("data_in_app")
    private DataSummary dataSummary;

    public DataSummary getDataSummary() {
        return dataSummary;
    }
}
