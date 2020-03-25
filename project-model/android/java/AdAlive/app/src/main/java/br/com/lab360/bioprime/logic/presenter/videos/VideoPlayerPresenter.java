package br.com.lab360.bioprime.logic.presenter.videos;

import com.google.android.youtube.player.YouTubeInitializationResult;
import com.google.android.youtube.player.YouTubePlayer;

import br.com.lab360.bioprime.logic.model.pojo.videos.Video;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.utils.YoutubeUtils;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class VideoPlayerPresenter implements IBasePresenter, YouTubePlayer.OnInitializedListener {

    private IVideoPlayerView mView;
    private YouTubePlayer youTubePlayer;
    private Video mVideo;

    public VideoPlayerPresenter(IVideoPlayerView mView) {
        this.mView = mView;
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {

        mView.configSelectedVideo();
        mView.initToolbar();
        mView.configVideoPlayer();

    }

    @Override
    public void onInitializationSuccess(YouTubePlayer.Provider provider, YouTubePlayer youTubePlayer, boolean b) {
        this.youTubePlayer = youTubePlayer;
        youTubePlayer.addFullscreenControlFlag(YouTubePlayer.FULLSCREEN_FLAG_CONTROL_ORIENTATION);
        youTubePlayer.setPlayerStyle(YouTubePlayer.PlayerStyle.DEFAULT);
        String videoId = YoutubeUtils.extractYoutubeVideoId(mVideo.getUrl());
        youTubePlayer.loadVideo(videoId, 0);
    }

    @Override
    public void onInitializationFailure(YouTubePlayer.Provider provider,
                                        YouTubeInitializationResult result) {
        if (result.isUserRecoverableError()) {
            mView.handleYoutubeError(result);
        } else {
            mView.showToastMessage("Falha ao inicializar o vídeo");
        }
    }

    public void setmVideo(Video mVideo) {
        this.mVideo = mVideo;
    }

    public interface IVideoPlayerView {

        void configSelectedVideo();

        void initToolbar();

        void configVideoPlayer();

        void setmPresenter(VideoPlayerPresenter mPresenter);

        void shareVideo();

        void handleYoutubeError(YouTubeInitializationResult result);

        void showToastMessage(String message);

    }
}
