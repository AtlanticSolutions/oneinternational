
package br.com.lab360.bioprime.logic.model.pojo.warningactions;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class WarningActionsResponse {
    
    @SerializedName("configs")
    private List<WarningAction> configs = null;
    
    public List<WarningAction> getConfigs() {
        return configs;
    }
    
    public void setConfigs(List<WarningAction> configs) {
        this.configs = configs;
    }
    
}
