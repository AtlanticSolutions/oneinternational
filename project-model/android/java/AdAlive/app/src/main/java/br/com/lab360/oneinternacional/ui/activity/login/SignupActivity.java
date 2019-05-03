package br.com.lab360.oneinternacional.ui.activity.login;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.drawable.ColorDrawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.util.Pair;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

import com.google.common.base.Strings;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.presenter.SignupPresenter;
import br.com.lab360.oneinternacional.logic.presenter.SignupPresenter.ISignupView;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.ImageUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import cafe.adriel.androidoauth.model.SocialUser;
import de.hdodenhof.circleimageview.CircleImageView;
import me.anshulagarwal.simplifypermissions.Permission;

public class SignupActivity extends BaseActivity implements ISignupView {
    private static final int REQUEST_PICK_IMAGE = 0x32;
    private static final int REQUEST_TAKE_PHOTO = 0x31;
    private static final int PERMISSION_REQUEST_CODE = 0x33;

    private String[] ACTIVITY_PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };

    @BindView(R.id.etFullName)
    protected EditText etFullName;
    @BindView(R.id.etEmail)
    protected EditText etEmail;
    /*@BindView(R.id.etConfirmEmail)
    protected EditText etConfirmEmail;
    */@BindView(R.id.etPassword)
    protected EditText etPassword;
    @BindView(R.id.etConfirmPassword)
    protected EditText etConfirmPassword;
    @BindView(R.id.etCompany)
    protected EditText etCompany;
    @BindView(R.id.btnSignUp)
    protected Button btnSignUp;
    @BindView(R.id.containerPassword)
    protected LinearLayout containerPassword;
    @BindView(R.id.btnPhoto)
    protected CircleImageView btnPhoto;

    private SignupPresenter mPresenter;
    private String mCurrentPhotoPath;

    //region AndroidLifecsycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_signup);
        ButterKnife.bind(this);
        initToolbar();

        Bundle extras = getIntent().getExtras();
        SocialUser facebookUser = null;
        String facebookToken = null;
        if (extras != null && extras.containsKey(AdaliveConstants.INTENT_TAG_FACEBOOK_USER)) {
            facebookUser = getIntent().getExtras().getParcelable(AdaliveConstants.INTENT_TAG_FACEBOOK_USER);
            facebookToken = getIntent().getExtras().getString(AdaliveConstants.INTENT_TAG_FACEBOOK_TOKEN);
        }
        new SignupPresenter(this, facebookUser, facebookToken, this);


        //Paulo Create a generic method - Paulo
        String topColor = UserUtils.getBackgroundColor(SignupActivity.this);

        if (!Strings.isNullOrEmpty(topColor)) {
            Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
            setSupportActionBar(myToolbar);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }




    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case REQUEST_TAKE_PHOTO:
                    resizeBitmap(mCurrentPhotoPath);
                    btnPhoto.setImageBitmap(ImageUtils.resizePic(btnPhoto.getWidth(), btnPhoto.getHeight(), mCurrentPhotoPath));
                    ImageUtils.addPhotoToGallery(this, mCurrentPhotoPath);
                    break;
                case REQUEST_PICK_IMAGE:
                    Uri originalUri = data.getData();
                    mCurrentPhotoPath = ImageUtils.getRealPathFromUri(this, originalUri);
                    btnPhoto.setImageBitmap(ImageUtils.resizePic(btnPhoto.getWidth(), btnPhoto.getHeight(), mCurrentPhotoPath));
                    break;
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }


    private void resizeBitmap(String filePath) {
        try {
            Bitmap bitmap = BitmapFactory.decodeFile(filePath);
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            float scaleWidth = ((float) 1024) / width;
            float scaleHeight = ((float) 1024) / height;
            // CREATE A MATRIX FOR THE MANIPULATION
            ExifInterface exif = new ExifInterface(filePath);
            int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

            int angle = 0;

            if (orientation == ExifInterface.ORIENTATION_ROTATE_90) {
                angle = 90;
            }
            else if (orientation == ExifInterface.ORIENTATION_ROTATE_180) {
                angle = 180;
            }
            else if (orientation == ExifInterface.ORIENTATION_ROTATE_270) {
                angle = 270;
            }

            Matrix mat = new Matrix();
            mat.postScale(scaleWidth, scaleHeight);
            mat.postRotate(angle);


            // "RECREATE" THE NEW BITMAP
            Bitmap resizedBitmap = Bitmap.createBitmap(
                    bitmap, 0, 0, width, height, mat, false);
            bitmap.recycle();
            OutputStream outStream = null;

            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
                file = new File(filePath);
                Log.e("file exist", "" + file + ",Bitmap= " + filePath);
            }
            try {
                // make a new bitmap from your file
                outStream = new FileOutputStream(file);
                resizedBitmap.compress(Bitmap.CompressFormat.PNG, 100, outStream);
                outStream.flush();
                outStream.close();
                resizedBitmap.recycle();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        catch (IOException e) {
            Log.w("TAG", "-- Error in setting image");
        }
        catch(OutOfMemoryError oom) {
            Log.w("TAG", "-- OOM Error in setting image");
        }
    }
    //endregion

    //region Camera methods
    @Override
    public void showGalleryCameraDialog() {
        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle(getString(R.string.ALERT_TITLE_PICK_PHOTO))
                .setMessage(getString(R.string.ALERT_MESSAGE_PICK_PHOTO))
                .setPositiveButton(getString(R.string.ALERT_OPTION_TAKE_PHOTO), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        mPresenter.onBtnOpenCameraTouched();
                        dialogInterface.dismiss();
                    }
                })
                .setNegativeButton(getString(R.string.ALERT_OPTION_PICK_PHOTO), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        mPresenter.onBtnOpenGalleryTouched();
                        dialogInterface.dismiss();
                    }
                }).create();
        dialog.show();
    }

    @Override
    public void attemptToOpenGallery() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, getString(R.string.ALERT_TITLE_PICK_PHOTO)), REQUEST_PICK_IMAGE);
    }

    @Override
    public void attemptToOpenCamera() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                Pair<File, String> fileStringPair = ImageUtils.createImageFile(this);
                photoFile = fileStringPair.first;
                mCurrentPhotoPath = fileStringPair.second;

            } catch (IOException ex) {
                // Error occurred while creating the File
                mPresenter.onCreateFileError();
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {
                Uri photoURI = FileProvider.getUriForFile(this,
                        AdaliveConstants.FILE_PROVIDER_URI,
                        photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                startActivityForResult(takePictureIntent, REQUEST_TAKE_PHOTO);
            }
        }
    }

    @Override
    public void checkPermissions() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {

                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                        mPresenter.onPermissionDenied();
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                        mPresenter.onPermissionAccessRemoved();
                    }
                };
                Permission.PermissionBuilder permissionBuilder =
                        new Permission.PermissionBuilder(
                                ACTIVITY_PERMISSIONS,
                                PERMISSION_REQUEST_CODE,
                                mPermissionCallback)
                                .enableDefaultRationalDialog(
                                        getString(R.string.DIALOG_TITLE_PERMISSION),
                                        getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION)
                                );

                requestAppPermissions(permissionBuilder.build());
            }
        }
    }

    @Override
    public void showPermissionNeededSnackMessage() {
        showSnackMessage(getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION));
    }


    @Override
    public void showFileCreationError() {
        showToastMessage(getString(R.string.ERROR_ALERT_MESSAGE_DISK_SAVE));
    }
    //endregion


    //region ISignupView
    public void setPresenter(SignupPresenter mPresenter) {
        this.mPresenter = mPresenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
    }

    @Override
    public void setColorViews() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        btnSignUp.setBackgroundColor(color);
    }

    @Override
    public void showNameFieldError() {
        etFullName.setError(getString(R.string.ERROR_ALERT_REQUIRED_FIELD));
    }

    @Override
    public void setActivityResult(User response) {
        AdaliveApplication.getInstance().setUser(response);
        AdaliveApplication.getInstance().setResultSignup(true);
        finish();
    }

    @Override
    public void showEmailServerError() {
        etEmail.setError(getString(R.string.ERROR_ALERT_MESSAGE_EMAIL_SERVER));
    }

    @Override
    public void showEmailInvalidError() {
        etEmail.setError(getString(R.string.ERROR_ALERT_MESSAGE_EMAIL_INVALID));
    }

    @Override
    public void showEmailBlankError() {
        etEmail.setError(getString(R.string.ERROR_ALERT_REQUIRED_FIELD));
    }

    @Override
    public void showPasswordFieldError() {
        etPassword.setError(getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_INVALID));
    }

    @Override
    public void showPasswordServerError() {
        etPassword.setError(getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_SERVER));
    }


    @Override
    public void showConfirmPasswordServerError() {
        etConfirmPassword.setError(getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_INVALID));
    }

    @Override
    public void showCompanyFieldsDoNotMatchError() {
        etCompany.setError(getString(R.string.ERROR_ALERT_REQUIRED_FIELD));
    }

    @Override
    public void showPasswordFieldsDoNotMatchError() {
        etConfirmPassword.setError(getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_MATCH));
    }

    @Override
    public void showEmailFieldsDoNotMatchError() {
        //etConfirmEmail.setError(getString(R.string.ERROR_ALERT_MESSAGE_EMAIL_MATCH));
    }

    @Override
    public void populateFields(SocialUser facebookUser) {
        etFullName.setText(facebookUser.getName());
        etEmail.setText(facebookUser.getEmail());
        etPassword.setText(facebookUser.getId());
    }

    @Override
    public void disableEmailField() {
        etEmail.setEnabled(false);
    }

    @Override
    public void hidePasswordField() {
        containerPassword.setVisibility(View.GONE);
    }

    @Override
    public void showErrorMessage(String message) {
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR), message, null);
    }
    //endregion

    //region Button Actions
    @OnClick(R.id.btnSignUp)
    public void onClick(View view) {
        switch (view.getId()) {

            case R.id.btnSignUp:
                String email = etEmail.getText().toString().trim();
                //String confirmEmail = etConfirmEmail.getText().toString().trim();
                String name = etFullName.getText().toString().trim();
                String password = etPassword.getText().toString();
                String confirmPassword = etConfirmPassword.getText().toString();
                //String companyName = etCompany.getText().toString();


                mPresenter.attemptToSignUp(
                        name,
                        email,
                        email,
                        password,
                        confirmPassword,
                        mCurrentPhotoPath,
                        "");
                break;
        }
    }

    @OnClick(R.id.btnPhoto)
    public void onClick() {
        mPresenter.attemptToOpenPhoto();
    }
    //endregion
}
