package br.com.lab360.bioprime.logic.presenter.downloads;

import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;
import me.anshulagarwal.simplifypermissions.Permission;

/**
 * Created by Alessandro Valenza on 02/12/2016.
 */
public class FileDescriptionPresenter implements IBasePresenter, Permission.PermissionCallback{

    private final DownloadInfoObject mCurrentDownloadObject;
    private final IFileDescriptionView mView;


    public FileDescriptionPresenter(IFileDescriptionView view, DownloadInfoObject currentDownloadObject) {
        this.mView = view;
        this.mCurrentDownloadObject = currentDownloadObject;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.populateFieldsDetails(mCurrentDownloadObject);
    }

    public void onBtnDownloadTouched() {
        mView.checkStoragePermission(this);
    }

    public void attemptToDownloadFile() {
        StringBuilder fileName = new StringBuilder(mCurrentDownloadObject.getTitle())
                .append(".")
                .append(mCurrentDownloadObject.getFileExtension());

        mView.createDownloadRequest(fileName.toString(),mCurrentDownloadObject.getUrlFile());
        mView.disableDownloadButton();
        mView.changeDownloadButtonBackground();
    }

    public void onDownloading(long downloadId) {
        mView.enqueueDownload(downloadId, mCurrentDownloadObject);
    }

    //region PermissionGranted
    @Override
    public void onPermissionGranted(int i) {

        mView.showDownloadDialog(mCurrentDownloadObject);

    }

    @Override
    public void onPermissionDenied(int i) {


    }

    @Override
    public void onPermissionAccessRemoved(int i) {

    }
    //endregion


    public interface IFileDescriptionView extends IBaseView {
        void initToolbar();

        void setPresenter(FileDescriptionPresenter presenter);

        void populateFieldsDetails(DownloadInfoObject currentDownloadObject);

        void showDownloadDialog(DownloadInfoObject currentDownloadObject);

        void createDownloadRequest(String fileName, String fileUrl);

        void disableDownloadButton();

        void changeDownloadButtonBackground();

        void enqueueDownload(long downloadId, DownloadInfoObject mCurrentDownloadObject);

        void checkStoragePermission(Permission.PermissionCallback listener);
    }
}