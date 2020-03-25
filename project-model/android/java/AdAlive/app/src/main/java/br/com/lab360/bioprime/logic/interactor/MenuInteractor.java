package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.listeners.OnMenuLoadedListener;
import br.com.lab360.bioprime.logic.listeners.OnUrlLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.Url;
import br.com.lab360.bioprime.logic.model.pojo.menu.MenuResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Edson on 07/06/2018.
 */

public class MenuInteractor extends BaseInteractor {

    public MenuInteractor(Context context) {
        super(context);
    }

    public void getMenu(int appId, final OnMenuLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getMenu(appId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<MenuResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onMenuLoadError(e);
                    }

                    @Override
                    public void onNext(MenuResponse response) {
                        listener.onMenuLoadSuccess(response);
                    }

                });
    }

    public void getUrl(String url, final OnUrlLoadedListener listener, String token) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getUrlMagento(token, url)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Url>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUrlLoadError(e);
                    }

                    @Override
                    public void onNext(Url response) {
                        listener.onUrlLoadSuccess(response);
                    }

                });
    }
}
