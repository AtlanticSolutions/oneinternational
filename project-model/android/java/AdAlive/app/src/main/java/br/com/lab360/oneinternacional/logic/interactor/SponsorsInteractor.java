package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;
import android.util.Log;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.listeners.OnGetSponsorsListener;
import br.com.lab360.oneinternacional.logic.listeners.OnGetSponsorsPlanListener;
import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.SponsorsResponse;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import okhttp3.ResponseBody;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsInteractor extends BaseInteractor {

    public SponsorsInteractor(Context context) {
        super(context);
    }

    public void getSponsors(int masterEventId, final OnGetSponsorsListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.getSponsors(masterEventId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<SponsorsResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e(AdaliveConstants.ERROR, "onError: " + e.toString());
                        listener.onSponsorsLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                    }

                    @Override
                    public void onNext(SponsorsResponse sponsorsResponse) {
                        listener.onSponsorsLoadSuccess(sponsorsResponse.getSponsors());
                    }
                });

    }


    public void getSponsorsPlans(int appID, final OnGetSponsorsPlanListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.getSponsorsPlans(appID)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ResponseBody>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                       listener.onSponsorsLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                    }

                    @Override
                    public void onNext(ResponseBody sponsorsResponse) {

                        try {

                            JsonParser parser = new JsonParser();
                            JsonArray jsonArray = parser.parse(sponsorsResponse.string()).getAsJsonArray();

                            listener.onSponsorsLoadSuccess(jsonArray);

                        }catch (Exception ex){
                            Log.v(AdaliveConstants.ERROR, ex.getMessage().toString());
                        }

                    }
                });

    }

}
