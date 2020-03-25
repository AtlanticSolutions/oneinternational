package br.com.lab360.bioprime.ui.activity.managerapplication;

import android.app.DownloadManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;

import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplication;
import br.com.lab360.bioprime.logic.presenter.managerapplication.ManagerApplicationPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.adapters.managerapplication.ManagerApplicationRecyclerAdapter;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 28/06/2018.
 */

public class ManagerApplicationActivity extends BaseActivity implements ManagerApplicationPresenter.IManagerApplicationView, ManagerApplicationRecyclerAdapter.OnManagerApplicationClicked {

    private ManagerApplicationPresenter mPresenter;

    @BindView(R.id.rvApplicationManager)
    RecyclerView rvApplicationManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manager_application);
        ButterKnife.bind(this);
        new ManagerApplicationPresenter(this);
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        getSupportActionBar().setTitle(R.string.SCREEN_MANAGER_APPLICATION);
        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void configRecyclerView(List<ManagerApplication> managerApplications) {
        if (managerApplications != null) {
            rvApplicationManager.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvApplicationManager.setHasFixedSize(true);

            final ManagerApplicationRecyclerAdapter adapter = new ManagerApplicationRecyclerAdapter(managerApplications,this, this);
            rvApplicationManager.setAdapter(adapter);
        }
    }

    @Override
    public void setmPresenter(ManagerApplicationPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void onDownloadButtonClick(ManagerApplication managerApplication) {
        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(managerApplication.getUrlApp()));
        request.setDescription(String.valueOf(managerApplication.getVersionApp()));
        request.setTitle(managerApplication.getNameApp());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.allowScanningByMediaScanner();
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        }

        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, managerApplication.getNameApp() + " " + String.valueOf(managerApplication.getVersionApp()) + ".apk");
        DownloadManager manager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
        manager.enqueue(request);
    }

    @Override
    public void onSharedClick(ManagerApplication managerApplication) {
        Intent sharingIntent = new Intent(android.content.Intent.ACTION_SEND);
        sharingIntent.setType("text/plain");
        sharingIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Aplicativo " + managerApplication.getNameApp() + " " + String.valueOf(managerApplication.getVersionApp()));
        sharingIntent.putExtra(android.content.Intent.EXTRA_TEXT, managerApplication.getUrlApp());
        startActivity(Intent.createChooser(sharingIntent, "Compartilhar"));
    }
}