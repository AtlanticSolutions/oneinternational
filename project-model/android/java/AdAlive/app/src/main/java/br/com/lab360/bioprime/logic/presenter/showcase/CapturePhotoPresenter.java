package br.com.lab360.bioprime.logic.presenter.showcase;

import android.graphics.Bitmap;
import android.graphics.Matrix;

import br.com.lab360.bioprime.ui.view.IBaseView;
import io.fotoapparat.result.BitmapPhoto;
import io.fotoapparat.result.PhotoResult;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

public class CapturePhotoPresenter {
    private ICapturePhotoView view;

    public CapturePhotoPresenter(ICapturePhotoView view) {
        this.view = view;
    }

    public void start() {
        view.configureToolbar();
        view.checkPermissions();
    }

    public void onCameraClick(PhotoResult photoResult) {
        view.showProgress();
        photoResult.toBitmap()
                .whenAvailable(new Function1<BitmapPhoto, Unit>() {
                    @Override
                    public Unit invoke(BitmapPhoto bitmapPhoto) {
                        //gira o bitmap
                        Matrix matrix = new Matrix();
                        matrix.postRotate(-bitmapPhoto.rotationDegrees);
                        Bitmap b = Bitmap.createBitmap(bitmapPhoto.bitmap, 0, 0, bitmapPhoto.bitmap.getWidth(), bitmapPhoto.bitmap.getHeight(), matrix, true);
                        view.hideProgress();
                        view.startShowShowcase(b);
                        return null;
                    }
                });
    }

    public void onFlashClick() {
        view.changeFlash();
    }

    public void onChangeCameraClick() {
        view.changeCamera();
    }

    public void onBackButtonClick() {
        view.onBackPressed();
    }

    public void onPermissionDenied() {
        view.showPermissionNeededSnackMessage();
        view.onBackPressed();
    }

    public void onPermissionAccessRemoved() {
        view.showPermissionNeededSnackMessage();
        view.onBackPressed();
    }

    public void onPermissionGranted() {
        view.startCamera();
    }

    public interface ICapturePhotoView extends IBaseView {

        void setPresenter(CapturePhotoPresenter presenter);

        void startShowShowcase(Bitmap bitmap);

        void onBackPressed();

        void changeCamera();

        void changeFlash();

        void checkPermissions();

        void showPermissionNeededSnackMessage();

        void startCamera();

        void configureToolbar();
    }
}
