package br.com.lab360.bioprime.ui.activity.newvideo;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;

import com.google.common.base.Strings;
import com.google.gson.Gson;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategory;
import br.com.lab360.bioprime.logic.model.pojo.videos.Video;
import br.com.lab360.bioprime.logic.presenter.newvideo.VideoAllPresenter;

import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.adapters.VideoRecyclerAdapter;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideosAllActivity extends BaseActivity implements VideoAllPresenter.IVideoAllView, VideoRecyclerAdapter.OnVideoClicked {

    @BindView(R.id.rvItems)
    protected RecyclerView rvVideos;

    private VideoAllPresenter mPresenter;
    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;
    private Category category;
    private SubCategory subCategory;
    private Integer subcategoryId;
    private Integer categoryId;
    private VideoRecyclerAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document_all);
        ButterKnife.bind(this);

        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        gson = new Gson();

        loadValuesFromPreferences();
        new VideoAllPresenter(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (adapter != null) {
            adapter.notifyDataSetChanged();
        }
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            if (subCategory != null && subCategory.getName() != null){
                getSupportActionBar().setTitle(subCategory.getName());
            }else{
                getSupportActionBar().setTitle(R.string.BUTTON_FEED_VIDEOS);
            }

            String topColor = UserUtils.getBackgroundColor(this);

            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
                ScreenUtils.updateStatusBarcolor(this, topColor);
            }
        }
    }

    public void loadValuesFromPreferences() {
        String jsonCategory = sharedPrefsHelper.get(AdaliveConstants.TAG_CATEGORY, "");
        String json = sharedPrefsHelper.get(AdaliveConstants.TAG_SUB_CATEGORY, "");

        if (json != null && !json.equals("")) {
            subCategory = gson.fromJson(json, SubCategory.class);
            subcategoryId = subCategory.getId();
        }

        if (jsonCategory != null && !jsonCategory.equals("")) {
            category = gson.fromJson(jsonCategory, Category.class);
            categoryId = Integer.parseInt(category.getId());
        }
    }

    @Override
    public void configRecyclerView(List<Video> videos) {
        if (videos!= null) {
            rvVideos.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvVideos.setHasFixedSize(true);
            adapter = new VideoRecyclerAdapter(videos, this, this);
            rvVideos.setAdapter(adapter);
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
        Intent intent = new Intent(this, VideoSubCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                if (subCategory == null) {
                  startVideosCategoryActivity();
                } else {
                    startVideosSubCategoryActivity();
                }

                finish();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        if (subCategory == null) {
            startVideosCategoryActivity();
        } else {
            startVideosSubCategoryActivity();
        }
    }

    @Override
    public void setmPresenter(VideoAllPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        mPresenter.attemptLoadByCategoryAndSubCategory(null, null, categoryId, subcategoryId);
    }
}
