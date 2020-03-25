package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import java.io.IOException;
import java.net.SocketTimeoutException;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.listeners.Account.OnCreateAccountListener;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.model.pojo.account.CreateAccountRequest;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.utils.ExceptionUtils;
import br.com.lab360.bioprime.utils.NetworkStatsUtil;
import okhttp3.ResponseBody;
import retrofit2.adapter.rxjava.HttpException;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */

public class SignupInteractor extends BaseInteractor{

    public SignupInteractor(Context context) {
        super(context);
    }

    public void postCreateAccount(final CreateAccountRequest request, final OnCreateAccountListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.postCreateAccount(request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<User>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        if (!NetworkStatsUtil.isConnected(AdaliveApplication.getInstance().getBaseContext())) {
                            listener.onCreateAccountError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                        } else {
                            if (e instanceof HttpException) {
                                ResponseBody responseBody = ((HttpException) e).response().errorBody();
                                String error = ExceptionUtils.getErrorMessage(responseBody);
                                listener.onCreateAccountError(error);
                            } else if (e instanceof SocketTimeoutException) {
                                listener.onCreateAccountError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                            } else if (e instanceof IOException) {
                                listener.onCreateAccountError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NO_CONNECTION));
                            } else {
                                listener.onCreateAccountError(e.getMessage());
                            }
                        }
                    }

                    @Override
                    public void onNext(User response) {
                        if(!response.isSuccess() && response.getMessage() != null){
                            listener.onCreateAccountError(response.getMessage());
                            return;
                        }

                        //Return request (instead of response) to use user credentials (email and password) to login attempt before signup
                        listener.onCreateAccountSuccess(request.getUser());


                    }
                });
    }
}
