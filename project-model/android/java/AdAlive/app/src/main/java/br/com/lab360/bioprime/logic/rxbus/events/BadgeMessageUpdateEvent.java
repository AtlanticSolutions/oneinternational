package br.com.lab360.bioprime.logic.rxbus.events;

/**
 * Created by thiagofaria on 25/01/17.
 */
public class BadgeMessageUpdateEvent {

    private int total;

    public BadgeMessageUpdateEvent(int total) {
        this.total = total;
    }

    public int getTotalMessage() {
        return total;
    }
}
