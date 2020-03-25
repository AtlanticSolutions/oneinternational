package br.com.lab360.bioprime.logic.presenter.downloads;

import java.util.ArrayList;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.DownloadFileDeletedEvent;
import br.com.lab360.bioprime.logic.rxbus.events.DownloadFileFinishedEvent;
import rx.Observer;
import rx.Subscription;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class MyDocumentsListPresenter implements IBasePresenter {

    private Subscription downloadFileSubscription;
    private ArrayList<DownloadInfoObject> mDocuments;
    private IDownloadListView mView;
    private final String MIME_TYPE_PDF = "application/pdf";

    public MyDocumentsListPresenter(IDownloadListView view, ArrayList<DownloadInfoObject> documents) {
        this.mView = view;
        this.mDocuments = documents;
        this.mView.setPresenter(this);
    }

    //region Public Methods
    @Override
    public void start() {

        if(mDocuments.size() == 0){
            mView.showEmptyListText();
            return;
        }
        mView.setupRecyclerView(mDocuments);

        createDownloadSubscriptions();

    }

    public void onDocumentTouched(int position) {

        DownloadInfoObject object = mDocuments.get(position);
        String fileName = object.getTitle() + "." + object.getFileExtension();
        mView.attemptToOpenFile(fileName, MIME_TYPE_PDF);

    }

    public void onDocumentToDelete(int position) {
        DownloadInfoObject object = mDocuments.get(position);
        mView.removeFile(object);
    }

    //endregion
    //region Private Methods
    private void createDownloadSubscriptions() {

        downloadFileSubscription = AdaliveApplication.getBus().subscribe(RxQueues.DOWNALOAD_FILE_COMPLETED, new Observer<DownloadFileFinishedEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(DownloadFileFinishedEvent downloadEvent) {
                updateDownload(downloadEvent.getDownalodID());
            }
        });
    }
    //endregion


    private void updateDownload(DownloadInfoObject downloadInfoObject){
        mDocuments.add(downloadInfoObject);
        mView.setupRecyclerView(mDocuments);

        //Notifica outro Fragment que o download foi concluido com sucesso
        AdaliveApplication.getBus().publish(RxQueues.DELETE_DOWNALOADED_FILE, new DownloadFileDeletedEvent());

    }


    public interface IDownloadListView {

        void setPresenter(MyDocumentsListPresenter presenter);

        void setupRecyclerView(ArrayList<DownloadInfoObject> mEvents);

        void showEmptyListText();

        void attemptToOpenFile(String fileName, final String mime);

        void removeFile(DownloadInfoObject objectDeleted);

    }
}