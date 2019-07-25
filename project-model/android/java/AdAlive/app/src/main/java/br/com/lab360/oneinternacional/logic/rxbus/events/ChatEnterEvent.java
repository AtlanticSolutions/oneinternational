package br.com.lab360.oneinternacional.logic.rxbus.events;

/**
 * Created by Alessandro Valenza on 08/12/2016.
 */

public class ChatEnterEvent {
    private int position;
    private boolean isGroup;
    private boolean isSpeaker;


    public ChatEnterEvent(int position, boolean isGroup, Boolean isSpeaker) {
        this.position = position;
        this.isGroup = isGroup;
        this.isSpeaker = isSpeaker;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public boolean isGroup() {
        return isGroup;
    }


    public boolean isSpeaker() {
        return isSpeaker;
    }

    public void setGroup(boolean group) {
        isGroup = group;
    }
}
