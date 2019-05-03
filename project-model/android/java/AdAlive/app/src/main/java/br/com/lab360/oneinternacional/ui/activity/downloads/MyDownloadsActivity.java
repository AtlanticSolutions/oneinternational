package br.com.lab360.oneinternacional.ui.activity.downloads;

import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;
import androidx.appcompat.widget.Toolbar;
import android.view.MotionEvent;
import android.view.View;
import android.webkit.MimeTypeMap;
import android.widget.Toast;

import com.google.common.base.Strings;

import java.io.File;
import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.downloads.MyDownloadsPresenter;
import br.com.lab360.oneinternacional.ui.activity.NavigationDrawerActivity;
import br.com.lab360.oneinternacional.ui.adapters.events.EventsViewPagerAdapter;
import br.com.lab360.oneinternacional.ui.fragments.downloads.AllDocumentosFragment;
import br.com.lab360.oneinternacional.ui.fragments.downloads.MyDocumentsFragment;
import br.com.lab360.oneinternacional.utils.DownloadUtils;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import me.anshulagarwal.simplifypermissions.Permission;

public class MyDownloadsActivity extends NavigationDrawerActivity implements MyDownloadsPresenter.IMyDownloadsView {


    @BindView(R.id.tablayout)
    protected TabLayout mTabLayout;

    @BindView(R.id.viewpager)
    protected ViewPager mViewPager;

    private MyDownloadsPresenter mPresenter;

    private static final int READ_PERMITION_REQUEST = 50;
    private static final String[] READ_PERMITION = {Manifest.permission.READ_EXTERNAL_STORAGE};



    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_downloads);
        ButterKnife.bind(this);

        mViewPager.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                return false;
            }
        });

        new MyDownloadsPresenter(this);

    }

    //endregion

    //region IMyDownloadsView
    @Override
    public void initToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        setToolbarTitle(R.string.SCREEN_TITLE_MY_DOWNLOADS);

        String topColor = UserUtils.getBackgroundColor(MyDownloadsActivity.this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }

    }

    @Override
    public void setPresenter(MyDownloadsPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void setupSwipeRefresh() {
//        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
//            @Override
//            public void onRefresh() {
//                mPresenter.onRefresh();
//            }
//        });
    }

    @Override
    public void setupRecyclerView() {
//        MyDownloadsRecyclerAdapter adapter = new MyDownloadsRecyclerAdapter(mPresenter, this);
//        rvMyDownloads.setAdapter(adapter);
//        rvMyDownloads.setHasFixedSize(true);
//        rvMyDownloads.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
    }

    @Override
    public void populateRecycleView(ArrayList<DownloadInfoObject> items) {

//        ((MyDownloadsRecyclerAdapter) rvMyDownloads.getAdapter()).replaceAll(items);

        setupViewPager(items);
    }

    @Override
    public ArrayList<DownloadInfoObject> loadSharedPreferencesDownloads() {
        ArrayList<DownloadInfoObject> objects = DownloadUtils.getSharedPrefsMyDownloadList(this);
        for (DownloadInfoObject object : (ArrayList<DownloadInfoObject>) objects.clone()) {
            if (!object.isVisible()) {
                if (DownloadUtils.isFileInDownloadFolder(object)) {
                    DownloadUtils.enableFileInMyDownloadList(this, object);
                    object.setVisible(true);
                } else {
                    objects.remove(object);
                }
            }
        }
        return objects;
    }

    @Override
    public void stopRefreshing() {
//        swipeRefreshLayout.setRefreshing(false);
    }

    @Override
    public void showEmptyListText() {
//        tvEmptyList.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideEmptyListText() {
//        tvEmptyList.setVisibility(View.GONE);
    }


    @Override
    public void attemptToOpenFile(String fileName, final String mime) {

        File sdcard = Environment.getExternalStorageDirectory();

        StringBuilder filePath = new StringBuilder(String.valueOf(Environment.DIRECTORY_DOWNLOADS))
                .append("/AHK")
                .append("/")
                .append(fileName);

        File file = new File(sdcard, String.valueOf(filePath));

        if (!file.exists()) {
            Toast.makeText(this, getString(R.string.ALERT_MESSAGE_FILE_NOT_FOUND), Toast.LENGTH_SHORT).show();
            return;
        }

        MimeTypeMap map = MimeTypeMap.getSingleton();
        String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1, file.getName().length());
        String type = map.getMimeTypeFromExtension(ext);

        /*if (type != MIME_TYPE_PDF && !AppUtils.canDisplayPdf(this)) {

            Toast.makeText(this,getText(R.string.ALERT_MESSAGE_NO_PDF), Toast.LENGTH_LONG).show();
            //Intent intent = new Intent(this, PdfViewActivity.class);
            //intent.putExtra(AppConstants.TAG_PDF, filePath.toString());
            //startActivity(intent);
            return;
        }*/

        if (type == null)
            type = "*/*";

        Uri data = Uri.fromFile(file);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(data, type);
        startActivity(intent);
    }

    @Override
    public void removeFile(DownloadInfoObject objectDeleted) {
        DownloadUtils.removeFileFromMyDownloadList(this, objectDeleted);
        DownloadUtils.removeFileFromDevice(objectDeleted);
    }

    @Override
    public void checkReadPermission(Permission.PermissionCallback listener) {
        Permission.PermissionBuilder permissionBuilder = new Permission.PermissionBuilder(READ_PERMITION,
                READ_PERMITION_REQUEST, listener);

        permissionBuilder.enableDefaultRationalDialog(getString(R.string.ALLOW_READ), getString(R.string.ALERT_MESSAGE_READ))
                .enableDefaultSettingDialog(getString(R.string.ALLOW_READ_ERRO), getString(R.string.ALERT_MESSAGE_READ_ERRO));
        requestAppPermissions(permissionBuilder.build());
    }

    @Override
    public void setupViewPager(ArrayList<DownloadInfoObject> documents) {

        Fragment myDocsListFragment = MyDocumentsFragment.newInstance(documents);
        Fragment allDocsFragment =  AllDocumentosFragment.newInstance();

        EventsViewPagerAdapter adapter = new EventsViewPagerAdapter(getSupportFragmentManager(), this);

        adapter.addFragment(myDocsListFragment, getString(R.string.LABEL_MY_DOCUMENTS));
        adapter.addFragment(allDocsFragment, getString(R.string.LABEL_ALL_DOCUMENTS));


        mViewPager.setAdapter(adapter);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                mViewPager.setCurrentItem(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });

    }


    @Override
    public void showTabLayout() {

        mTabLayout.setVisibility(View.VISIBLE);
        mTabLayout.setAlpha(0);
        mTabLayout.animate()
                .alpha(1)
                .setDuration(1000)
                .withLayer()
                .setListener(new AnimatorListenerAdapter() {
                    @Override
                    public void onAnimationEnd(Animator animation) {
                        super.onAnimationEnd(animation);
                        mTabLayout.setScaleY(1);
                        mTabLayout.setAlpha(1);
                    }
                });

    }

//    @Override
//    public void showViewPager() {
//
//        mViewPager.setVisibility(View.VISIBLE);
//
//    }

    @Override
    public void setupTabLayout() {

        mTabLayout.addTab(mTabLayout.newTab().setText(getString(R.string.LABEL_MY_DOCUMENTS)));
        mTabLayout.addTab(mTabLayout.newTab().setText(getString(R.string.LABEL_ALL_DOCUMENTS)));
        mTabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            mTabLayout.setBackground(cd);
        }

        mTabLayout.setupWithViewPager(mViewPager);
    }
    //endregion




}
