package br.com.lab360.bioprime.ui.activity.events;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.View;
import android.widget.TextView;
import com.google.common.base.Strings;
import java.util.ArrayList;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.downloads.EventDownloadsPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.activity.downloads.FileDescriptionActivity;
import br.com.lab360.bioprime.ui.adapters.downloads.DownloadInfoRecyclerAdapter;
import br.com.lab360.bioprime.utils.DownloadUtils;
import br.com.lab360.bioprime.utils.RecyclerItemClickListener;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class EventDownloadsActivity extends BaseActivity implements EventDownloadsPresenter.IEventDownloadsView {

    private static final int REQUEST_DOWNLOAD_INFO = 0x32;
    @BindView(R.id.rvDownload)
    RecyclerView rvDownloads;

    @BindView(R.id.tvEmptyList)
    protected TextView tvEmptyList;

    private EventDownloadsPresenter mPresenter;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_event_downloads);
        ButterKnife.bind(this);

        Bundle extras = getIntent().getExtras();
        Event event = extras.getParcelable(AdaliveConstants.INTENT_TAG_EVENT);
        new EventDownloadsPresenter(this, event);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data)  {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_DOWNLOAD_INFO) {
            mPresenter.onFileStatusChanged();
        }
    }

    //endregion

    @Override
    public void setPresenter(EventDownloadsPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void hideEmptyListMessage() {
        tvEmptyList.setVisibility(View.GONE);
    }

    @Override
    public void showEmptyListMessage(){

        tvEmptyList.setVisibility(View.VISIBLE);

    }

    @Override
    public void setupRecyclerView() {
        final DownloadInfoRecyclerAdapter adapter = new DownloadInfoRecyclerAdapter(this);
        rvDownloads.setAdapter(adapter);
        rvDownloads.setHasFixedSize(true);
        rvDownloads.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvDownloads.addOnItemTouchListener(new RecyclerItemClickListener(this, rvDownloads, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                mPresenter.attemptToDownload(position);
            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));
    }

    @Override
    public void populateRecyclerView(ArrayList<DownloadInfoObject> files) {
        ((DownloadInfoRecyclerAdapter) rvDownloads.getAdapter()).replaceAll(files);
    }

    @Override
    public void navigateToFileDescriptionActivity(DownloadInfoObject objectInfo) {
        Intent intent = new Intent(this, FileDescriptionActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_DOWNLOAD, objectInfo);
        startActivityForResult(intent, REQUEST_DOWNLOAD_INFO);
    }

    @Override
    public void updateFileStatus(int pos) {
        rvDownloads.getAdapter().notifyItemChanged(pos);
    }

    @Override
    public boolean checkFileAlreadyDownloaded(DownloadInfoObject downloadInfoObject) {
        return DownloadUtils.alreadyDownloadedFile(EventDownloadsActivity.this, downloadInfoObject);
    }

    @Override
    public void showAlreadyDownloadedDialog() {
        new AlertDialog.Builder(this)
                .setTitle(getString(R.string.ALERT_TITLE_DOWNLOAD))
                .setMessage(getString(R.string.ALERT_MESSAGE_DOWNLOAD_EXISTS))
                .setCancelable(false)
                .setPositiveButton(android.R.string.ok,
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                            }
                        }).create().show();
    }
}
