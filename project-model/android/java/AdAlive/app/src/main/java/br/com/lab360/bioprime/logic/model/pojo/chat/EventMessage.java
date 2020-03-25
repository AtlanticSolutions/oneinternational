package br.com.lab360.bioprime.logic.model.pojo.chat;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */

public class EventMessage {

    private int accountId;
    private int groupChatId;
    private int id;
    private int senderId;
    private int receiverId;
    private String groupName;
    private String senderName;
    private String message;
    private long sendDate;
    private long sendDateMilli;

    private transient boolean error;
    private transient boolean section;
    private transient int position;

    public EventMessage() {
    }

    public EventMessage(int senderId, String message, String senderName) {
        this.id = senderId;
        //this.senderId = senderId;
        this.message = message;
        this.senderName = senderName;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getGroupChatId() {
        return groupChatId;
    }

    public void setGroupChatId(int groupChatId) {
        this.groupChatId = groupChatId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public long getSendDate() {
        return sendDate;
    }

    public void setSendDate(long sendDate) {
        this.sendDate = sendDate;
    }

    public boolean hasError() {
        return error;
    }

    public void setError(boolean error) {
        this.error = error;
    }

    public boolean isSection() {
        return section;
    }

    public void setSection(boolean section) {
        this.section = section;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public String getSendDateMilli() {
        if(sendDateMilli <= 0){
            return "";
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        return sdf.format(new Date(sendDateMilli));
    }

    public void setSendDateMilli(String sendDateMilli) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        try {
            this.sendDate = sdf.parse(sendDateMilli).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    public String getDate() {
        if(sendDate <= 0){
            return "";
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        return sdf.format(new Date(sendDate));
    }

    public void setDate(String date) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        try {
            this.sendDate = sdf.parse(date).getTime();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
