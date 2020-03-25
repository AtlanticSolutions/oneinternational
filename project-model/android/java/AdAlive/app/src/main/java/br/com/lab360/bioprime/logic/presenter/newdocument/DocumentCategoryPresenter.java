package br.com.lab360.bioprime.logic.presenter.newdocument;

import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.bioprime.logic.interactor.CategoriesInteractor;
import br.com.lab360.bioprime.logic.listeners.OnCategoriesLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;

/**
 * Created by Edson on 25/04/2018.
 */

public class DocumentCategoryPresenter implements IBasePresenter, OnCategoriesLoadedListener {

    private ICategoryView mView;
    private CategoriesInteractor interactor;

    public DocumentCategoryPresenter(DocumentCategoryPresenter.ICategoryView mView) {
        this.mView = mView;
        this.interactor = new CategoriesInteractor(mView.getContext());
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
    }

    public void attemptLoadCategories(String token, String limit, String offset, int typeCategory) {
        if (!Strings.isNullOrEmpty(token)){
            mView.showProgress();
            interactor.getCategories(token, limit, offset, typeCategory, this);
        }
    }

    @Override
    public void onCategoriesLoadError(String message) {
        mView.hideProgress();
        mView.showErrorMessage(message);
    }

    @Override
    public void onCategoriesLoadSuccess(List<Category> response) {
        mView.hideProgress();
        if(response.size() != 0 && response != null){
            mView.configRecyclerView(response);
        }
    }

    public interface ICategoryView extends IBaseView {
        void setmPresenter(DocumentCategoryPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(List<Category> response);
        void saveValuesInPreferences(Category category);
        void startTimelineActivity();
        void startSubCategoryActivity();
        void startDocumentsAllActivity();
        void showErrorMessage(String message);
    }
}
