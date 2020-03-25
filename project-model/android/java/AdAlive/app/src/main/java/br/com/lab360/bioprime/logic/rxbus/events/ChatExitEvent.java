package br.com.lab360.bioprime.logic.rxbus.events;

/**
 * Created by Alessandro Valenza on 08/12/2016.
 */

public class ChatExitEvent {
    private int position;
    private boolean isGroup;

    public ChatExitEvent(int position, boolean isGroup) {
        this.position = position;
        this.isGroup = isGroup;
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

    public void setIsGroup(boolean isGroup) {
        this.isGroup = isGroup;
    }
}
