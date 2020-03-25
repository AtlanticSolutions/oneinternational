package br.com.lab360.bioprime.logic.presenter.downloads;

import java.util.ArrayList;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.interactor.EventsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnEventFilesLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */
public class EventDownloadsPresenter implements IBasePresenter, OnEventFilesLoadedListener {
    private final Event mEvent;
    private final IEventDownloadsView mView;
    private final EventsInteractor mInteractor;

    private int mSelectedFilePos;
    private ArrayList<DownloadInfoObject> mFiles;

    public EventDownloadsPresenter(IEventDownloadsView view, Event event) {
        this.mView = view;
        this.mInteractor = new EventsInteractor(mView.getContext());
        this.mEvent = event;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.hideEmptyListMessage();
        mView.setupRecyclerView();

        mView.showProgress();
        mInteractor.getEventsFiles(AdaliveApplication.getInstance().getCodeParams().getMasterEventId(), mEvent.getId(), this);
    }

    public void attemptToDownload(int position) {
        mSelectedFilePos = position;
        if(mView.checkFileAlreadyDownloaded(mFiles.get(position))){
            mView.showAlreadyDownloadedDialog();
            return;
        }
        mView.navigateToFileDescriptionActivity(mFiles.get(position));
    }

    public void onFileStatusChanged() {
        mView.updateFileStatus(mSelectedFilePos);
    }

    @Override
    public void onEventFilesLoadSucess(ArrayList<DownloadInfoObject> files) {
        mFiles = files;
        mView.hideProgress();
        if (files.isEmpty()){
            mView.showEmptyListMessage();
        }else{
            mView.populateRecyclerView(files);
        }

    }

    @Override
    public void onEventFilesLoadError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }

    public interface IEventDownloadsView extends IBaseView {

        void setPresenter(EventDownloadsPresenter presenter);

        void initToolbar();

        void hideEmptyListMessage();

        void showEmptyListMessage();

        void setupRecyclerView();

        void populateRecyclerView(ArrayList<DownloadInfoObject> files);

        void navigateToFileDescriptionActivity(DownloadInfoObject objectInfo);

        void updateFileStatus(int selectedFilePos);

        boolean checkFileAlreadyDownloaded(DownloadInfoObject downloadInfoObject);

        void showAlreadyDownloadedDialog();
    }
}