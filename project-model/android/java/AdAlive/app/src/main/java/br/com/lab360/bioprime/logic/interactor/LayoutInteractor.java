package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;
import android.util.Log;

import br.com.lab360.bioprime.logic.listeners.OnLayoutLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.layout.LayoutConfigResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import lib.utils.ConstantsAdAlive;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */

public class LayoutInteractor extends BaseInteractor {

    public LayoutInteractor(Context context) {
        super(context);
    }

    public void getLayoutParams(int appId, final OnLayoutLoadedListener listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getLayoutParams(appId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<LayoutConfigResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.v(ConstantsAdAlive.TAG_LOG_ERROR_LOG, e.getMessage());
                        listener.onLayoutLoadError();
                    }

                    @Override
                    public void onNext(LayoutConfigResponse layoutResponse) {
                        listener.onLayoutLoadSuccess(layoutResponse.getParams());
                    }

                });
    }


}
