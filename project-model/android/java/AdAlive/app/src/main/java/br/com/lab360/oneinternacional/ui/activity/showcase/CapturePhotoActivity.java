package br.com.lab360.oneinternacional.ui.activity.showcase;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.google.common.base.Strings;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseCategory;
import br.com.lab360.oneinternacional.logic.presenter.showcase.CapturePhotoPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.fotoapparat.Fotoapparat;
import io.fotoapparat.configuration.CameraConfiguration;
import io.fotoapparat.parameter.camera.CameraParameters;
import io.fotoapparat.selector.LensPositionSelectorsKt;
import io.fotoapparat.view.CameraView;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import me.anshulagarwal.simplifypermissions.Permission;

import static io.fotoapparat.selector.FlashSelectorsKt.off;
import static io.fotoapparat.selector.FlashSelectorsKt.torch;
import static io.fotoapparat.selector.LensPositionSelectorsKt.back;
import static io.fotoapparat.selector.LensPositionSelectorsKt.front;

public class CapturePhotoActivity extends BaseActivity implements CapturePhotoPresenter.ICapturePhotoView {

    private static final String SHOWCASE_OBJECTS = "SHOWCASE_OBJECTS";
    private static final int PERMISSION_REQUEST_CODE = 0x33;

    private CapturePhotoPresenter presenter;
    private Fotoapparat cameraView;
    private Boolean flash = false;
    private Boolean frontCamera = false;
    ShowCaseCategory showcase;

    private String[] ACTIVITY_PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.READ_EXTERNAL_STORAGE
    };

    @BindView(R.id.captureCameraView)
    CameraView showcaseCameraView;
    @BindView(R.id.captureToolbar)
    Toolbar captureToolbar;
    @BindView(R.id.captureMask)
    ImageView captureMask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_capture_photo);

        ButterKnife.bind(this);

        Bundle b = getIntent().getExtras();
        if (b != null) {
            showcase = b.getParcelable(SHOWCASE_OBJECTS);
            if (showcase != null)
                frontCamera = showcase.isFrontCameraPreferable();
            loadMask(showcase);
        }

        cameraView = Fotoapparat.with(this)
                .lensPosition(frontCamera ? front() : back())
                .into(showcaseCameraView)
                .build();

        setPresenter(new CapturePhotoPresenter(this));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_capture_photo, menu);
        //Deixa os ícones branco
        for (int i = 0; i < menu.size(); i++) {
            Drawable drawable = menu.getItem(i).getIcon();
            if (drawable != null) {
                drawable.mutate();
                drawable.setColorFilter(getResources().getColor(R.color.white), PorterDuff.Mode.SRC_ATOP);
            }
        }
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menuCapturePhotoFlash:
                presenter.onFlashClick();
                return true;
            case R.id.menuCapturePhotoSwitchCamera:
                presenter.onChangeCameraClick();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        cameraView.stop();
    }

    @OnClick(R.id.captureIvCapture)
    public void onClickCamera(View v) {
        presenter.onCameraClick(cameraView.takePicture());
    }

    @Override
    public void setPresenter(CapturePhotoPresenter presenter) {
        this.presenter = presenter;
        presenter.start();
    }

    @Override
    public void startShowShowcase(Bitmap bitmap) {
        PhotoShowcaseActivity.startActivity(this, showcase, bitmap);
    }

    @Override
    public void changeCamera() {
        cameraView.getCurrentParameters().whenAvailable(new Function1<CameraParameters, Unit>() {
            @Override
            public Unit invoke(CameraParameters cameraParameters) {
                cameraView.switchTo(frontCamera ? LensPositionSelectorsKt.back() : LensPositionSelectorsKt.front(),
                        CameraConfiguration.builder().build());
                frontCamera = !frontCamera;
                if (frontCamera) flash = false;
                return Unit.INSTANCE;
            }
        });
    }

    @Override
    public void changeFlash() {
        if (frontCamera) {
            showToastMessage(getString(R.string.msg_flash_unavaiable));
            return;
        }
        cameraView.getCurrentParameters().whenAvailable(new Function1<CameraParameters, Unit>() {
            @Override
            public Unit invoke(CameraParameters cameraParameters) {
                cameraView.updateConfiguration(
                        CameraConfiguration.builder()
                                .flash(flash ? off() : torch())
                                .build()
                );
                flash = !flash;
                return Unit.INSTANCE;
            }
        });
    }

    public void loadMask(ShowCaseCategory showCaseCategory) {
        showProgress();
        Glide.with(this)
                .load(showCaseCategory.maskModelURL)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        hideProgress();
                        showToastMessage("Não foi possível carregar a máscara");
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        hideProgress();
                        return false;
                    }
                })
                .into(captureMask);
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
                        presenter.onPermissionGranted();
                    }

                    @Override
                    public void onPermissionDenied(int requestCode) {
                        presenter.onPermissionDenied();
                    }

                    @Override
                    public void onPermissionAccessRemoved(int requestCode) {
                        presenter.onPermissionAccessRemoved();
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
                return;
            }
            presenter.onPermissionGranted();
        }
    }

    @Override
    public void showPermissionNeededSnackMessage() {
        showSnackMessage(getString(R.string.DIALOG_PROFILE_MESSAGE_PERMISSION));
    }

    @Override
    public void startCamera() {
        if (cameraView != null)
            cameraView.start();
    }

    @Override
    public void configureToolbar() {
        setSupportActionBar(captureToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeAsUpIndicator(ContextCompat.getDrawable(this, R.drawable.ic_arrow_back_white_24dp));
        String topColor = UserUtils.getBackgroundColor(this);
        if (!Strings.isNullOrEmpty(topColor)) {
            ScreenUtils.updateStatusBarcolor(this, topColor);
            captureToolbar.setBackgroundColor(Color.parseColor(topColor));
        }
    }

    public static void startActivity(AppCompatActivity activity, ShowCaseCategory showCaseCategory) {
        Intent intent = new Intent(activity, CapturePhotoActivity.class);
        Bundle b = new Bundle();
        b.putParcelable(SHOWCASE_OBJECTS, showCaseCategory);
        intent.putExtras(b);
        activity.startActivity(intent);
    }
}
