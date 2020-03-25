package br.com.lab360.bioprime.logic.presenter.timeline;

import android.text.TextUtils;
import android.util.Pair;

import com.google.common.base.Strings;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.interactor.TimelineInteractor;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostCreatedListener;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;
import br.com.lab360.bioprime.logic.model.pojo.timeline.PostCreation;
import br.com.lab360.bioprime.logic.model.pojo.timeline.PostLog;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;
import br.com.lab360.bioprime.utils.Base64Utils;

/**
 * Created by Alessandro Valenza on 19/01/2017.
 */
public class CreatePostPresenter implements IBasePresenter, OnPostCreatedListener {
    private int mUserId;
    private ICreatePostView mView;
    private final int masterEventId;
    private TimelineInteractor mInteractor;

    private boolean isPermissionDenied;
    private boolean isPermissionAccessRemoved;

    public CreatePostPresenter(ICreatePostView view) {
        this.mView = view;
        this.mInteractor = new TimelineInteractor(mView.getContext());
        this.masterEventId = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.hideImageContainer();
        mView.hideRemoveImageButton();
        mView.checkPermissions();
        if(AdaliveApplication.getInstance().getUser() == null) {
            mView.navigateToLoginActivity();
            return;
        }
        mUserId = AdaliveApplication.getInstance().getUser().getId();

        mView.checkPermissions();
    }

    public void onBtnCreatePostTouched(String message, String photoPath) {
        if(isPermissionDenied){
            mView.checkPermissions();
            return;
        } else if (isPermissionAccessRemoved) {
            mView.showPermissionNeededSnackMessage();
            return;
        }
        if(Strings.isNullOrEmpty(message) && Strings.isNullOrEmpty(photoPath)){
            return;
        }

        Pair<Double,Double> lastLatLong = mView.getLatLong();
        String photoBase64 = getPhotoEncoded(photoPath);
        PostCreation postCreationBody = new PostCreation("",message, photoBase64, AdaliveConstants.ACCOUNT_ID, mUserId, AdaliveConstants.APP_ID, masterEventId);
        PostLog postCreationLog = new PostLog(lastLatLong.first,lastLatLong.second,mView.getDeviceId());

        mView.showProgress();
        mInteractor.createPost(postCreationLog, postCreationBody,this);
    }

    private String getPhotoEncoded(String mCurrentPhotoPath) {
        if (!TextUtils.isEmpty(mCurrentPhotoPath)) {
            return Base64Utils.encodeFileToBase64(mCurrentPhotoPath);
        }
        return null;
    }

    public void onBtnPhotoTouched() {
        mView.showCameraOptionDialog();
    }

    public void onBtnOpenCameraTouched() {
        if(isPermissionDenied){
            mView.checkPermissions();
            return;
        }else if (isPermissionAccessRemoved) {
            mView.showPermissionNeededSnackMessage();
            return;
        }
        mView.attemptToOpenCamera();
    }

    public void onBtnOpenGalleryTouched() {
        if(isPermissionDenied){
            mView.checkPermissions();
            return;
        } else if (isPermissionAccessRemoved) {
            mView.showPermissionNeededSnackMessage();
            return;
        }
        mView.attemptToOpenGallery();
    }

    public void onCreateFileError() {
        mView.showFileCreationError();
    }

    public void onPhotoLoaded() {
        mView.showImageContainer();
        mView.showRemoveImageButton();
    }


    public void onBtnCloseImageTouched() {
        mView.hideRemoveImageButton();
        mView.clearImage();
    }
    //region Permissions
    public void onPermissionDenied() {
        this.isPermissionDenied = true;
    }

    public void onPermissionAccessRemoved() {
        this.isPermissionAccessRemoved = true;
    }
    //endregion


    //region OnPostCreatedListener
    @Override
    public void onCreatePostError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }

    @Override
    public void onCreatePostSuccess(Post post) {
        mView.hideProgress();
        mView.navigateBack(true);
    }

    public void onPermissionGranted() {

        mView.createGoogleApiClient();
        mView.requestGPS();

        this.isPermissionAccessRemoved = false;
    }
    //endregion

    public interface ICreatePostView extends IBaseView{
        void initToolbar();

        void setPresenter(CreatePostPresenter presenter);

        void showCameraOptionDialog();

        void resizeBitmap(String path);

        void checkPermissions();

        void showPermissionNeededSnackMessage();

        void attemptToOpenCamera();

        void attemptToOpenGallery();

        void showFileCreationError();

        void navigateToLoginActivity();

        void navigateBack(boolean loadPosts);

        void showRemoveImageButton();

        void hideRemoveImageButton();

        void clearImage();

        void showImageContainer();

        void hideImageContainer();

        void createGoogleApiClient();

        void requestGPS();

        Pair<Double,Double> getLatLong();
    }
}