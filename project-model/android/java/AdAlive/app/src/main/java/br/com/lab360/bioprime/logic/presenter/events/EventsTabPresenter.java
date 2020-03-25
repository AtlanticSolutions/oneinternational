package br.com.lab360.bioprime.logic.presenter.events;

import android.util.Log;

import java.util.ArrayList;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.interactor.EventsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnGetEventsListener;
import br.com.lab360.bioprime.logic.listeners.OnGetUserRegisteredEventsListener;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.EventChanged;
import br.com.lab360.bioprime.ui.view.IBaseView;
import rx.Observer;
import rx.Subscription;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class EventsTabPresenter implements IBasePresenter, OnGetEventsListener, OnGetUserRegisteredEventsListener {
    private final boolean showOnlyRegistered;
    private final int masterEventId;
    private IEventsTabView mView;
    private EventsInteractor mInteractor;
    private ArrayList<Event> mEvents;
    private Subscription eventChangeSubscription;

    public EventsTabPresenter(IEventsTabView view, boolean onlyRegistered) {
        this.mView = view;
        this.mInteractor = new EventsInteractor(mView.getContext());
        this.showOnlyRegistered = onlyRegistered;
        this.masterEventId = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();
        createSubscription();
        this.mView.setPresenter(this);
    }

    private void createSubscription() {
        eventChangeSubscription = AdaliveApplication.getBus().subscribe(RxQueues.USER_EVENT_CHANGED_QUEUE, new Observer<EventChanged>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(EventChanged eventChanged) {
                Log.e("TabPresenter", "onNext");
                Event event = eventChanged.getEvent();
                updateEvent(event);
            }
        });
    }

    private void updateEvent(Event updateEvent) {
        int updatedIndex = -1;
        for (int i = 0; i < mEvents.size(); i++){
            if(mEvents.get(i).getId() == updateEvent.getId()){
                updatedIndex = i;
            }
        }
        if(updatedIndex < 0){
            return;
        }

        mEvents.set(updatedIndex,updateEvent);
        mView.setupViewPager(mEvents,showOnlyRegistered);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.showProgress();
        mInteractor.getEvents(masterEventId,this);
    }

    private void setEventsRegistered(ArrayList<Integer> eventIds) {
        for(Event event : mEvents){
            if(eventIds.contains(event.getId())){
                event.setRegistered(true);
            }
        }
    }


    private void removeUnregisteredEvents() {
        for(Event event : (ArrayList<Event>)mEvents.clone()){
            if(!event.isRegistered()){
                mEvents.remove(event);
            }
        }
    }

    //region OnGetEventsListener
    @Override
    public void onEventsLoadSuccess(ArrayList<Event> events) {
        this.mEvents = events;
        int userId = AdaliveApplication.getInstance().getUser().getId();
        mInteractor.getUserRegisteredEvents(masterEventId,userId,this);
    }

    @Override
    public void onEventsLoadError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }
    //endregion

    //region OnGetUserRegisteredEventsListener
    @Override
    public void onGetUserRegisteredEventsSuccess(ArrayList<Integer> eventIds) {
        setEventsRegistered(eventIds);

        if(showOnlyRegistered){
            removeUnregisteredEvents();
        }
        mView.setupViewPager(mEvents,showOnlyRegistered);
        mView.setupTabLayout();

        mView.hideProgress();
        mView.showTabLayout();
        mView.showViewPager();
    }

    @Override
    public void onGetUserRegisteredEventsError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }
    //endregion

    public interface IEventsTabView extends IBaseView {

        void initToolbar();

        void setPresenter(EventsTabPresenter eventsTabPresenter);

        void setupTabLayout();

        void setupViewPager(ArrayList<Event> events, boolean showOnlyRegistered);

        void showTabLayout();

        void showViewPager();

    }
}