package br.com.lab360.bioprime.logic.presenter.newdocument;

import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import me.anshulagarwal.simplifypermissions.Permission;


/**
 * Created by Edson on 01/05/2018.
 */

public class DocumentPresenter implements IBasePresenter, Permission.PermissionCallback {

    private IDocumentView mView;
    private final DownloadInfoObject mCurrentDownloadObject;

    public DocumentPresenter(DocumentPresenter.IDocumentView mView, DownloadInfoObject currentDownloadObject) {
        this.mView = mView;
        this.mCurrentDownloadObject = currentDownloadObject;
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
    }


    public void onBtnDownloadTouched() {
        mView.checkStoragePermission(this);
    }

    public void attemptToDownloadFile() {
        StringBuilder fileName = new StringBuilder(mCurrentDownloadObject.getTitle())
                .append(".")
                .append(mCurrentDownloadObject.getFileExtension());

        mView.createDownloadRequest(fileName.toString(),mCurrentDownloadObject.getUrlFile());
    }

    public void onDownloading(long downloadId) {
        mView.enqueueDownload(downloadId, mCurrentDownloadObject);
    }

    @Override
    public void onPermissionGranted(int i) {
        attemptToDownloadFile();
    }

    @Override
    public void onPermissionDenied(int i) {
    }

    @Override
    public void onPermissionAccessRemoved(int i) {
    }

    public interface IDocumentView {
        void setmPresenter(DocumentPresenter mPresenter);
        void initToolbar();
        void attemptCreateFolder(String fileName, String fileUrl);
        void attemptLoadPDF();
        void createDownloadRequest(String fileName, String fileUrl);
        void enqueueDownload(long downloadId, DownloadInfoObject mCurrentDownloadObject);
        void checkStoragePermission(Permission.PermissionCallback listener);
    }
}