package br.com.lab360.oneinternacional.logic.presenter.profile;

import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import org.apache.commons.validator.routines.EmailValidator;
import java.util.Map;

import br.com.lab360.oneinternacional.ui.view.IBaseView;
import br.com.lab360.oneinternacional.utils.UserUtils;

/**
 * Created by David Canon on 15/01/2018.
 */
public class ProfilePresenter {
    /* Vars */
    private ISignupView mView;

    private boolean permissionDenied;
    private boolean permissionAccessRemoved;

    public ProfilePresenter(ISignupView mView) {
        this.mView = mView;
    }

    public void start() {
        mView.initBackground();
        mView.setColorViews();
        mView.checkPermissions();
        loadLayout();
    }

    private void loadLayout() {
        if (UserUtils.getLayoutParam(mView.getContext()) == null) {
            //mView.loadCachedBackground();
        } else {
            //mView.loadApplicationBackground();
        }
    }

    public boolean performValidation(Map<String, EditText> fieldsToValidate) {
        int errors = 0;

        for (String key : fieldsToValidate.keySet()) {
            final EditText current = fieldsToValidate.get(key);

            /* Commons Validator */
            if (TextUtils.isEmpty(current.getText().toString())) {
                current.setError("Campo obrigatório");
                errors++;
                continue;
            }

            if (current.getTag().equals("edtEmail")) {
                final String email = current.getText().toString();

                if (!EmailValidator.getInstance().isValid(email)) {
                    current.setError("E-mail inválido");
                }

            }

            if (current.getTag().equals("edtFullName")) {
                String[] splitter = current.getText().toString().trim().split(" ");

                if (splitter.length < 2) {
                    current.setError("Nome completo obrigatório");
                }

            }
        }

        return errors < 0 ? true : false;
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

    //region Permissions
    public void onPermissionDenied() {
        this.permissionDenied = true;
    }

    public void onPermissionAccessRemoved() {
        this.permissionAccessRemoved = true;
    }
    //endregion

    public void attemptToOpenPhoto() {
        mView.showGalleryCameraDialog();
    }

    public interface ISignupView extends IBaseView {
        void initBackground();

        void setColorViews();

        void showGalleryCameraDialog();

        void attemptToOpenGallery();

        void attemptToOpenCamera();

        void checkPermissions();

        View.OnClickListener onClickDialogButton(int id);

        void showPermissionNeededSnackMessage();

        void showFileCreationError();
    }

}