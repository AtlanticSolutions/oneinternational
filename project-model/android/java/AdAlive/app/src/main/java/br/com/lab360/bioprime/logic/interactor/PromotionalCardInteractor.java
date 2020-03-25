package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import java.io.IOException;
import java.net.SocketTimeoutException;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.listeners.OnPromotionalCardLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.promotionalcard.Plist;
import br.com.lab360.bioprime.logic.rest.AmazonApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.utils.ExceptionUtils;
import br.com.lab360.bioprime.utils.NetworkStatsUtil;
import okhttp3.ResponseBody;
import retrofit2.adapter.rxjava.HttpException;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class PromotionalCardInteractor extends BaseInteractor {

    public PromotionalCardInteractor(Context context) {
        super(context);
    }

    public void getPromotionalCard(String cardName, final OnPromotionalCardLoadedListener listener) {
        AmazonApi amazonApi = ApiManager.getInstance().getAmazonApiInstance(context);

        amazonApi.getPromotionalCard(cardName)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Plist>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        if (!NetworkStatsUtil.isConnected(AdaliveApplication.getInstance().getBaseContext())) {
                            listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                        } else {
                            if (e instanceof HttpException) {
                                ResponseBody responseBody = ((HttpException) e).response().errorBody();
                                String error = ExceptionUtils.getErrorMessage(responseBody);
                                if (((HttpException) e).code() == 403){
                                    listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NOT_FOUND));
                                }else {
                                    listener.onPromotionalCardLoadError(error);
                                }
                            } else if (e instanceof SocketTimeoutException) {
                                listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                            } else if (e instanceof SocketTimeoutException) {
                                listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                            } else if (e instanceof IOException) {
                                listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                            } else {
                                listener.onPromotionalCardLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_UNKNOWN));
                            }
                        }
                    }

                    @Override
                    public void onNext(Plist response) {
                        listener.onPromotionalCardLoadSuccess(response);
                    }

                });
    }

}
