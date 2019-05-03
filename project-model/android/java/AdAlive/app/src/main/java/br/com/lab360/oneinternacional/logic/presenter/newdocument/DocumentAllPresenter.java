package br.com.lab360.oneinternacional.logic.presenter.newdocument;

import android.view.View;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.interactor.DownloadInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnDocumentsFilesLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentAllPresenter implements IBasePresenter, OnDocumentsFilesLoadedListener {

    private IDocumentAllView mView;
    private DownloadInteractor interactor;

    public DocumentAllPresenter(DocumentAllPresenter.IDocumentAllView mView) {
        this.mView = mView;
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        interactor = new DownloadInteractor(mView.getContext());
        mView.initToolbar();
    }

    public void attemptLoadDocuments(String limit, String offset, String query) {
        interactor.getDocumentByTag(null, null, query, this);
    }

    public void attemptLoadDocumentsByCategoryAndSubCategory(String limit, String offset, int categoryId, int subCategoryId) {
        interactor.getDocumentByCategoryAndSubCategory(limit, offset, categoryId, subCategoryId, this);
    }

    @Override
    public void onDocumentsFilesLoadSuccess(ArrayList<DownloadInfoObject> files) {
        mView.hideProgress();
        mView.configRecyclerView(files);
    }

    @Override
    public void onDocumentsFilesLoadError(String error) {
        mView.hideProgress();
    }

    public interface IDocumentAllView extends IBaseView {
        void setmPresenter(DocumentAllPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(ArrayList<DownloadInfoObject> files);
        void startDocumentsCategoryActivity();
        void startDocumentsSubCategoryActivity();
        View.OnClickListener onClickDialogButton(int id);
    }
}