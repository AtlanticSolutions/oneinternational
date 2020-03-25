package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.model.BeaconResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

public class BeaconInteractor extends BaseInteractor {

    public BeaconInteractor(Context context) {
        super(context);
    }

    public interface BeaconMessageInteractorListener {
        void onBeaconListSuccess(BeaconResponse beaconsList);
        void onBeaconListFailure();
    }

    public void getBeaconsMessageList(int appId, final BeaconMessageInteractorListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getBeaconsMessageList(appId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<BeaconResponse>() {
                    @Override
                    public void onCompleted() {}

                    @Override
                    public void onError(Throwable e) {
                        listener.onBeaconListFailure();
                    }

                    @Override
                    public void onNext(BeaconResponse res) {
                        listener.onBeaconListSuccess(res);
                    }
                });
    }
}
