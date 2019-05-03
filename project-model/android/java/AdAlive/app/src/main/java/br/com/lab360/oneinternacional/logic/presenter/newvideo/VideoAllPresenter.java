package br.com.lab360.oneinternacional.logic.presenter.newvideo;

import java.util.List;

import br.com.lab360.oneinternacional.logic.interactor.VideoFeedInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnGetVideosListener;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Video;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Videos;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoAllPresenter implements IBasePresenter, OnGetVideosListener {

    private IVideoAllView mView;
    private VideoFeedInteractor interactor;

    public VideoAllPresenter(VideoAllPresenter.IVideoAllView mView) {
        this.mView = mView;
        this.interactor = new VideoFeedInteractor(mView.getContext());
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
    }

    public void attemptLoadVideos(String limit, String offset, String query) {
        mView.showProgress();
        interactor.getVideoByTag(limit, offset, query, this);
    }

    public void attemptLoadByCategoryAndSubCategory(String limit, String offset, Integer categoryId, Integer subCategoryId) {
        mView.showProgress();
        interactor.getVideosByCategoryAndSubCategory(limit, offset, categoryId, subCategoryId, this);
    }

    @Override
    public void onVideosLoadSuccess(Videos videos) {
        mView.hideProgress();
        if (videos != null && videos.getmVideos().size() != 0) {
            mView.configRecyclerView(videos.getmVideos());
        }
    }

    @Override
    public void onVideosLoadError(String error) {
        mView.hideProgress();
    }

    public interface IVideoAllView extends IBaseView {
        void setmPresenter(VideoAllPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(List<Video> videos);
        void startVideosCategoryActivity();
        void startVideosSubCategoryActivity();
    }
}