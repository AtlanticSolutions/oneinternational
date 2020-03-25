package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.listeners.OnNotificationLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class NotificationInteractor extends BaseInteractor {

    public NotificationInteractor(Context context) {
        super(context);
    }

    /**
     * Trazer os Grupos associados com o usuário
     */
    public void getNotifications(int appUser, final OnNotificationLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getNotifications(appUser)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<NotificationResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onNotificationLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(NotificationResponse response) {
                        listener.onNotificationLoadSuccess(response.getNotifications());

                    }
                });
    }

}
