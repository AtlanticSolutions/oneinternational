package br.com.lab360.bioprime.logic.presenter.newdocument;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.interactor.DownloadInteractor;
import br.com.lab360.bioprime.logic.listeners.OnDocumentsFilesLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;

public class DocumentSearchPresenter implements IBasePresenter, OnDocumentsFilesLoadedListener {

    private IDocumentSearchView mView;
    private DownloadInteractor interactor;

    public DocumentSearchPresenter(DocumentSearchPresenter.IDocumentSearchView mView) {
        this.mView = mView;
        this.mView.setmPresenter(this);
        this.interactor = new DownloadInteractor(mView.getContext());
    }

    @Override
    public void start() {
        mView.initToolbar();
    }

    public void attemptLoadDocuments(String limit, String offset, String query) {
        interactor.getDocumentByTag(limit, offset, query, this);
    }

    @Override
    public void onDocumentsFilesLoadSuccess(ArrayList<DownloadInfoObject> files) {
        mView.hideProgress();
        if (files != null && files.size() != 00) {
            mView.configRecyclerView(files);
        }
    }

    @Override
    public void onDocumentsFilesLoadError(String error) {
        mView.hideProgress();
    }

    public interface IDocumentSearchView extends IBaseView {
        void setmPresenter(DocumentSearchPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(ArrayList<DownloadInfoObject> files);
        void configSearchView();
        void startDocumentsCategoryActivity();
    }
}
