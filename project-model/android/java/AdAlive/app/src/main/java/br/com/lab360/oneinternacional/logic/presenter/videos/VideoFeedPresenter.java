package br.com.lab360.oneinternacional.logic.presenter.videos;

import br.com.lab360.oneinternacional.logic.interactor.VideoFeedInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnGetVideosListener;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Videos;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.adapters.videos.VideoFeedRecyclerAdapter;
import br.com.lab360.oneinternacional.ui.view.INavigationDrawerView;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class VideoFeedPresenter implements IBasePresenter, OnGetVideosListener {

    private Videos mVideos;
    private IVideosView mView;
    private VideoFeedInteractor mInteractor;

    public VideoFeedPresenter(IVideosView mView) {
        this.mView = mView;
        this.mInteractor = new VideoFeedInteractor(mView.getContext());
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {

        mView.initToolbar();
        mInteractor.getVideos(this);

    }

    @Override
    public void onVideosLoadSuccess(Videos videos) {

        mVideos = videos;

        mView.hideLoadingContainer();

        if (mVideos.getmVideos().size() == 0) {
            mView.showEmptyVideoListText();
            return;
        } else {
            mView.configRecyclerView(mVideos);
        }

    }

    @Override
    public void onVideosLoadError(String error) {
        mView.hideLoadingContainer();
        mView.showToastMessage(error);
    }

    public interface IVideosView extends INavigationDrawerView {

        void initToolbar();

        void configRecyclerView(Videos videos);

        void navigateToVideoPlayer(VideoFeedRecyclerAdapter adapter, int position);

        void setmPresenter(VideoFeedPresenter mPresenter);

        void showEmptyVideoListText();

        void hideLoadingContainer();
    }
}
