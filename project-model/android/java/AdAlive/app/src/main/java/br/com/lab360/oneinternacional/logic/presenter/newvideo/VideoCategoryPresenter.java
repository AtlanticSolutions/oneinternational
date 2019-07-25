package br.com.lab360.oneinternacional.logic.presenter.newvideo;

import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.oneinternacional.logic.interactor.CategoriesInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnCategoriesLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.category.Category;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 25/04/2018.
 */

public class VideoCategoryPresenter implements IBasePresenter, OnCategoriesLoadedListener {
    private ICategoryView mView;
    private CategoriesInteractor interactor;

    public VideoCategoryPresenter(VideoCategoryPresenter.ICategoryView mView) {
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
        void setmPresenter(VideoCategoryPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(List<Category> response);
        void saveValuesInPreferences(Category category);
        void startTimelineActivity();
        void startSubCategoryActivity();
        void startVideosAllActivity();
        void showErrorMessage(String message);
    }
}

