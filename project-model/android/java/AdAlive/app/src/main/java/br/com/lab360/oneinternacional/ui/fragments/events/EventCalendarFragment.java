package br.com.lab360.oneinternacional.ui.fragments.events;


import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.OvershootInterpolator;

import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.MaterialCalendarView;
import com.prolificinteractive.materialcalendarview.OnDateSelectedListener;

import java.util.ArrayList;
import java.util.Calendar;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.user.Event;
import br.com.lab360.oneinternacional.logic.presenter.events.EventsCalendarPresenter;
import br.com.lab360.oneinternacional.ui.activity.events.EventDetailActivity;
import br.com.lab360.oneinternacional.ui.adapters.events.EventCalendarListAdapter;
import br.com.lab360.oneinternacional.ui.decorator.CalendarDayDecorator;
import br.com.lab360.oneinternacional.utils.DateUtils;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import butterknife.BindView;
import butterknife.ButterKnife;
import jp.wasabeef.recyclerview.animators.SlideInUpAnimator;


public class EventCalendarFragment extends Fragment implements EventsCalendarPresenter.IEventsCalendarView {

    private static final String ARG_PARAM1 = "events";
    private static final String ARG_PARAM2 = "showOnlyRegistered";
    @BindView(R.id.calendar_view)
    MaterialCalendarView calendarView;
    @BindView(R.id.recyclerview_events)
    RecyclerView recyclerEvents;

    private ArrayList<Event> events;
    private EventsCalendarPresenter mPresenter;

    private ArrayList<Event> eventsBySelectedDate;
    private boolean showOnlyRegistered;

    public EventCalendarFragment() {
        // Required empty public constructor
    }

    public static EventCalendarFragment newInstance(ArrayList<Event> events, boolean showOnlyRegistered) {
        EventCalendarFragment fragment = new EventCalendarFragment();
        Bundle args = new Bundle();
        args.putParcelableArrayList(ARG_PARAM1, events);
        args.putBoolean(ARG_PARAM2, showOnlyRegistered);
        fragment.setArguments(args);
        return fragment;
    }

