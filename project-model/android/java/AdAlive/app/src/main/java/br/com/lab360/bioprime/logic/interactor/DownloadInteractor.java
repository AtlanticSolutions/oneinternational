package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.listeners.OnDocumentsFilesLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.download.DocumentsFilesResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.SingleSubscriber;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */

public class DownloadInteractor extends BaseInteractor{

    public DownloadInteractor(Context context) {
        super(context);
    }

    public void getAllDocuments(int masterEventId, final OnDocumentsFilesLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getAllDocuments(masterEventId, AdaliveConstants.APP_ID)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<DocumentsFilesResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onDocumentsFilesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(DocumentsFilesResponse eventResponse) {
                        listener.onDocumentsFilesLoadSuccess(eventResponse.getEventFiles());
                    }
                });
    }

    public void getDocumentByTag(String limit, String offset, String tag, final OnDocumentsFilesLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchDocumentsByTag(AdaliveApplication.getInstance().getUser().getToken(), limit, offset, tag)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<DocumentsFilesResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onDocumentsFilesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(DocumentsFilesResponse eventResponse) {
                        listener.onDocumentsFilesLoadSuccess(eventResponse.getEventFiles());
                    }
                });
    }

    public void getDocumentByCategoryAndSubCategory(String limit, String offset, int category_id, int subcategory_id, final OnDocumentsFilesLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchDocumentsByCategoryAndSubCategory(AdaliveApplication.getInstance().getUser().getToken(), limit, offset, category_id, subcategory_id)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new SingleSubscriber<DocumentsFilesResponse>() {
                    @Override
                    public void onSuccess(DocumentsFilesResponse value) {
                        listener.onDocumentsFilesLoadSuccess(value.getEventFiles());
                    }

                    @Override
                    public void onError(Throwable error) {
                        listener.onDocumentsFilesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));
                    }
                });
    }

    public void getDocumentBySubCategory(String limit, String offset, int subcategory_id, final OnDocumentsFilesLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.searchDocumentsBySubCategory(AdaliveApplication.getInstance().getUser().getToken(), limit, offset, subcategory_id)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<DocumentsFilesResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onDocumentsFilesLoadError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST));

                    }

                    @Override
                    public void onNext(DocumentsFilesResponse eventResponse) {
                        listener.onDocumentsFilesLoadSuccess(eventResponse.getEventFiles());
                    }
                });
    }
}
