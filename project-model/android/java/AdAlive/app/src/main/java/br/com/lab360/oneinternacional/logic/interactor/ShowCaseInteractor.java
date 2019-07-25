package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import br.com.lab360.oneinternacional.logic.listeners.OnShowCaseListener;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseResponse;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.SingleSubscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class ShowCaseInteractor extends BaseInteractor {

    public ShowCaseInteractor(Context context) {
        super(context);
    }

    public void getShowcaseItems(final OnShowCaseListener listener) {
        ApiManager.getInstance().getAdaliveApiInstance(context).getShowcaseItems()
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new SingleSubscriber<ShowCaseResponse>() {
                    @Override
                    public void onSuccess(ShowCaseResponse showCaseResponse) {
                        listener.onShowCaseLoadSuccess(showCaseResponse);
                    }

                    @Override
                    public void onError(Throwable error) {
                        listener.onShowCaseLoadError(error.getLocalizedMessage());
                    }
                });
    }
}
