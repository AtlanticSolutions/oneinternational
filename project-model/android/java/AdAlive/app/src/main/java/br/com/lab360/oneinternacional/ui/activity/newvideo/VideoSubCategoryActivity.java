package br.com.lab360.oneinternacional.ui.activity.newvideo;

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
import java.util.Arrays;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.category.Category;
import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategory;
import br.com.lab360.oneinternacional.logic.presenter.newvideo.VideoSubCategoryPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.SubCategoryRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class VideoSubCategoryActivity extends BaseActivity implements VideoSubCategoryPresenter.ISubCategoryView, SubCategoryRecyclerAdapter.OnSubCategoryClicked {

    @BindView(R.id.rvSubCategory)
    protected RecyclerView rvSubCategory;

    private List<SubCategory> subCategories = new ArrayList<>();
    private Category category = new Category();

    private VideoSubCategoryPresenter mPresenter;
    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_subcategory);
        ButterKnife.bind(this);

        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        gson = new Gson();

        loadValuesFromPreferences();
        new VideoSubCategoryPresenter(this);
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setTitle(category.getName());
            String topColor = UserUtils.getBackgroundColor(this);

            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
                ScreenUtils.updateStatusBarcolor(this, topColor);
            }
        }
    }

    @Override
    public void loadValuesFromPreferences() {
        String jsonSubCategory = sharedPrefsHelper.get(AdaliveConstants.TAG_SUB_CATEGORIES, "");
        String jsonCategory = sharedPrefsHelper.get(AdaliveConstants.TAG_CATEGORY, "");

        if(jsonCategory != null && !jsonCategory.equals("") && jsonSubCategory != null && !jsonSubCategory.equals("")){
            subCategories = Arrays.asList(gson.fromJson(jsonSubCategory, SubCategory[].class));
            category = gson.fromJson(jsonCategory, Category.class);
        }
    }

    @Override
    public void saveValuesInPreferences(SubCategory subCategory) {
        sharedPrefsHelper.put(AdaliveConstants.TAG_SUB_CATEGORY,gson.toJson(subCategory));
    }

    @Override
    public void configRecyclerView() {
        if(subCategories != null){
            rvSubCategory.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvSubCategory.setHasFixedSize(true);
            final SubCategoryRecyclerAdapter adapter = new SubCategoryRecyclerAdapter(subCategories, this, this);
            rvSubCategory.setAdapter(adapter);
        }
    }

    @Override
    public void onItemClick(SubCategory subCategory) {
        saveValuesInPreferences(subCategory);
        startVideosAllActivity();
    }

    @Override
    public void startVideosAllActivity() {
        Intent intent = new Intent(VideoSubCategoryActivity.this, VideosAllActivity.class);
        startActivity(intent);
    }

    @Override
    public void startVideosCategoryActivity() {
        Intent intent = new Intent(this, VideoCategoryActivity.class);
        startActivity(intent);
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
    public void setmPresenter(VideoSubCategoryPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        configRecyclerView();
    }
}
