package br.com.lab360.oneinternacional.logic.presenter;

import android.app.Activity;
import android.text.TextUtils;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.interactor.SignupInteractor;
import br.com.lab360.oneinternacional.logic.listeners.Account.OnCreateAccountListener;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.account.CreateAccountRequest;
import br.com.lab360.oneinternacional.ui.view.IBaseView;
import br.com.lab360.oneinternacional.utils.Base64Utils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import cafe.adriel.androidoauth.model.SocialUser;

/**
 * Created by Alessandro Valenza on 21/11/2016.
 */
public class SignupPresenter implements IBasePresenter, OnCreateAccountListener {
    private final SignupInteractor mInteractor;
    private final ISignupView mView;
    private final SocialUser facebookUser;
    private final String facebookToken;
    private boolean permissionDenied;
    private boolean permissionAccessRemoved;
    private Activity act;

    public SignupPresenter(ISignupView mView, SocialUser facebookUser, String facebookToken, Activity act) {
        this.mView = mView;
        this.mInteractor = new SignupInteractor(mView.getContext());
        this.facebookUser = facebookUser;
        this.facebookToken = facebookToken;
        this.act = act;
        this.mView.setPresenter(this);
    }

    //region Public Methods
    @Override
    public void start() {
        mView.initToolbar();
        mView.setColorViews();
        mView.checkPermissions();
        if (facebookUser != null) {
            mView.populateFields(facebookUser);
            mView.disableEmailField();
            mView.hidePasswordField();
        }

        loadLayout();
    }

    public void attemptToSignUp(String fullName, String lastName, String email, String confirmEmail, String password, String confirmPassword,
                                String mCurrentPhotoPath, String companyName) {
        boolean isValid = true;

        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            isValid = false;
        }

        if(!password.equals(confirmPassword)) {
            mView.showPasswordFieldsDoNotMatchError();
            isValid = false;
        }

        if(!email.equals(confirmEmail)) {
            mView.showEmailFieldsDoNotMatchError();
            isValid = false;
        }

        if(confirmPassword.equals("")) {
            mView.showConfirmPasswordServerError();
            isValid = false;
        }

        String photoBase64 = getPhotoEncoded(mCurrentPhotoPath);
        User user = User.createUserForRegistrationOneInternacional(fullName, lastName, email, password, facebookToken, photoBase64);

        ArrayList<Integer> validation = user.validateSignup();
        if (!performValidation(validation) || !isValid) {
            return;
        }


        CreateAccountRequest request = new CreateAccountRequest(user);
        mView.showProgress();
        mInteractor.postCreateAccount(request, this);
    }

    private void loadLayout() {
        AdaliveApplication application = AdaliveApplication.getInstance();
        if(UserUtils.getLayoutParam(mView.getContext()) == null) {
            mView.loadCachedBackground();
        }else{
            mView.loadApplicationBackground();
        }
    }

    private boolean performValidation(ArrayList<Integer> validation) {
        if (validation != null) {
            for (int fieldName : validation) {
                switch (fieldName) {
                    case User.FieldType.EMAIL_SERVER_ERROR:
                        mView.showEmailServerError();
                        break;
                    case User.FieldType.EMAIL:
                        mView.showEmailBlankError();
                        break;
                    case User.FieldType.EMAIL_INVALID:
                        mView.showEmailInvalidError();
                        break;
                    case User.FieldType.PASSWORD:
                        mView.showPasswordFieldError();
                        break;
                    case User.FieldType.PASSWORD_CHARACTER:
                        mView.showPasswordServerError();
                        break;
                    case User.FieldType.NAME:
                        mView.showNameFieldError();
                        break;
                    case User.FieldType.LASTNAME:
                        mView.showLastNameFieldError();
                        break;
                }
            }
            return false;
        }
        return true;
    }
    //endregion

    private String getPhotoEncoded(String mCurrentPhotoPath) {
        if (!TextUtils.isEmpty(mCurrentPhotoPath)) {
            return Base64Utils.encodeFileToBase64(mCurrentPhotoPath);
        }
        return null;
    }

    public void attemptToOpenPhoto() {
        mView.showGalleryCameraDialog();
    }

    public void onBtnOpenGalleryTouched() {
        if(permissionDenied){
            mView.checkPermissions();
            return;
        } else if (permissionAccessRemoved) {
            mView.showPermissionNeededSnackMessage();
            return;
        }
        mView.attemptToOpenGallery();
    }

    public void onBtnOpenCameraTouched() {
        if(permissionDenied){
            mView.checkPermissions();
            return;
        }else if (permissionAccessRemoved) {
            mView.showPermissionNeededSnackMessage();
            return;
        }
        mView.attemptToOpenCamera();
    }

    public void onCreateFileError() {
        mView.showFileCreationError();
    }
    //region OnCreateAccountListener
    @Override
    public void onCreateAccountSuccess(User response) {
        mView.hideProgress();
        mView.saveUserIntoSharedPreferences(response);
        mView.setActivityResult(response);
    }

    @Override
    public void onCreateAccountError(String message) {
        mView.hideProgress();
        mView.showErrorMessage(message);
    }

    @Override
    public void onCreateAccountError(ArrayList<Integer> errorFields) {
        mView.hideProgress();
        performValidation(errorFields);
    }
    //endregion


    //region Permissions
    public void onPermissionDenied() {
        this.permissionDenied = true;
    }

    public void onPermissionAccessRemoved() {
        this.permissionAccessRemoved = true;
    }
    //endregion


    public interface ISignupView extends IBaseView {
        void setPresenter(SignupPresenter mPresenter);

        void initToolbar();

        void setColorViews();

        void showNameFieldError();

        void showLastNameFieldError();

        void showEmailServerError();

        void showEmailInvalidError();

        void showEmailBlankError();

        void showPasswordFieldError();

        void showPasswordServerError();

        void showConfirmPasswordServerError();

        void showPasswordFieldsDoNotMatchError();

        void showEmailFieldsDoNotMatchError();

        void showCompanyFieldsDoNotMatchError();

        void populateFields(SocialUser facebookUser);

        void disableEmailField();

        void hidePasswordField();

        void setActivityResult(User response);

        void showGalleryCameraDialog();

        void attemptToOpenGallery();

        void attemptToOpenCamera();

        void checkPermissions();

        void showPermissionNeededSnackMessage();

        void showFileCreationError();

        void showErrorMessage(String message);

    }
}