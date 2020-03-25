package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.listeners.OnEventFilesLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnGetEventsListener;
import br.com.lab360.bioprime.logic.listeners.OnGetUserRegisteredEventsListener;
import br.com.lab360.bioprime.logic.listeners.OnUserRegisteredToEventListener;
import br.com.lab360.bioprime.logic.listeners.OnUserUnregisteredToEventListener;
import br.com.lab360.bioprime.logic.model.pojo.EventsResponse;
import br.com.lab360.bioprime.logic.model.pojo.RegisterEventResponse;
import br.com.lab360.bioprime.logic.model.pojo.RegisterUserEventRequest;
import br.com.lab360.bioprime.logic.model.pojo.download.EventFilesResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */

public class EventsInteractor extends BaseInteractor {

    public EventsInteractor(Context context) {
        super(context);
    }

    public void getEvents(int masterEventId, final OnGetEventsListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getEvents(masterEventId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<EventsResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onEventsLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(EventsResponse eventResponse) {
                        if(eventResponse == null)
                            eventResponse = new EventsResponse();
                        listener.onEventsLoadSuccess(eventResponse.getEvents());
                    }
                });
    }

    public void registerUserToEvent(int masterEventId, int eventId, int userId, final OnUserRegisteredToEventListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postRegisterUserToEvent(masterEventId,new RegisterUserEventRequest(userId,eventId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<RegisterEventResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onRegisterError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(RegisterEventResponse eventResponse) {
                        listener.onRegisterSuccess(eventResponse.getEvents());
                    }
                });
    }

    public void unregisterUserEvent(int masterEventId, int eventId, int userId, final OnUserUnregisteredToEventListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postUnregisterUserToEvent(masterEventId, new RegisterUserEventRequest(userId,eventId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<RegisterEventResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUnregisterError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(RegisterEventResponse eventResponse) {
                        listener.onUnregisterSuccess(eventResponse.getEvents());
                    }
                });
    }

    public void getUserRegisteredEvents(int masterEventId, int userId, final OnGetUserRegisteredEventsListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getUserRegisteredEvents(masterEventId, userId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<RegisterEventResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetUserRegisteredEventsError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(RegisterEventResponse eventResponse) {
                        listener.onGetUserRegisteredEventsSuccess(eventResponse.getEvents());
                    }
                });
    }

    public void getEventsFiles(int masterEventId, int eventId, final OnEventFilesLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getEventFiles(masterEventId, eventId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<EventFilesResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onEventFilesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(EventFilesResponse eventResponse) {
                        listener.onEventFilesLoadSucess(eventResponse.getEventFiles());
                    }
                });
    }
}
