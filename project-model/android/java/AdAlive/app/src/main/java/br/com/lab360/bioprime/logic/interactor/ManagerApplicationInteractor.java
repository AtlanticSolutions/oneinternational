package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.listeners.OnManagerApplicationLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplicationResponse;
import br.com.lab360.bioprime.logic.rest.AmazonApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Edson on 28/06/2018.
 */

public class ManagerApplicationInteractor extends BaseInteractor {

    public ManagerApplicationInteractor(Context context) {
        super(context);
    }

    public void getManagerApplication(final OnManagerApplicationLoadedListener listener) {

        AmazonApi amazonApi = ApiManager.getInstance().getAmazonApiInstance(context);

        amazonApi.getManagerApplication()
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ManagerApplicationResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onManagerApplicationLoadError(e);
                    }

                    @Override
                    public void onNext(ManagerApplicationResponse response) {
                        listener.onManagerApplicationLoadSuccess(response);
                    }

                });
    }
}
