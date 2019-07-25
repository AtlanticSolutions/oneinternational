package br.com.lab360.oneinternacional.logic.presenter.downloads;

import android.content.Context;
import android.util.Log;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.DownloadInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnDocumentsFilesLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.DownloadFileDeletedEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.DownloadFileFinishedEvent;
import rx.Observer;
import rx.Subscription;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class AllDocumentsListPresenter implements IBasePresenter, OnDocumentsFilesLoadedListener {

    private ArrayList<DownloadInfoObject> mDocuments;
    private IDownloadDocumentsListView mView;
    private DownloadInteractor mInteractor;

    private Subscription deleteFileSubscription;
    private Subscription downloadFileCompletedSubscription;

    private final String MIME_TYPE_PDF = "application/pdf";

    public AllDocumentsListPresenter(IDownloadDocumentsListView view, Context context) {
        this.mView = view;
        this.mInteractor = new DownloadInteractor(context);
        this.mDocuments = null;
        this.mView.setPresenter(this);

        createDownloadDeletedSubscriptions();
        createDownloadSubscriptions();

    }

    //region Public Methods
    @Override
    public void start() {

        getAllDocuments();

    }

    private void getAllDocuments() {
        mInteractor.getAllDocuments(AdaliveApplication.getInstance().getCodeParams().getMasterEventId(), this);
    }

    public void onDocumentTouched(int position) {

        DownloadInfoObject object = mDocuments.get(position);

        this.mView.downloadFile(object);

    }

    @Override
    public void onDocumentsFilesLoadSuccess(ArrayList<DownloadInfoObject> files) {
        if (files.size() == 0) {
            mView.showEmptyListText();
            return;
        }

        this.mDocuments = files;
        mView.setupRecyclerView(files);

        createDownloadSubscriptions();
    }

    @Override
    public void onDocumentsFilesLoadError(String error) {
//        mView.hideLoadingContainer();
//        mView.showToastMessage(error);
        Log.v(AdaliveConstants.ERROR, error);
        mView.showEmptyListText();
    }
    //endregion


    //region Private Methods
    private void createDownloadDeletedSubscriptions() {

        deleteFileSubscription = AdaliveApplication.getBus().subscribe(RxQueues.DELETE_DOWNALOADED_FILE, new Observer<DownloadFileDeletedEvent>() {
            @Override
            public void onCompleted() {
            }

            @Override
            public void onError(Throwable e) {
            }

            @Override
            public void onNext(DownloadFileDeletedEvent deletedEvent) {
                getAllDocuments();
            }
        });
    }

    //endregion
    //region Private Methods
    private void createDownloadSubscriptions() {

        downloadFileCompletedSubscription = AdaliveApplication.getBus().subscribe(RxQueues.DOWNALOAD_FILE_COMPLETED, new Observer<DownloadFileFinishedEvent>() {
            @Override
            public void onCompleted() {
            }

            @Override
            public void onError(Throwable e) {
            }

            @Override
            public void onNext(DownloadFileFinishedEvent downloadEvent) {
                getAllDocuments();
            }
        });
    }
    //endregion

    public interface IDownloadDocumentsListView  {

        void setPresenter(AllDocumentsListPresenter presenter);

        void setupRecyclerView(ArrayList<DownloadInfoObject> mEvents);

        void showEmptyListText();

        void attemptToOpenFile(String fileName, final String mime);

        void downloadFile(DownloadInfoObject file);

    }
}