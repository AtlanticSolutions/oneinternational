package br.com.lab360.bioprime.ui.activity.videos;

import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.youtube.player.YouTubeBaseActivity;
import com.google.android.youtube.player.YouTubeInitializationResult;
import com.google.android.youtube.player.YouTubePlayerView;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.videos.Video;
import br.com.lab360.bioprime.logic.presenter.videos.VideoPlayerPresenter;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class VideoPlayerActivity extends YouTubeBaseActivity implements
        VideoPlayerPresenter.IVideoPlayerView {

    @BindView(R.id.youtube_view)
    YouTubePlayerView youtubeView;
    @BindView(R.id.ivShare)
    ImageView ivShare;
    @BindView(R.id.tvTitle)
    TextView tvTitle;
    @BindView(R.id.ivBack)
    ImageView ivBack;

    private VideoPlayerPresenter mPresenter;
    private Video selectedVideo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video_player);
        ButterKnife.bind(this);

        new VideoPlayerPresenter(this);

    }

    @Override
    public void configSelectedVideo() {
        selectedVideo = getIntent().getParcelableExtra(AdaliveConstants.VIDEO);
    }

    @Override
    public void initToolbar() {

        if (selectedVideo != null) {
            tvTitle.setText(selectedVideo.getName());
        } else {
            tvTitle.setText(getString(R.string.TITLE_DEFAULT_VIDEO));
        }
    }

    @Override
    public void configVideoPlayer() {

        if (selectedVideo != null) {
            mPresenter.setmVideo(selectedVideo);
            youtubeView.initialize(AdaliveConstants.YOUTUBE_API_KEY, mPresenter);
        }
    }

    @Override
    public void setmPresenter(VideoPlayerPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @OnClick(R.id.ivShare)
    @Override
    public void shareVideo() {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_TEXT, selectedVideo.getUrl());
        startActivity(Intent.createChooser(intent, ""));
    }

    @Override
    public void handleYoutubeError(YouTubeInitializationResult result) {
        int errorDialog = -1;
        result.getErrorDialog(this, errorDialog).show();
    }


    @OnClick(R.id.ivBack)
    public void backScreen() {
        onBackPressed();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_share, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
            case R.id.action_share:
                shareVideo();
                break;
            default:
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void showToastMessage(String message) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }
}