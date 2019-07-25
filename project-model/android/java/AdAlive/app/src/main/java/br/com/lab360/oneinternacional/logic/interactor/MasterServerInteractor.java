package br.com.lab360.oneinternacional.logic.interactor;

import android.util.Log;

import br.com.lab360.oneinternacional.logic.listeners.OnMasterServerDataLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.MasterServerResponse;
import br.com.lab360.oneinternacional.logic.rest.AdaliveMasterServer;
import br.com.lab360.oneinternacional.logic.rest.AdaliveServiceFactory;
import lib.utils.ConstantsAdAlive;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */

public class MasterServerInteractor {

    public void getMasterServerData(int appId,
                                    String deviceName,
                                    String latitude,
                                    String longitude,
                                    String deviceSystemName,
                                    String deviceIdVendor,
                                    String deviceSystemVersion,
                                    String deviceModel,
                                    String deviceVersion, final OnMasterServerDataLoadedListener listener) {

        AdaliveMasterServer initialService = AdaliveServiceFactory.getInitialService();


        initialService.getMasterServerData(appId,
                deviceName,
                latitude,
                longitude,
                deviceSystemName,
                deviceIdVendor,
                deviceSystemVersion,
                deviceModel,
                deviceVersion)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<MasterServerResponse>() {
                    @Override
                    public void onCompleted() {
                        Log.i("TESTe", "TESTE");
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.v(ConstantsAdAlive.TAG_LOG_ERROR_LOG, e.getMessage());
                        listener.onMasterServerDataLoadError();
                    }

                    @Override
                    public void onNext(MasterServerResponse layoutResponse) {
                        listener.onMasterServerDataLoadSuccess(layoutResponse);
                    }

                });
    }

}
