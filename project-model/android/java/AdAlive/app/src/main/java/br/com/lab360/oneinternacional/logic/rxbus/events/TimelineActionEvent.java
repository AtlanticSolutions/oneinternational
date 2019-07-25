package br.com.lab360.oneinternacional.logic.rxbus.events;

import androidx.annotation.IntDef;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class TimelineActionEvent {

    private int action;
    private int position;

    public TimelineActionEvent(int action, int position) {
        this.action = action;
        this.position = position;
    }

    public int getAction() {
        return action;
    }

    public int getPosition() {
        return position;
    }

    @IntDef({TimelineAction.LIKE, TimelineAction.REPORT,TimelineAction.COMMENTS, TimelineAction.REMOVE
            , TimelineAction.SHARE})
    public @interface TimelineAction{
        int LIKE = 1;
        int COMMENTS = 2;
        int REPORT = 3;
        int REMOVE = 4;
        int SHARE = 5;
    }
}
