package br.com.lab360.bioprime.logic.presenter.newdocument;

import br.com.lab360.bioprime.logic.listeners.OnSubCategoryLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategoriesResponse;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategory;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentSubCategoryPresenter implements IBasePresenter, OnSubCategoryLoadedListener {

    private ISubCategoryView mView;

    public DocumentSubCategoryPresenter(DocumentSubCategoryPresenter.ISubCategoryView mView) {
        this.mView = mView;
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.configRecyclerView();
    }

    @Override
    public void onSubCategoryLoadError(Throwable e) {
    }

    @Override
    public void onSubCategoryLoadSuccess(SubCategoriesResponse response) {
    }

    public interface ISubCategoryView {
        void setmPresenter(DocumentSubCategoryPresenter mPresenter);
        void initToolbar();
        void loadValuesFromPreferences();
        void saveValuesInPreferences(SubCategory subCategory);
        void startDocumentsAllActivity();
        void startDocumentsCategoryActivity();
        void configRecyclerView();
    }
}
