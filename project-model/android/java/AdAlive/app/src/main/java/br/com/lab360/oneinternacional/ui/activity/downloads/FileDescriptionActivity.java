package br.com.lab360.oneinternacional.ui.activity.downloads;

import android.app.DownloadManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.common.base.Strings;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.downloads.FileDescriptionPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.DownloadUtils;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import me.anshulagarwal.simplifypermissions.Permission;

public class FileDescriptionActivity extends BaseActivity implements FileDescriptionPresenter.IFileDescriptionView {

    @BindView(R.id.tvFileName)
    TextView tvFileName;
    @BindView(R.id.tvDescription)
    TextView tvDescription;
    @BindView(R.id.tvAuthor)
    TextView tvAuthor;
    @BindView(R.id.tvLanguages)
    TextView tvLanguages;
    @BindView(R.id.tvNumPages)
    TextView tvNumPages;

    @BindView(R.id.btnDownload)
    protected Button btnDownload;

    private FileDescriptionPresenter mPresenter;

    private static final int STORAGE_PERMITION_REQUEST = 50;
    private static final String[] STORAGE_PERMITION = {android.Manifest.permission.WRITE_EXTERNAL_STORAGE};

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_file_description);
        ButterKnife.bind(this);

        DownloadInfoObject currentDownloadObject = (DownloadInfoObject) getIntent().getExtras().get(AdaliveConstants.INTENT_TAG_DOWNLOAD);
        new FileDescriptionPresenter(this, currentDownloadObject);
    }
    //endregion

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setTitle(getString(R.string.SCREEN_TITLE_DOWNLOAD));
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }

    }

    @Override
    public void setPresenter(FileDescriptionPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void populateFieldsDetails(DownloadInfoObject currentDownloadObject) {
        tvDescription.setText(currentDownloadObject.getDescription());
        tvFileName.setText(currentDownloadObject.getTitle());
        tvAuthor.setText(currentDownloadObject.getAuthor());
        tvLanguages.setText(currentDownloadObject.getLanguage());
        tvNumPages.setText(String.valueOf(currentDownloadObject.getNumberOfPages()));
    }

    @Override
    public void showDownloadDialog(DownloadInfoObject currentDownloadObject) {
        final AlertDialog.Builder builder = new AlertDialog.Builder(this);

        LayoutInflater inflater = this.getLayoutInflater();
        View dialogView = inflater.inflate(R.layout.dialog_download, null);
        builder.setView(dialogView);

        TextView tvFileName = (TextView) dialogView.findViewById(R.id.tvFileName);
        tvFileName.setText(currentDownloadObject.getTitle());

        builder.setPositiveButton(getString(R.string.BUTTON_TITLE_OK), new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {

                mPresenter.attemptToDownloadFile();
            }
        });
        builder.setNegativeButton(getString(R.string.BUTTON_TITLE_CANCEL), new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialogInterface, int i) {
                dialogInterface.dismiss();
            }
        });
        builder.setCancelable(true);
        final AlertDialog dialog = builder.create();
        dialog.setOnShowListener(new DialogInterface.OnShowListener() {
            @Override
            public void onShow(DialogInterface dialogInterface) {
                Button positiveButton = dialog.getButton(AlertDialog.BUTTON_POSITIVE);
                positiveButton.setAllCaps(false);
                positiveButton.setTextColor(ContextCompat.getColor(FileDescriptionActivity.this, R.color.blueEditText));
                positiveButton.setTypeface(null, Typeface.BOLD);
                positiveButton.setTextSize(16);

                Button negativeButton = dialog.getButton(AlertDialog.BUTTON_NEGATIVE);
                negativeButton.setAllCaps(false);
                negativeButton.setTextColor(ContextCompat.getColor(FileDescriptionActivity.this, R.color.blueEditText));
                negativeButton.setTypeface(Typeface.create("sans-serif-light", Typeface.NORMAL));
                negativeButton.setTextSize(16);
            }
        });
        dialog.show();
    }


    @Override
    public void createDownloadRequest(String fileName, String fileUrl) {
        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(fileUrl));

        request.setDescription(getString(R.string.TITLE_ACTIVITY_INDICATOR_DOWNLOADING));
        request.setTitle(fileName.toString());

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            request.allowScanningByMediaScanner();
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
        }
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS + "/AHK", fileName.toString());
        // get download service and enqueue file
        DownloadManager manager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
        long downloadId = manager.enqueue(request);
        Log.w("download", "Enqueue Download ID:" + downloadId);

        registerReceiver(AdaliveApplication.getInstance().getDownloadListener(), new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));

        new AlertDialog.Builder(this)
                .setTitle(getString(R.string.DIALOG_DOWNLOAD_TITLE))
                .setMessage(getString(R.string.DIALOG_DOWNLOAD_MESSAGE))
                .setPositiveButton(getString(R.string.DIALOG_DOWNLOAD_POSITIVE_BUTTON), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                })
                .create()
                .show();

        mPresenter.onDownloading(downloadId);
    }

    @Override
    public void disableDownloadButton() {
        btnDownload.setEnabled(false);
    }

    @Override
    public void changeDownloadButtonBackground() {
        btnDownload.setBackground(ContextCompat.getDrawable(this, R.drawable.background_button_white));
    }

    @Override
    public void enqueueDownload(long downloadId, DownloadInfoObject currentDownloadObject) {
        int listIndex = DownloadUtils.addFileToMyDownloadList(this, currentDownloadObject);
        AdaliveApplication.getInstance().enqueueDownloadId(downloadId, listIndex);
    }

    @Override
    public void checkStoragePermission(Permission.PermissionCallback listener) {

        Permission.PermissionBuilder permissionBuilder = new Permission.PermissionBuilder(STORAGE_PERMITION,
                STORAGE_PERMITION_REQUEST, listener);

        permissionBuilder.enableDefaultRationalDialog(getString(R.string.ALLOW_STORAGE), getString(R.string.ALERT_MESSAGE_STORAGE))
                .enableDefaultSettingDialog(getString(R.string.ALLOW_STORAGE_ERRO), getString(R.string.ALERT_MESSAGE_STORAGE_ERRO));
        requestAppPermissions(permissionBuilder.build());

    }
    //endregion

    //region Button Actions
    @OnClick(R.id.btnDownload)
    protected void onBtnDownloadTouched() {
        mPresenter.onBtnDownloadTouched();
    }
    //endregion

}
