package br.com.lab360.oneinternacional.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class FindGroupMessagesRequest extends ChatBaseRequest{
    private int groupId, total;

    public FindGroupMessagesRequest(int accountId, int groupId, int total) {
        super("findGroupMessages", accountId);
        this.groupId = groupId;
        this.total = total;
    }
}
