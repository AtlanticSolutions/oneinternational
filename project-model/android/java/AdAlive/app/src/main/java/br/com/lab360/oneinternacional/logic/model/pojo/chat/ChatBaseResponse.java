package br.com.lab360.oneinternacional.logic.model.pojo.chat;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public class ChatBaseResponse {
    private String status;
    private String errorType;
    private ArrayList<EventMessage> messages;
    private EventMessage message;
    private EventMessage singleMessage;
    private transient int position;

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getErrorType() {
        return errorType;
    }

    public void setErrorType(String errorType) {
        this.errorType = errorType;
    }

    public ArrayList<EventMessage> getMessages() {
        return messages;
    }

    public void setMessages(ArrayList<EventMessage> messages) {
        this.messages = messages;
    }

    public EventMessage getMessage() {
        return message;
    }

    public void setMessage(EventMessage message) {
        this.message = message;
    }

    public EventMessage getSingleMessage() {
        return singleMessage;
    }

    public void setSingleMessage(EventMessage singleMessage) {
        this.singleMessage = singleMessage;
    }
}
