package br.com.lab360.oneinternacional.ui.activity.newdocument;

import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.category.Category;
import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategory;
import br.com.lab360.oneinternacional.logic.presenter.newdocument.DocumentSubCategoryPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.SubCategoryRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentSubCategoryActivity extends BaseActivity implements DocumentSubCategoryPresenter.ISubCategoryView, SubCategoryRecyclerAdapter.OnSubCategoryClicked {
    @BindView(R.id.rvSubCategory)
    protected RecyclerView rvSubCategory;

    private List<SubCategory> subCategories = new ArrayList<>();
    private Category category = new Category();

    private DocumentSubCategoryPresenter mPresenter;
    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_subcategory);
        ButterKnife.bind(this);

        new DocumentSubCategoryPresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(category.getName());
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
            rvSubCategory.setLayoutManager(new LinearLayoutManager(this, RecyclerView.VERTICAL, false));
            rvSubCategory.setHasFixedSize(true);
            final SubCategoryRecyclerAdapter adapter = new SubCategoryRecyclerAdapter(subCategories, this, this);
            rvSubCategory.setAdapter(adapter);
        }
    }

    @Override
    public void onItemClick(SubCategory subCategory) {
        saveValuesInPreferences(subCategory);
        startDocumentsAllActivity();
    }

    @Override
    public void startDocumentsAllActivity() {
        Intent intent = new Intent(DocumentSubCategoryActivity.this, DocumentsAllActivity.class);
        startActivity(intent);
    }

    @Override
    public void startDocumentsCategoryActivity() {
        Intent intent = new Intent(this, DocumentCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                //startDocumentsCategoryActivity();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        //startDocumentsCategoryActivity();
        finish();
    }

    @Override
    public void setmPresenter(DocumentSubCategoryPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        this.sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        this.gson = new Gson();
        loadValuesFromPreferences();
        configRecyclerView();
    }
}
