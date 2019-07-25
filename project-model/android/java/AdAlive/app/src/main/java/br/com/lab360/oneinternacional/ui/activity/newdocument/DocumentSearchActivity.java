package br.com.lab360.oneinternacional.ui.activity.newdocument;

import android.content.Intent;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.SearchView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.newdocument.DocumentSearchPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.DocumentRecyclerAdapter;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentSearchActivity extends BaseActivity implements DocumentSearchPresenter.IDocumentSearchView, DocumentRecyclerAdapter.OnDocumentClicked{
    @BindView(R.id.searchView)
    protected SearchView searchView;
    @BindView(R.id.searchTvEmpty)
    protected TextView searchTvEmpty;
    @BindView(R.id.rvSearch)
    protected RecyclerView rvDocument;

    private DocumentSearchPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_searchview);
        ButterKnife.bind(this);

        new DocumentSearchPresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(getString(R.string.BUTTON_TITLE_MY_DOWNLOADS));
    }

    @Override
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
                    mPresenter.attemptLoadDocuments(null, null, query);
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
    public void configRecyclerView(ArrayList<DownloadInfoObject> documents) {
        if (documents != null) {
            rvDocument.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvDocument.setHasFixedSize(true);
            final DocumentRecyclerAdapter adapter = new DocumentRecyclerAdapter(documents, this, this);
            rvDocument.setAdapter(adapter);
        }
    }

    @Override
    public void onItemClick(DownloadInfoObject document) {
        Intent intent = new Intent(getApplicationContext(), DocumentActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_DOWNLOAD, document);
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
                startDocumentsCategoryActivity();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        startDocumentsCategoryActivity();
    }

    @Override
    public void setmPresenter(DocumentSearchPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
        configSearchView();
    }
}

