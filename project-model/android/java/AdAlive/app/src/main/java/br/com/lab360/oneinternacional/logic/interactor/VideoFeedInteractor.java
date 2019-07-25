package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;
import android.util.Log;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.listeners.OnGetVideosListener;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Videos;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class VideoFeedInteractor extends BaseInteractor {

    public VideoFeedInteractor(Context context) {
        super(context);
    }

    public void getVideos(final OnGetVideosListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        int masterEventID = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();

        adaliveApi.getVideos(masterEventID)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Videos>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e(AdaliveConstants.ERROR, "onError: " + e.toString());
                        listener.onVideosLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                    }

                    @Override
                    public void onNext(Videos videoFeedResponse) {
                        listener.onVideosLoadSuccess(videoFeedResponse);
                    }
                });

    }


    public void getVideoByTag(String limit, String offset,String tag, final OnGetVideosListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchVideosByTag(AdaliveApplication.getInstance().getUser().getToken(),limit,offset,tag)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Videos>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onVideosLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(Videos videos) {
                        listener.onVideosLoadSuccess(videos);
                    }
                });
    }

    public void getVideoBySubCategory(String limit, String offset, int subcategory_id, final OnGetVideosListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchVideosBySubCategory(AdaliveApplication.getInstance().getUser().getToken(),limit,offset,subcategory_id)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Videos>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onVideosLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(Videos videos) {
                        listener.onVideosLoadSuccess(videos);
                    }
                });
    }

    public void getVideosByCategoryAndSubCategory(String limit, String offset, Integer category_id, Integer subcategory_id, final OnGetVideosListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchVideosByCategoryAndSubCategory(AdaliveApplication.getInstance().getUser().getToken(), limit, offset, category_id, subcategory_id)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Videos>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onVideosLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(Videos videos) {
                        listener.onVideosLoadSuccess(videos);
                    }
                });
    }
}
