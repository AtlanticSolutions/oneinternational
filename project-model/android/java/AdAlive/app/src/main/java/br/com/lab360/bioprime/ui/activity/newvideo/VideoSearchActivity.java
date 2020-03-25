package br.com.lab360.bioprime.ui.activity.newvideo;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.SearchView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import com.google.common.base.Strings;
import java.util.List;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.videos.Video;
import br.com.lab360.bioprime.logic.presenter.newvideo.VideoAllPresenter;
import br.com.lab360.bioprime.ui.activity.NavigationDrawerActivity;
import br.com.lab360.bioprime.ui.adapters.VideoRecyclerAdapter;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoSearchActivity extends NavigationDrawerActivity implements VideoAllPresenter.IVideoAllView, VideoRecyclerAdapter.OnVideoClicked{
    @BindView(R.id.searchView)
    protected SearchView searchView;
    @BindView(R.id.searchTvEmpty)
    protected TextView searchTvEmpty;
    @BindView(R.id.rvSearch)
    protected RecyclerView rvVideo;

    private VideoAllPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_searchview);

        ButterKnife.bind(this);
        new VideoAllPresenter(this);
        configSearchView();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            setToolbarTitle(R.string.BUTTON_FEED_VIDEOS);
            String topColor = UserUtils.getBackgroundColor(this);

            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
                ScreenUtils.updateStatusBarcolor(this, topColor);
            }
        }
    }

    public void configSearchView() {
        searchView.setActivated(true);
        searchView.onActionViewExpanded();
        searchView.setIconified(false);
        searchView.clearFocus();
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String query) {
                if (!query.equals("")) {
                    searchTvEmpty.setVisibility(View.GONE);
                    mPresenter.attemptLoadVideos(null, null, query);
                }
                return false;
            }

            @Override
            public boolean onQueryTextChange(String newText) {
                return false;
            }
        });
    }

    @Override
    public void configRecyclerView(List<Video> videos) {
        if (videos != null) {
            rvVideo.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvVideo.setHasFixedSize(true);
            final VideoRecyclerAdapter adapter = new VideoRecyclerAdapter(videos, this, this);
            rvVideo.setAdapter(adapter);
        }
    }

    @Override
    public void onItemClick(Video video) {
    }

    @Override
    public void startVideosCategoryActivity() {
        Intent intent = new Intent(this, VideoCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void startVideosSubCategoryActivity() {
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                startVideosCategoryActivity();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        startVideosCategoryActivity();
    }

    @Override
    public void setmPresenter(VideoAllPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }
}

