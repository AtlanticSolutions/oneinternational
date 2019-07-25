package br.com.lab360.oneinternacional.logic.presenter.newvideo;

import br.com.lab360.oneinternacional.logic.listeners.OnSubCategoryLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategoriesResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategory;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoSubCategoryPresenter implements IBasePresenter, OnSubCategoryLoadedListener {
    private ISubCategoryView mView;

    public VideoSubCategoryPresenter(VideoSubCategoryPresenter.ISubCategoryView mView) {
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
        void setmPresenter(VideoSubCategoryPresenter mPresenter);
        void initToolbar();
        void loadValuesFromPreferences();
        void saveValuesInPreferences(SubCategory subCategory);
        void startVideosAllActivity();
        void startVideosCategoryActivity();
        void configRecyclerView();
    }
}