package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public class ChatUserGroup {
    @SerializedName("app_user_id")
    private int userId;

    @SerializedName("group_chat_id")
    private int groupId;

    public ChatUserGroup(int userId, int groupId) {
        this.userId = userId;
        this.groupId = groupId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }
}
