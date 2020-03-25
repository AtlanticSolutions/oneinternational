package br.com.lab360.bioprime.ui.activity.videos;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.common.base.Strings;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.videos.Video;
import br.com.lab360.bioprime.logic.model.pojo.videos.Videos;
import br.com.lab360.bioprime.logic.presenter.videos.VideoFeedPresenter;
import br.com.lab360.bioprime.ui.activity.NavigationDrawerActivity;
import br.com.lab360.bioprime.ui.adapters.videos.VideoFeedRecyclerAdapter;
import br.com.lab360.bioprime.utils.RecyclerItemClickListener;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class VideoFeedActivity extends NavigationDrawerActivity implements VideoFeedPresenter.IVideosView {

    @BindView(R.id.rvFeedVideo)
    protected RecyclerView rvFeedVideo;

    @BindView(R.id.container_loading)
    protected LinearLayout mContainerLoading;

    @BindView(R.id.tvEmpty)
    protected TextView tvEmpty;

    private VideoFeedPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video_feed);
        ButterKnife.bind(this);

        new VideoFeedPresenter(this);

    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        setToolbarTitle(R.string.BUTTON_FEED_VIDEOS);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);

        }

        //rever
//        ivMenu.setVisibility(View.GONE);
    }

    @Override
    public void configRecyclerView(Videos videos) {
        rvFeedVideo.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvFeedVideo.setHasFixedSize(true);

        final VideoFeedRecyclerAdapter adapter = new VideoFeedRecyclerAdapter(videos.getmVideos(), this);
        rvFeedVideo.setAdapter(adapter);

        rvFeedVideo.addOnItemTouchListener(new RecyclerItemClickListener(this, rvFeedVideo, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                navigateToVideoPlayer(adapter, position);
            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));
    }

    @Override
    public void navigateToVideoPlayer(VideoFeedRecyclerAdapter adapter, int position) {
        Video video = adapter.getVideo(position);
        Intent intent = new Intent(this, VideoPlayerActivity.class);
        intent.putExtra(AdaliveConstants.VIDEO, video);
        startActivity(intent);
    }

    @Override
    public void setmPresenter(VideoFeedPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void showEmptyVideoListText() {
        rvFeedVideo.setVisibility(View.GONE);
        tvEmpty.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideLoadingContainer() {

        mContainerLoading.setVisibility(View.GONE);

    }



    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