    //region Android Lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            events = getArguments().getParcelableArrayList(ARG_PARAM1);
            showOnlyRegistered = getArguments().getBoolean(ARG_PARAM2);
        }
        new EventsCalendarPresenter(this, events, showOnlyRegistered);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_event_calendar, container, false);
        ButterKnife.bind(this, view);

        mPresenter.start();
        return view;
    }
    //endregion

    //region IEventsCalendarView
    @Override
    public void setPresenter(EventsCalendarPresenter presenter) {
        this.mPresenter = presenter;
    }

    @Override
    public void setupRecyclerView() {
        eventsBySelectedDate = new ArrayList<>();
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        linearLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        recyclerEvents.setLayoutManager(linearLayoutManager);
        recyclerEvents.setHasFixedSize(true);
        recyclerEvents.setNestedScrollingEnabled(false);
        recyclerEvents.setItemAnimator(new SlideInUpAnimator(new OvershootInterpolator(1f)));
        EventCalendarListAdapter adapter = new EventCalendarListAdapter(eventsBySelectedDate, getActivity());
        recyclerEvents.setAdapter(adapter);

        recyclerEvents.addOnItemTouchListener(new RecyclerItemClickListener(getActivity(), recyclerEvents,
                new RecyclerItemClickListener.OnItemClickListener() {
                    @Override
                    public void onItemClick(View view, int position) {
                        mPresenter.onEventTouched(position, eventsBySelectedDate);
                    }

                    @Override
                    public void onItemLongClick(View view, int position) {
                    }
                }));

    }

    @Override
    public void setupCalendar(final ArrayList<Event> mEvents) {
        ArrayList<Integer> daysRegistered = new ArrayList<>();
        ArrayList<Event> eventsClone = (ArrayList<Event>) mEvents.clone();
        for (final Event event : mEvents) {
            Calendar calendar = DateUtils.dateEventToCalendar(event.getSchedule());
            final CalendarDay day = CalendarDay.from(calendar);

            if (event.isRegistered()) {
                calendarView.addDecorator(new CalendarDayDecorator(day,
                        ContextCompat.getDrawable(getActivity(), R.drawable.background_registred_calendar)));
                daysRegistered.add(day.getDay());
                eventsClone.remove(event);
            }
        }

        for (final Event event : eventsClone) {
            Calendar calendar = DateUtils.dateEventToCalendar(event.getSchedule());
            final CalendarDay day = CalendarDay.from(calendar);

            if (!daysRegistered.contains(day.getDay())) {
                calendarView.addDecorator(new CalendarDayDecorator(day,
                        ContextCompat.getDrawable(getActivity(), R.drawable.background_signup_calendar)));
            }
        }

        //Today yellow
        calendarView.addDecorator(new CalendarDayDecorator(CalendarDay.today(),
                ContextCompat.getDrawable(getActivity(), R.drawable.background_today_calendar)));

        calendarView.setOnDateChangedListener(new OnDateSelectedListener() {
            @Override
            public void onDateSelected(@NonNull MaterialCalendarView widget, @NonNull CalendarDay date, boolean selected) {
                if (selected) {
                    Calendar calendarSelected = date.getCalendar();
                    mPresenter.onDateSelected(calendarSelected);
                }
            }
        });
    }

    @Override
    public void showRecyclerView() {
        recyclerEvents.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideRecyclerView() {
        recyclerEvents.setVisibility(View.GONE);
    }

    @Override
    public void populateRecyclerView(ArrayList<Event> eventsBySelectedDate) {
        ((EventCalendarListAdapter) recyclerEvents.getAdapter()).addAll(eventsBySelectedDate);
    }

    @Override
    public void navigateToEventDetailsActivity(Event event, boolean showOnlyRegistered) {
        Intent intent = new Intent(getActivity(), EventDetailActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_EVENT, event);
        intent.putExtra(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED, showOnlyRegistered);
        startActivity(intent);
    }

    @Override
    public void removeCalendarDecorations() {
        calendarView.removeDecorators();
    }

    @Override
    public void recreateDecoration(Calendar calendarSelected, final ArrayList<Event> mEvents) {
        ArrayList<Integer> daysRegistered = new ArrayList<>();
        ArrayList<Event> eventsClone = (ArrayList<Event>) mEvents.clone();
        calendarView.invalidateDecorators();
        final CalendarDay selectedDate = CalendarDay.from(calendarSelected);
        for (final Event event : mEvents) {
            Calendar calendar = DateUtils.dateEventToCalendar(event.getSchedule());
            final CalendarDay day = CalendarDay.from(calendar);

            if (selectedDate.getDay() != day.getDay() && event.isRegistered()) {
                calendarView.addDecorator(new CalendarDayDecorator(day,
                        ContextCompat.getDrawable(getActivity(), R.drawable.background_registred_calendar)));
                daysRegistered.add(day.getDay());
                eventsClone.remove(event);
            }else if(event.isRegistered()){
                daysRegistered.add(day.getDay());
                eventsClone.remove(event);
            }
        }

        for (final Event event : eventsClone) {
            Calendar calendar = DateUtils.dateEventToCalendar(event.getSchedule());
            final CalendarDay day = CalendarDay.from(calendar);

            if (!daysRegistered.contains(day.getDay())) {
                calendarView.addDecorator(new CalendarDayDecorator(day,
                        ContextCompat.getDrawable(getActivity(), R.drawable.background_signup_calendar)));
            }
        }


        if (selectedDate.getDay() != CalendarDay.today().getDay()) {
            //Today yellow
            calendarView.addDecorator(new CalendarDayDecorator(CalendarDay.today(),
                    ContextCompat.getDrawable(getActivity(), R.drawable.background_today_calendar)));
        }

        calendarView.setOnDateChangedListener(new OnDateSelectedListener() {
            @Override
            public void onDateSelected(@NonNull MaterialCalendarView widget, @NonNull CalendarDay date, boolean selected) {
                if (selected) {
                    Calendar calendarSelected = date.getCalendar();
                    mPresenter.onDateSelected(calendarSelected);
                }
            }
        });

        calendarView.invalidateDecorators();
    }
    //endregion

}
