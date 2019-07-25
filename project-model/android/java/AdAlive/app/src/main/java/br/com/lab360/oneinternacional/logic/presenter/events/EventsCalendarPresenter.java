package br.com.lab360.oneinternacional.logic.presenter.events;

import java.util.ArrayList;
import java.util.Calendar;

import br.com.lab360.oneinternacional.logic.model.pojo.user.Event;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.utils.DateUtils;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class EventsCalendarPresenter implements IBasePresenter {
    private final ArrayList<Event> mEvents;
    private final boolean showOnlyRegistered;
    private IEventsCalendarView mView;

    public EventsCalendarPresenter(IEventsCalendarView view, ArrayList<Event> events, boolean showOnlyRegistered) {
        this.mView = view;
        this.mEvents = events;
        this.showOnlyRegistered = showOnlyRegistered;
        this.mView.setPresenter(this);
    }

    //region Public methods
    @Override
    public void start() {
        mView.setupRecyclerView();
        mView.removeCalendarDecorations();
        mView.setupCalendar((ArrayList<Event>) mEvents.clone());
    }


    public void onEventTouched(int position, ArrayList<Event> eventsBySelectedDate) {
        mView.navigateToEventDetailsActivity(eventsBySelectedDate.get(position),showOnlyRegistered);
    }

    public void onDateSelected(Calendar calendarSelected) {
        mView.removeCalendarDecorations();
        mView.recreateDecoration(calendarSelected, mEvents);

        ArrayList<Event> eventsBySelectedDate = new ArrayList<>();
        for (final Event event : mEvents) {
            Calendar calendarEvent = DateUtils.dateEventToCalendar(event.getSchedule());
            final boolean sameDay = calendarSelected.get(Calendar.YEAR) == calendarEvent.get(Calendar.YEAR) &&
                    calendarSelected.get(Calendar.DAY_OF_YEAR) == calendarEvent.get(Calendar.DAY_OF_YEAR);

            if (sameDay) {
                eventsBySelectedDate.add(event);
            }
        }
        if(eventsBySelectedDate.size() > 0){
            mView.showRecyclerView();
            mView.populateRecyclerView(eventsBySelectedDate);
            return;
        }
        mView.hideRecyclerView();
    }
    //endregion

    public interface IEventsCalendarView {

        void setPresenter(EventsCalendarPresenter presenter);

        void setupRecyclerView();

        void setupCalendar(ArrayList<Event> mEvents);

        void showRecyclerView();

        void hideRecyclerView();

        void populateRecyclerView(ArrayList<Event> eventsBySelectedDate);

        void navigateToEventDetailsActivity(Event event, boolean showOnlyRegistered);

        void removeCalendarDecorations();

        void recreateDecoration(Calendar calendarSelected, final ArrayList<Event> mEvents);
    }
}