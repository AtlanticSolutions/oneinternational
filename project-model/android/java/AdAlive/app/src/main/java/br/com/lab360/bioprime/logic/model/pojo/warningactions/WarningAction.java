
package br.com.lab360.bioprime.logic.model.pojo.warningactions;

import com.google.gson.annotations.SerializedName;

public class WarningAction {
    
    @SerializedName("id")
    private int id;
    
    @SerializedName("app_version")
    private String appVersion;
    
    @SerializedName("app_message")
    private String appMessage;
    
    @SerializedName("plataform")
    private String plataform;
    
    @SerializedName("cmd_lock")
    private boolean cmdLock;
    
    @SerializedName("cmd_reset_all")
    private boolean cmdResetAll;
    
    @SerializedName("cmd_reset_db")
    private boolean cmdResetDb;
    
    @SerializedName("cmd_reset_defaults")
    private boolean cmdResetDefaults;
    
    @SerializedName("cmd_persistent_warning")
    private boolean cmdPersistentWarning;
    
    @SerializedName("cmd_basic_warning")
    private boolean cmdBasicWarning;
    
    @SerializedName("cmd_date")
    private String cmdDate;
    
    @SerializedName("external_addr")
    private String externalAddr;
    
    @SerializedName("is_enabled")
    private boolean isEnabled;
    
    @SerializedName("app_id")
    private int appId;
    
    @SerializedName("account_id")
    private int accountId;
    
    @SerializedName("created_at")
    private String createdAt;
    
    @SerializedName("updated_at")
    private String updatedAt;
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getAppVersion() {
        return appVersion;
    }
    
    public void setAppVersion(String appVersion) {
        this.appVersion = appVersion;
    }
    
    public String getAppMessage() {
        return appMessage;
    }
    
    public void setAppMessage(String appMessage) {
        this.appMessage = appMessage;
    }
    
    public String getPlataform() {
        return plataform;
    }
    
    public void setPlataform(String plataformIos) {
        this.plataform = plataformIos;
    }
    
    public boolean isCmdLock() {
        return cmdLock;
    }
    
    public void setCmdLock(boolean cmdLock) {
        this.cmdLock = cmdLock;
    }
    
    public boolean isCmdResetAll() {
        return cmdResetAll;
    }
    
    public void setCmdResetAll(boolean cmdResetAll) {
        this.cmdResetAll = cmdResetAll;
    }
    
    public boolean isCmdResetDb() {
        return cmdResetDb;
    }
    
    public void setCmdResetDb(boolean cmdResetDb) {
        this.cmdResetDb = cmdResetDb;
    }
    
    public boolean isCmdResetDefaults() {
        return cmdResetDefaults;
    }
    
    public void setCmdResetDefaults(boolean cmdResetDefaults) {
        this.cmdResetDefaults = cmdResetDefaults;
    }
    
    public boolean isCmdPersistentWarning() {
        return cmdPersistentWarning;
    }
    
    public void setCmdPersistentWarning(boolean cmdPersistentWarning) {
        this.cmdPersistentWarning = cmdPersistentWarning;
    }
    
    public boolean isCmdBasicWarning() {
        return cmdBasicWarning;
    }
    
    public void setCmdBasicWarning(boolean cmdBasicWarning) {
        this.cmdBasicWarning = cmdBasicWarning;
    }
    
    public String getCmdDate() {
        return cmdDate;
    }
    
    public void setCmdDate(String cmdDate) {
        this.cmdDate = cmdDate;
    }
    
    public String getExternalAddr() {
        return externalAddr;
    }
    
    public void setExternalAddr(String externalAddr) {
        this.externalAddr = externalAddr;
    }
    
    public boolean isIsEnabled() {
        return isEnabled;
    }
    
    public void setIsEnabled(boolean isEnabled) {
        this.isEnabled = isEnabled;
    }
    
    public int getAppId() {
        return appId;
    }
    
    public void setAppId(int appId) {
        this.appId = appId;
    }
    
    public int getAccountId() {
        return accountId;
    }
    
    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
    
}
