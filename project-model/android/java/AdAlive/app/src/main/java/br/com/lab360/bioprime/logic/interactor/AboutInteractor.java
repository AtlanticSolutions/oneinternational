package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.model.pojo.about.About;
import br.com.lab360.bioprime.logic.model.pojo.about.AboutResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class AboutInteractor extends BaseInteractor {

    public AboutInteractor(Context context) {
        super(context);
    }

    public interface AboutInteractorListener {
        void onAboutSuccess(About about);
        void onAboutFailure();
    }

    public void getAbout(int appId, final AboutInteractorListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getAccountAbouts(appId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<AboutResponse>() {
                    @Override
                    public void onCompleted() {}

                    @Override
                    public void onError(Throwable e) {
                        listener.onAboutFailure();
                    }

                    @Override
                    public void onNext(AboutResponse res) {
                        if (res.getAbouts().size() > 0)
                            listener.onAboutSuccess(res.getAbouts().get(0));
                        else
                            listener.onAboutFailure();
                    }
                });
    }
}
