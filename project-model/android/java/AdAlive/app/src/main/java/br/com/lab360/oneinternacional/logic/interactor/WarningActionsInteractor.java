package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import br.com.lab360.oneinternacional.logic.listeners.OnWarningActionsListener;
import br.com.lab360.oneinternacional.logic.model.pojo.warningactions.WarningActionsResponse;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class WarningActionsInteractor extends BaseInteractor {

    public WarningActionsInteractor(Context context) {
        super(context);
    }

    public void retrieveAllWarningApp(String appVersion, String appId, final OnWarningActionsListener listener){

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.getWarningActions(appVersion,appId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<WarningActionsResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onWarningActionsLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(WarningActionsResponse warningActionsResponse) {
                        listener.onWarningActionsLoadSuccess(warningActionsResponse);

                    }
                });

    }

}
