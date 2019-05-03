package br.com.lab360.oneinternacional.logic.rxbus.events;

/**
 * Created by Alessandro Valenza on 08/12/2016.
 */

public class SingleChatBlockEvent {
    private int position;

    public SingleChatBlockEvent(int position) {
        this.position = position;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

}
