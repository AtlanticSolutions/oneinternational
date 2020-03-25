package br.com.lab360.bioprime.logic.presenter.downloads;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.listeners.OnBtnDeleteTouchListener;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import me.anshulagarwal.simplifypermissions.Permission;

/**
 * Created by Alessandro Valenza on 02/12/2016.
 */
public class MyDownloadsPresenter implements IBasePresenter, OnBtnDeleteTouchListener, Permission.PermissionCallback {

    private final String MIME_TYPE_PDF = "application/pdf";
    private IMyDownloadsView mView;
    private ArrayList<DownloadInfoObject> mDownloads;


    private int selectedPosition;

    public MyDownloadsPresenter(IMyDownloadsView view) {
        this.mView = view;
        this.mDownloads = new ArrayList<>();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.showTabLayout();
        mView.setupTabLayout();
        mView.checkReadPermission(this);

        onRefresh();
    }

    public void onRefresh() {
        mDownloads = mView.loadSharedPreferencesDownloads();
        mView.populateRecycleView(mDownloads);
        mView.stopRefreshing();
        if( mDownloads.size() == 0){
            mView.showEmptyListText();
            return;
        }
        mView.hideEmptyListText();


    }

    //region OnBtnDeleteTouchListener
    @Override
    public void onBtnDeleteTouched(int position) {
        DownloadInfoObject objectDeleted = mDownloads.remove(position);
        mView.removeFile(objectDeleted);



        onRefresh();
    }

    @Override
    public void onBtnOpenFileTouched(int position) {
        selectedPosition = position;
        mView.checkReadPermission(this);
    }

    @Override
    public void onPermissionGranted(int i) {
//        DownloadInfoObject object = mDownloads.get(selectedPosition);
//        String fileName = object.getTitle() + "." + object.getFileExtension();
//        mView.attemptToOpenFile(fileName, MIME_TYPE_PDF);
    }

    @Override
    public void onPermissionDenied(int i) {

    }

    @Override
    public void onPermissionAccessRemoved(int i) {

    }
    //endregion




//    public interface IMyDownloadsView extends IBaseView{

    public interface IMyDownloadsView {

        void initToolbar();

        void setPresenter(MyDownloadsPresenter presenter);

        void setupSwipeRefresh();

        void setupRecyclerView();

        void populateRecycleView(ArrayList<DownloadInfoObject> items);

        ArrayList<DownloadInfoObject> loadSharedPreferencesDownloads();

        void stopRefreshing();

        void showEmptyListText();

        void hideEmptyListText();

        void attemptToOpenFile(String fileName, final String mime);

        void removeFile(DownloadInfoObject objectDeleted);

        void checkReadPermission(Permission.PermissionCallback listener);

        void setupViewPager(ArrayList<DownloadInfoObject> documents);

        void showTabLayout();

        void setupTabLayout();
    }

}