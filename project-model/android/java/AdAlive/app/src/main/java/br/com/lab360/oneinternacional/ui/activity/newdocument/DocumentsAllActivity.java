package br.com.lab360.oneinternacional.ui.activity.newdocument;

import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;

import com.google.gson.Gson;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.category.Category;
import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategory;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.newdocument.DocumentAllPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.DocumentRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentsAllActivity extends BaseActivity implements DocumentAllPresenter.IDocumentAllView, DocumentRecyclerAdapter.OnDocumentClicked {
    @BindView(R.id.rvItems)
    protected RecyclerView rvDocument;

    private DocumentAllPresenter mPresenter;
    private SharedPrefsHelper sharedPrefsHelper;
    private Gson gson;
    private Category category;
    private SubCategory subCategory;
    private int subcategoryId = 0;
    private int categoryId = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document_all);
        ButterKnife.bind(this);

        new DocumentAllPresenter(this);
    }

    @Override
    public void initToolbar() {
        if (subCategory != null && subCategory.getName() != null){
            initToolbar(subCategory.getName());
        }else{
            initToolbar(getString(R.string.BUTTON_TITLE_MY_DOWNLOADS));
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
    public void configRecyclerView(ArrayList<DownloadInfoObject> documents) {
        if (documents != null && documents.size() != 0) {
            rvDocument.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvDocument.setHasFixedSize(true);
            final DocumentRecyclerAdapter adapter = new DocumentRecyclerAdapter(documents, this, this);
            rvDocument.setAdapter(adapter);
        }else {
            errorDialog(getString(R.string.DIALOG_TITLE_ERROR),"Não há documento disponível", onClickDialogButton(R.id.DIALOG_BUTTON_1));
        }
    }

    @Override
    public void onItemClick(DownloadInfoObject document) {
        if (document.getUrlFile() != null) {
            Intent intent = new Intent(getApplicationContext(), DocumentActivity.class);
            intent.putExtra(AdaliveConstants.INTENT_TAG_DOWNLOAD, document);
            startActivity(intent);
        } else {
            errorDialog(getString(R.string.DIALOG_TITLE_ERROR),"Não há documento disponível", null);
        }
    }

    @Override
    public void startDocumentsCategoryActivity() {
        Intent intent = new Intent(this, DocumentCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void startDocumentsSubCategoryActivity() {
        Intent intent = new Intent(this, DocumentSubCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                if (subCategory == null) {
                    startDocumentsCategoryActivity();
                } else {
                    startDocumentsSubCategoryActivity();
                }

                finish();
                break;
        }
        return true;
    }

    @Override
    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        startDocumentsCategoryActivity();
                        break;

                }
            }
        };
    }

    @Override
    public void onBackPressed() {
        if (subCategory == null) {
            startDocumentsCategoryActivity();
        } else {
            startDocumentsSubCategoryActivity();
        }
    }

    @Override
    public void setmPresenter(DocumentAllPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        this.sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        this.gson = new Gson();
        loadValuesFromPreferences();
        mPresenter.attemptLoadDocumentsByCategoryAndSubCategory(null, null, categoryId, subcategoryId);
    }
}
