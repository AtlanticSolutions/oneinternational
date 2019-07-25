package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.listeners.OnCategoriesLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.category.Category;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import br.com.lab360.oneinternacional.utils.ExceptionUtils;
import br.com.lab360.oneinternacional.utils.NetworkStatsUtil;
import okhttp3.ResponseBody;
import retrofit2.adapter.rxjava.HttpException;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Edson on 19/04/2018.
 */

public class CategoriesInteractor extends BaseInteractor{

    public CategoriesInteractor(Context context) {
        super(context);
    }

    public void getCategories(String token, String limit, String offset, int typeCategory, final OnCategoriesLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.searchCategories(token, limit, offset, typeCategory)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ArrayList<Category>>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        if (!NetworkStatsUtil.isConnected(AdaliveApplication.getInstance().getBaseContext())) {
                            listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                        } else {
                            if (e instanceof HttpException) {
                                ResponseBody responseBody = ((HttpException) e).response().errorBody();
                                String error = ExceptionUtils.getErrorMessage(responseBody);
                                if (((HttpException) e).code() == 403){
                                    listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NOT_FOUND));
                                }else {
                                    listener.onCategoriesLoadError(error);
                                }
                            } else if (e instanceof SocketTimeoutException) {
                                listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                            } else if (e instanceof SocketTimeoutException) {
                                listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                            } else if (e instanceof IOException) {
                                listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                            } else {
                                listener.onCategoriesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_UNKNOWN));
                            }
                        }
                    }

                    @Override
                    public void onNext(ArrayList<Category> response) {
                        listener.onCategoriesLoadSuccess(response);

                    }
                });
    }

}
