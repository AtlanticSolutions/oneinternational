package br.com.lab360.oneinternacional.ui.activity.timeline;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.drawable.ColorDrawable;
import android.location.Location;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import androidx.core.content.FileProvider;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.util.Pair;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResult;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.common.base.Strings;
import com.transitionseverywhere.Slide;
import com.transitionseverywhere.Transition;
import com.transitionseverywhere.TransitionManager;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.presenter.timeline.CreatePostPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.activity.login.LoginActivity;
import br.com.lab360.oneinternacional.utils.ImageUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import me.anshulagarwal.simplifypermissions.Permission;

public class CreatePostActivity extends BaseActivity implements CreatePostPresenter.ICreatePostView, LocationListener {

    @BindView(R.id.btnCancelPhoto)
    ImageButton btnCancelPhoto;
    @BindView(R.id.viewButton)
    View viewButton;

    private String[] ACTIVITY_PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_PHONE_STATE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };
    private static final int PERMISSION_REQUEST_CODE = 0x33;
    private static final int REQUEST_PICK_IMAGE = 0x32;
    private static final int REQUEST_TAKE_PHOTO = 0x31;

    @BindView(R.id.ivSelectedPhoto)
    protected ImageView ivSelectedPhoto;

    @BindView(R.id.etMessage)
    protected EditText etMessage;

    @BindView(R.id.container_image)
    protected RelativeLayout containerImage;

    @BindView(R.id.btnPhoto)
    protected ImageButton btnPhoto;

    private CreatePostPresenter mPresenter;
    private String mCurrentPhotoPath;
    private int defaultHeight;
    private int defaultWidth;
    private GoogleApiClient mGoogleApiClient;
    private Location mLastLocation;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_post);
        ButterKnife.bind(this);

        new CreatePostPresenter(this);


    }
    @Override
    protected void onStop() {
        if(mGoogleApiClient != null && mGoogleApiClient.isConnected())
            mGoogleApiClient.disconnect();
        super.onStop();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (ivSelectedPhoto.getWidth() > 0 && ivSelectedPhoto.getHeight() > 0) {
            this.defaultWidth = ivSelectedPhoto.getWidth();
            this.defaultHeight = ivSelectedPhoto.getHeight();
        }
        if (resultCode == RESULT_OK) {
            switch (requestCode) {
                case REQUEST_TAKE_PHOTO:
                    if(TextUtils.isEmpty(mCurrentPhotoPath))
                        break;

                    resizeBitmap(mCurrentPhotoPath);
                    ivSelectedPhoto.setImageBitmap(ImageUtils.resizePic(defaultWidth, defaultHeight, mCurrentPhotoPath));
                    ImageUtils.addPhotoToGallery(this, mCurrentPhotoPath);
                    mPresenter.onPhotoLoaded();
                    break;
                case REQUEST_PICK_IMAGE:
                    Uri originalUri = data.getData();
                    mCurrentPhotoPath = ImageUtils.getRealPathFromUri(this, originalUri);
                    if(TextUtils.isEmpty(mCurrentPhotoPath))
                        break;

                    resizeBitmap(mCurrentPhotoPath);
                    ivSelectedPhoto.setImageBitmap(ImageUtils.resizePic(defaultWidth, defaultHeight, mCurrentPhotoPath));
                    mPresenter.onPhotoLoaded();
                    break;
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onBackPressed() {
        //super.onBackPressed();

        navigateBack(false);
    }

    //endregion

    //region Button Actions
    @OnClick(R.id.btnPhoto)
    public void onBtnPhotoTouched() {
        mPresenter.onBtnPhotoTouched();
    }

    @OnClick(R.id.btnCancelPhoto)
    public void onBtnPhotoClose() {
        mPresenter.onBtnCloseImageTouched();
    }
    //endregion

    //region ICreatePostView
    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);


            ColorDrawable cdButton = new ColorDrawable(Color.parseColor(topColor));
            btnPhoto.setBackground(cdButton);
            btnCancelPhoto.setBackground(cdButton);

        }
    }

    @Override
    public void setPresenter(CreatePostPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.menu_publish, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_publish:
                mPresenter.onBtnCreatePostTouched(etMessage.getText().toString(), mCurrentPhotoPath);
                break;
            case android.R.id.home:
                onBackPressed();
                return true;
            default:
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void showCameraOptionDialog() {
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
    public void resizeBitmap(String filePath) {
        Bitmap bitmap = BitmapFactory.decodeFile(filePath);
        if(bitmap == null){
            Toast.makeText(this, getString(R.string.ERROR_ALERT_OPEN_PHOTO), Toast.LENGTH_SHORT).show();
            return;
        }
        int width = bitmap.getWidth();
        int height = bitmap.getHeight();
        if(width == 0 || height == 0){
            Toast.makeText(this, getString(R.string.ERROR_ALERT_OPEN_PHOTO), Toast.LENGTH_SHORT).show();
            return;
        }
        float scaleWidth = ((float) 1024) / width;
        float scaleHeight = ((float) 768) / height;
        // CREATE A MATRIX FOR THE MANIPULATION
        Matrix matrix = new Matrix();
        // RESIZE THE BIT MAP
        if (scaleWidth > scaleHeight) {
            matrix.postScale(scaleHeight, scaleHeight);
        } else {
            matrix.postScale(scaleWidth, scaleWidth);
        }
        int angle = 0;
        ExifInterface exif = null;
        try {
            exif = new ExifInterface(filePath);
            switch (Integer.parseInt(exif.getAttribute(ExifInterface.TAG_ORIENTATION))) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    angle = 90;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    angle = 180;
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    angle = 270;
                    break;
                default:
                    angle = 0;
                    break;
            }
        } catch (IOException e) {
            Toast.makeText(this, getString(R.string.ERROR_ALERT_OPEN_PHOTO), Toast.LENGTH_SHORT).show();
            return;
        }

        if (angle == 0 && width > height)
            matrix.postRotate(90);
        else
            matrix.postRotate(angle);

        // "RECREATE" THE NEW BITMAP
        Bitmap resizedBitmap = Bitmap.createBitmap(
                bitmap, 0, 0, width, height, matrix, false);
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
            resizedBitmap.compress(Bitmap.CompressFormat.JPEG, 75, outStream);
            outStream.flush();
            outStream.close();
            resizedBitmap.recycle();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void checkPermissions() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {

                Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
                    @Override
                    public void onPermissionGranted(int requestCode) {
                        mPresenter.onPermissionGranted();
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
                                        getString(R.string.DIALOG_POST_MESSAGE_PERMISSION)
                                );

                requestAppPermissions(permissionBuilder.build());
            }else{
                mPresenter.onPermissionGranted();
            }
        }else{
            mPresenter.onPermissionGranted();
        }
    }

    @Override
    public void showPermissionNeededSnackMessage() {
        showSnackMessage(getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION));
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
    public void attemptToOpenGallery() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, getString(R.string.ALERT_TITLE_PICK_PHOTO)), REQUEST_PICK_IMAGE);
    }

    @Override
    public void showFileCreationError() {
        showToastMessage(getString(R.string.ERROR_ALERT_MESSAGE_DISK_SAVE));
    }

    @Override
    public void navigateToLoginActivity() {
        Intent intent = new Intent(this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    @Override
    public void navigateBack(boolean loadPosts) {
//        onBackPressed();
        Bundle conData = new Bundle();
        conData.putBoolean(AdaliveConstants.LOAD_POSTS, loadPosts);
        Intent intent = new Intent();
        intent.putExtras(conData);
        setResult(RESULT_OK, intent);
        finish();

        //TODO
    }

    @Override
    public void showRemoveImageButton() {
        btnCancelPhoto.setVisibility(View.VISIBLE);
        viewButton.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideRemoveImageButton() {
        btnCancelPhoto.setVisibility(View.GONE);
        viewButton.setVisibility(View.GONE);
    }

    @Override
    public void clearImage() {
        Transition transition = new Slide(Gravity.RIGHT);
        transition.addListener(new Transition.TransitionListener() {
            @Override
            public void onTransitionStart(Transition transition) {

            }

            @Override
            public void onTransitionEnd(Transition transition) {
                mCurrentPhotoPath = null;
                ivSelectedPhoto.setImageDrawable(null);
            }

            @Override
            public void onTransitionCancel(Transition transition) {

            }

            @Override
            public void onTransitionPause(Transition transition) {

            }

            @Override
            public void onTransitionResume(Transition transition) {

            }
        });
        TransitionManager.beginDelayedTransition(containerImage, transition);
        containerImage.setVisibility(View.INVISIBLE);
    }

    @Override
    public void showImageContainer() {
        Transition transition = new Slide(Gravity.RIGHT);
        transition.setStartDelay(300);
        TransitionManager.beginDelayedTransition(containerImage, transition);
        containerImage.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideImageContainer() {
        containerImage.setVisibility(View.INVISIBLE);
    }

    @Override
    public void createGoogleApiClient() {
        if (mGoogleApiClient == null) {
            mGoogleApiClient = new GoogleApiClient.Builder(this)
                    .addApi(LocationServices.API)
                    .build();
        }
        mGoogleApiClient.connect();
    }

    @SuppressWarnings({"MissingPermission"})
    @Override
    public void requestGPS() {

        LocationRequest locationSettingsRequest = LocationRequest.create();
        locationSettingsRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        locationSettingsRequest.setInterval(5 * 1000);
        locationSettingsRequest.setFastestInterval(2 * 1000);

        LocationSettingsRequest.Builder builder = new LocationSettingsRequest.Builder()
                .addLocationRequest(locationSettingsRequest)
                .setAlwaysShow(true);

        PendingResult<LocationSettingsResult> result = LocationServices.SettingsApi.checkLocationSettings(mGoogleApiClient, builder.build());
        result.setResultCallback(new ResultCallback<LocationSettingsResult>() {
            @Override
            public void onResult(LocationSettingsResult result) {
                final Status status = result.getStatus();
                Log.e("status", "Status: " + status.getStatusCode());
                switch (status.getStatusCode()) {
                    case LocationSettingsStatusCodes.SUCCESS:
                        // All location settings are satisfied. The client can initialize location requests here.

                        LocationRequest mLocationRequest = new LocationRequest();
                        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
                        mLocationRequest.setInterval(5 * 1000);
                        mLocationRequest.setFastestInterval(2 * 1000);
                        mLocationRequest.setSmallestDisplacement(1);
                        LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, mLocationRequest, CreatePostActivity.this);

                        break;
                    case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
                        // Location settings are not satisfied. But could be fixed by showing the user a dialog.
                        try {
                            // Show the dialog by calling startResolutionForResult(), and check the result in onActivityResult().
                            status.startResolutionForResult(CreatePostActivity.this, 1000);
                        } catch (IntentSender.SendIntentException e) {
                            // Ignore the error.
                        }
                        break;
                    case LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE:
                        // Location settings are not satisfied. However, we have no way to fix the
                        // settings so we won't show the dialog.
                        break;
                }
            }
        });
    }

    @Override
    public Pair<Double, Double> getLatLong() {
        if(mLastLocation != null){
            return new Pair<>(mLastLocation.getLatitude(), mLastLocation.getLongitude());
        }
        return new Pair<>(0d,0d);
    }
    //endregion


    @Override
    public void onLocationChanged(Location location) {
        mLastLocation = location;
    }

}
