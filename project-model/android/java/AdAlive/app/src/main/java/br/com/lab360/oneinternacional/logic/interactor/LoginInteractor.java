package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.listeners.Account.OnForgotPasswordListener;
import br.com.lab360.oneinternacional.logic.listeners.Account.OnLoginFinishedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.account.FacebookLoginRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.account.ForgotPasswordRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.account.LoginRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.StatusResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 */

public class LoginInteractor extends BaseInteractor {
    String mRole = null;

    public LoginInteractor(Context context) {
        super(context);
    }

    public void postLogin(LoginRequest request, final OnLoginFinishedListener listener, String role) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        mRole = role;

        adaliveApi.postLogin(request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .doOnNext(new Action1<User>() {
                    @Override
                    public void call(User loginResponse) {
                        if (loginResponse == null) {
                            throw new RuntimeException(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION));
                        }
                    }
                })
                .subscribe(new Subscriber<User>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        if (mRole != null) {
                            if (mRole.equalsIgnoreCase("reseller")) {
                                listener.onLoginError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION_RESELLER));
                            } else {
                                listener.onLoginError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION));
                            }
                        }
                    }

                    @Override
                    public void onNext(User loginResponse) {
                        listener.onLoginSuccess(loginResponse);

                    }
                });
    }

    public void signFacebookLogin(FacebookLoginRequest request, final OnLoginFinishedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.signFacebookLogin(request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .doOnNext(new Action1<User>() {
                    @Override
                    public void call(User loginResponse) {
                        if (loginResponse == null) {
                            throw new RuntimeException(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION));
                        }
                    }
                })
                .subscribe(new Subscriber<User>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onLoginError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION));

                    }

                    @Override
                    public void onNext(User loginResponse) {
                        listener.onLoginSuccess(loginResponse);

                    }
                });
    }

    public void postForgotPassword(ForgotPasswordRequest request, final OnForgotPasswordListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postForgotPassword(request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .doOnNext(new Action1<StatusResponse>() {
                    @Override
                    public void call(StatusResponse response) {
                        if (response == null) {
                            throw new RuntimeException(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                        }else if(response.hasErrors() != null
                                && response.hasErrors().getId() == 1005){
                            throw new RuntimeException(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_EMAIL_NOT_FOUND));
                        }
                    }
                })
                .subscribe(new Subscriber<StatusResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onForgotPassError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(StatusResponse response) {
                        listener.onForgotPasswordSuccess(response);
                    }
                });
    }
}