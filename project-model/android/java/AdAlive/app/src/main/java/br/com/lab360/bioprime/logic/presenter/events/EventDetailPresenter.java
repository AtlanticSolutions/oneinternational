package br.com.lab360.bioprime.logic.presenter.events;

import android.graphics.Bitmap;

import java.util.ArrayList;
import java.util.Locale;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.interactor.EventsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnUserRegisteredToEventListener;
import br.com.lab360.bioprime.logic.listeners.OnUserUnregisteredToEventListener;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.EventChanged;
import br.com.lab360.bioprime.ui.view.IBaseView;
import br.com.lab360.bioprime.utils.DateUtils;

/**
 * Created by Alessandro Valenza on 29/11/2016.
 */
public class EventDetailPresenter implements IBasePresenter, OnUserRegisteredToEventListener, OnUserUnregisteredToEventListener {
    private final EventsInteractor mInteractor;
    private final Event mEvent;
    private final boolean showOnlyRegistered;
    private IEventDetailView mView;
    private int masterEventId;

    public EventDetailPresenter(IEventDetailView view, Event event, boolean showOnlyRegistered) {
        this.mView = view;
        this.mInteractor = new EventsInteractor(mView.getContext());
        this.mEvent = event;
        this.showOnlyRegistered = showOnlyRegistered;
        this.masterEventId = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar(mEvent.getName());

        String formatedDateHour;
        String hour = DateUtils.formatAdAliveDate(mEvent.getSchedule(), "HH:mm");
        String language = Locale.getDefault().getDisplayLanguage();

        if (language.contains("português")) {

            formatedDateHour = DateUtils.formatAdAliveDate(mEvent.getSchedule(), "dd/MM/yy") +
                    " às " + hour;

        } else {

            formatedDateHour = DateUtils.formatAdAliveDate(mEvent.getSchedule(), "MM/dd/yy") +
                    " at " + hour;

        }

        mView.populateFields(mEvent.getName(),
                mEvent.getDescription(),
                formatedDateHour,
                mEvent.getLocal(),
                mEvent.getSpeackerDetails(),
                mEvent.getEventImage(),
                mEvent.getSpeackerName());

        if(mEvent.isRegistered()){
            mView.hideRegisterButton();
            return;
        }

        mView.hideUnregisterButton();
    }

    public void onBtnSubscribeTouched() {
        mView.showProgress();
        int userId = AdaliveApplication.getInstance().getUser().getId();
        int eventId = mEvent.getId();
        mInteractor.registerUserToEvent(masterEventId, eventId, userId, this);
    }

    public void onBtnUnsubscribeTouched() {
        mView.showProgress();
        int userId = AdaliveApplication.getInstance().getUser().getId();
        int eventId = mEvent.getId();
        mInteractor.unregisterUserEvent(masterEventId, eventId, userId, this);
    }

    public void onBtnDownloadTouched() {
        mView.navigateToEventDowloadListActivity(mEvent);
    }

    private void notificateEventStatusChange(Event event) {
        AdaliveApplication.getBus().publish(RxQueues.USER_EVENT_CHANGED_QUEUE, new EventChanged(event));
    }

    //region OnUserRegisteredToEventListener
    @Override
    public void onRegisterError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }

    /**
     * Receive callback from register user to event request
     * @param events - registered events' ids
     */
    @Override
    public void onRegisterSuccess(ArrayList<Integer> events) {
        mEvent.setRegistered(true);
        mView.showUnregisterButton();
        mView.hideRegisterButton();
        notificateEventStatusChange(mEvent);
        mView.hideProgress();
        mView.showRegisterSuccessDialog(mEvent.getName());

    }
    //endregion

    //region OnUserUnregisteredToEventListener
    /**
     * Receive callback from unregister user from event request
     * @param events - registered events' ids
     */
    @Override
    public void onUnregisterSuccess(ArrayList<Integer> events) {
        mEvent.setRegistered(false);
        notificateEventStatusChange(mEvent);
        mView.showRegisterButton();
        mView.hideUnregisterButton();
        mView.hideProgress();
        mView.showUnregisterSuccessDialog(mEvent.getName());
    }

    @Override
    public void onUnregisterError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }
    //endregion

    public interface IEventDetailView extends IBaseView {

        void setPresenter(EventDetailPresenter eventDetailPresenter);

        void initToolbar(String name);

        void populateFields(String name, String description, String schedule, String local, String speakerDetails, String eventImage, String speakerName);

        void showUnregisterButton();

        void hideUnregisterButton();

        void showRegisterButton();

        void hideRegisterButton();

        void showRegisterSuccessDialog(String eventTitle);

        void showUnregisterSuccessDialog(String eventTitle);

        void navigateToEventDowloadListActivity(Event mEvent);

        void setImageSpeaker(Bitmap image);

        void setEventDetails(String details);
    }
}