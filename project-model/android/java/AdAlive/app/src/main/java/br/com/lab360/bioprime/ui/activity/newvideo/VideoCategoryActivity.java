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

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategory;
import br.com.lab360.bioprime.logic.presenter.newvideo.VideoCategoryPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.activity.timeline.TimelineActivity;
import br.com.lab360.bioprime.ui.adapters.CategoryRecyclerAdapter;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoCategoryActivity extends BaseActivity implements VideoCategoryPresenter.ICategoryView, CategoryRecyclerAdapter.OnCategoryClicked{

    @BindView(R.id.rvCategory)
    protected RecyclerView rvCategory;

    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;
    private VideoCategoryPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_category);
        ButterKnife.bind(this);

        new VideoCategoryPresenter(this);
        gson = new Gson();
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setTitle(R.string.BUTTON_FEED_VIDEOS);

            String topColor = UserUtils.getBackgroundColor(this);
            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
                ScreenUtils.updateStatusBarcolor(this, topColor);
            }
        }
    }

    @Override
    public void configRecyclerView(List<Category> categories) {
        if (categories != null) {
            rvCategory.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvCategory.setHasFixedSize(true);
            final CategoryRecyclerAdapter adapter = new CategoryRecyclerAdapter(categories, this, this);
            rvCategory.setAdapter(adapter);
        }
    }

    @Override
    public void saveValuesInPreferences(Category category) {
        if(category.getSubCategories() != null && category.getSubCategories().size() != 0){
            sharedPrefsHelper.put(AdaliveConstants.TAG_SUB_CATEGORIES,gson.toJson(category.getSubCategories()));
            sharedPrefsHelper.put(AdaliveConstants.TAG_CATEGORY,gson.toJson(category));
        }else {
            sharedPrefsHelper.put(AdaliveConstants.TAG_SUB_CATEGORY, null);
            sharedPrefsHelper.put(AdaliveConstants.TAG_CATEGORY,gson.toJson(category));
        }
    }

    @Override
    public void onItemClick(Category category) {
        if (category.getSubCategories() != null && category.getSubCategories().size() != 0) {
            saveValuesInPreferences(category);
            startSubCategoryActivity();
        }else{
            Category newCategory = new Category();
            newCategory.setId(category.getId());
            newCategory.setSubCategories(new ArrayList<SubCategory>());
            saveValuesInPreferences(newCategory);
            startVideosAllActivity();
        }
    }

    @Override
    public void startSubCategoryActivity() {
        Intent intent = new Intent(VideoCategoryActivity.this, VideoSubCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void startVideosAllActivity() {
        Intent intent = new Intent(VideoCategoryActivity.this, VideosAllActivity.class);
        startActivity(intent);
    }

    @Override
    public void startTimelineActivity() {
        Intent intent = new Intent(this, TimelineActivity.class);
        startActivity(intent);
    }

    @Override
    public void showErrorMessage(String message) {
        errorDialog(getResourceString(R.string.title_erro), message, null);
    }

    @OnClick(R.id.ivSearch)
    protected void onIvSearchTouched() {
        Intent intent = new Intent(this, VideoSearchActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                startTimelineActivity();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        startTimelineActivity();
    }

    @Override
    public void setmPresenter(VideoCategoryPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        mPresenter.attemptLoadCategories(getUserToken(),null,null, AdaliveConstants.CATEGORY_VIDEO);
    }
}
