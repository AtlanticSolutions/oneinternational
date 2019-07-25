package br.com.lab360.oneinternacional.logic.rxbus.events;

/**
 * Created by thiagofaria on 25/01/17.
 */
public class SponsorTitleEvent {

    private String title;

    public SponsorTitleEvent(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }
}
