package br.com.lab360.oneinternacional.logic.adalive;

import com.google.gson.annotations.SerializedName;

public class Action {
    @SerializedName("id")
    private int id;
    @SerializedName("action_type")
    private int actionType;
    @SerializedName("type")
    private String type;
    @SerializedName("name")
    private String name;
    @SerializedName("auto_launch")
    private Boolean autoLaunch;
    @SerializedName("label")
    private String label;
    @SerializedName("next_action_id")
    private int nextActionId;
    @SerializedName("campaign_id")
    private int campaignId;
    @SerializedName("start_date")
    private String startDate;
    @SerializedName("end_date")
    private String endDate;
    @SerializedName("enabled")
    private Boolean enabled;
    @SerializedName("href")
    private String href;
    @SerializedName("created_at")
    private String createdAt;
    @SerializedName("updated_at")
    private String updatedAt;
    @SerializedName("position")
    private int position;
    @SerializedName("metadata")
    private Metadata metadata;

    public Action() {
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getActionType() {
        return this.actionType;
    }

    public void setActionType(int actionType) {
        this.actionType = actionType;
    }

    public String getType() {
        return this.type == null ? "" : this.type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getName() {
        return this.name == null ? "" : this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Boolean getAutoLaunch() {
        return this.autoLaunch;
    }

    public void setAutoLaunch(Boolean autoLaunch) {
        this.autoLaunch = autoLaunch;
    }

    public String getLabel() {
        return this.label == null ? "" : this.label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getNextActionId() {
        return this.nextActionId;
    }

    public void setNextActionId(int nextActionId) {
        this.nextActionId = nextActionId;
    }

    public int getCampaignId() {
        return this.campaignId;
    }

    public void setCampaignId(int campaignId) {
        this.campaignId = campaignId;
    }

    public String getStartDate() {
        return this.startDate == null ? "" : this.startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return this.endDate == null ? "" : this.endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public Boolean getEnabled() {
        return this.enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    public String getHref() {
        return this.href == null ? "" : this.href;
    }

    public void setHref(String href) {
        this.href = href;
    }

    public String getCreatedAt() {
        return this.createdAt == null ? "" : this.createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return this.updatedAt == null ? "" : this.updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getPosition() {
        return this.position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public Metadata getMetadata() {
        return this.metadata == null ? new Metadata() : this.metadata;
    }

    public void setMetadata(Metadata metadata) {
        this.metadata = metadata;
    }
}
