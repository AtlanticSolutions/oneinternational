package br.com.lab360.bioprime.ui.activity.newdocument;

import android.app.DownloadManager;
import android.content.Context;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;

import com.github.barteksc.pdfviewer.PDFView;

import java.io.File;
import java.io.IOException;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.newdocument.DocumentPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.utils.DownloadUtils;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import me.anshulagarwal.simplifypermissions.Permission;

/**
 * Created by Edson on 26/04/2018.
 */

public class DocumentActivity  extends BaseActivity implements DocumentPresenter.IDocumentView {

    @BindView(R.id.pdfView)
    protected PDFView pdfView;

    private DocumentPresenter mPresenter;
    protected String urlWeb;

    private static String NAME_FILE ="temp_file.pdf";
    private static DownloadInfoObject currentDownloadObject;

    private static final int STORAGE_PERMITION_REQUEST = 50;
    private static final String[] STORAGE_PERMITION = {android.Manifest.permission.WRITE_EXTERNAL_STORAGE};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_document);
        ButterKnife.bind(this);

        initConfigs();

        new DownloadFile().execute(urlWeb, NAME_FILE);
        new DocumentPresenter(this, currentDownloadObject);
    }

    public void initConfigs(){
        pdfView.setVisibility(View.GONE);
        currentDownloadObject = (DownloadInfoObject) getIntent().getExtras().get(AdaliveConstants.INTENT_TAG_DOWNLOAD);
        urlWeb = currentDownloadObject.getUrlFile();
    }

    private class DownloadFile extends AsyncTask<String, Void, Void> {

        @Override
        protected Void doInBackground(String... strings) {
            String fileUrl = strings[0];
            String fileName = strings[1];

            attemptCreateFolder(fileName,fileUrl);
            return null;
        }

        @Override
        protected void onPostExecute(Void v){
            pdfView.setVisibility(View.VISIBLE);
            attemptLoadPDF();
        }
    }

    @Override
    public void attemptLoadPDF(){
        File pdfFile = new File(Environment.getExternalStorageDirectory() + "/"+ NAME_FILE);
        Uri path = Uri.fromFile(pdfFile);

        pdfView.fromUri(path)
                .load();
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
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS + "/" + getString(R.string.app_name).replace(" ", ""), fileName.toString());
        DownloadManager manager = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
        long downloadId = manager.enqueue(request);

        registerReceiver(AdaliveApplication.getInstance().getDownloadListener(), new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));

        atentionDialog(getString(R.string.DIALOG_DOWNLOAD_TITLE), getString(R.string.DIALOG_DOWNLOAD_MESSAGE), null);

        mPresenter.onDownloading(downloadId);
    }


    @Override
    public void checkStoragePermission(Permission.PermissionCallback listener) {
        Permission.PermissionBuilder permissionBuilder = new Permission.PermissionBuilder(STORAGE_PERMITION,
                STORAGE_PERMITION_REQUEST, listener);

        permissionBuilder.enableDefaultRationalDialog(getString(R.string.ALLOW_STORAGE), getString(R.string.ALERT_MESSAGE_STORAGE))
                .enableDefaultSettingDialog(getString(R.string.ALLOW_STORAGE_ERRO), getString(R.string.ALERT_MESSAGE_STORAGE_ERRO));
        requestAppPermissions(permissionBuilder.build());
    }

    @Override
    public void attemptCreateFolder(String fileName, String fileUrl){
        String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
        File folder = new File(extStorageDirectory, "");

        folder.mkdir();
        File pdfFile = new File(folder, fileName);

        try{
            pdfFile.createNewFile();
        }catch (IOException e){
            e.printStackTrace();
        }

        DownloadUtils.downloadFile(fileUrl, pdfFile);
    }

    @Override
    public void enqueueDownload(long downloadId, DownloadInfoObject currentDownloadObject) {
        int listIndex = DownloadUtils.addFileToMyDownloadList(this, currentDownloadObject);
        AdaliveApplication.getInstance().enqueueDownloadId(downloadId, listIndex);
    }

    @Override
    public void setmPresenter(DocumentPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    public void initToolbar() {
        initToolbar(currentDownloadObject.getTitle());
    }

    @OnClick(R.id.ivDownload)
    protected void onIvDownload() {
        mPresenter.onBtnDownloadTouched();
    }
}