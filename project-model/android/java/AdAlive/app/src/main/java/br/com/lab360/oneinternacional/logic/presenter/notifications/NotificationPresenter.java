package br.com.lab360.oneinternacional.logic.presenter.notifications;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.interactor.NotificationInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnNotificationLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;


public class NotificationPresenter implements IBasePresenter, OnNotificationLoadedListener {
    private final NotificationInteractor mInteractor;
    private INotificationListView mView;
    private ArrayList<NotificationObject> mItems;


    public NotificationPresenter(INotificationListView view) {
        this.mView = view;
        this.mInteractor = new NotificationInteractor(mView.getContext());
        this.mItems = new ArrayList<>();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();

        mView.setupRecyclerView();
        mView.showProgress();

        int userId = AdaliveApplication.getInstance().getUser().getId();
        mInteractor.getNotifications(userId, this);

    }


    public NotificationObject getNotification(int position){
        return this.mItems.get(position);
    }


    @Override
    public void onNotificationLoadSuccess(ArrayList<NotificationObject> participants) {

//        if (this.mItems.size() == 0){
//            mView.sho
//            return;
//        }

        this.mItems.addAll(participants);

        mView.hideProgress();
        mView.updateList(participants);
    }

    @Override
    public void onNotificationLoadError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);

    }
    //endregion

    public interface INotificationListView extends IBaseView {
        void initToolbar();

        void setPresenter(NotificationPresenter presenter);

        void setupRecyclerView();

        void updateList(ArrayList<NotificationObject> mfilteredList);

        void updateItem(int mSelectedPosition);
    }
}