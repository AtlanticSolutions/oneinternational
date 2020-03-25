package br.com.lab360.bioprime.ui.activity.newdocument;

import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.MenuItem;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategory;
import br.com.lab360.bioprime.logic.presenter.newdocument.DocumentCategoryPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.activity.timeline.TimelineActivity;
import br.com.lab360.bioprime.ui.adapters.CategoryRecyclerAdapter;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentCategoryActivity extends BaseActivity implements DocumentCategoryPresenter.ICategoryView, CategoryRecyclerAdapter.OnCategoryClicked{

    @BindView(R.id.rvCategory)
    protected RecyclerView rvCategory;

    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;
    private DocumentCategoryPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_category);
        ButterKnife.bind(this);

        new DocumentCategoryPresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(getString(R.string.BUTTON_TITLE_MY_DOWNLOADS));
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
            startDocumentsAllActivity();
        }
    }

    @Override
    public void startSubCategoryActivity() {
        Intent intent = new Intent(DocumentCategoryActivity.this, DocumentSubCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void startDocumentsAllActivity() {
        Intent intent = new Intent(DocumentCategoryActivity.this, DocumentsAllActivity.class);
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
        Intent intent = new Intent(this, DocumentSearchActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                super.onBackPressed();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
    }

    @Override
    public void setmPresenter(DocumentCategoryPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        this.gson = new Gson();
        this.sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        mPresenter.attemptLoadCategories(getUserToken(),null,null, AdaliveConstants.CATEGORY_DOCUMENT);
    }
}
