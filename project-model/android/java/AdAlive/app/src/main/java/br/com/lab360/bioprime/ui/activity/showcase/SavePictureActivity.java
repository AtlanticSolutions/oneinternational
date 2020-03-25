package br.com.lab360.bioprime.ui.activity.showcase;

import android.content.Intent;
import android.content.res.ColorStateList;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.view.ViewCompat;
import androidx.appcompat.widget.AppCompatButton;
import androidx.appcompat.widget.AppCompatImageButton;
import androidx.appcompat.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;

import com.alexvasilkov.gestures.views.GestureImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;
import com.google.common.base.Strings;

import java.io.File;
import java.io.FileOutputStream;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.presenter.showcase.SavePicturePresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.utils.GalleryUtils;
import br.com.lab360.bioprime.utils.ImageUtils;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SavePictureActivity extends BaseActivity implements SavePicturePresenter.ISavePicturePresenter {

    private static final String USER_PIC = "USER_PIC";

    private SavePicturePresenter presenter;

    @BindView(R.id.savePictureToolbar)
    Toolbar savePictureToolbar;
    @BindView(R.id.savePictureIvPhoto)
    ImageView savePictureIvPhoto;
    @BindView(R.id.savePictureBtnShare)
    AppCompatButton savePictureBtnShare;
    @BindView(R.id.savePictureBtnSave)
    AppCompatImageButton savePictureBtnSave;
    @BindView(R.id.savePictureFrame)
    FrameLayout savePictureFrame;
    @BindView(R.id.activitySaveConstraintExpand)
    ConstraintLayout activitySaveConstraintExpand;
    @BindView(R.id.activitySaveIvBtnClose)
    ImageButton activitySaveIvBtnClose;
    @BindView(R.id.activitySaveGestureExpanded)
    GestureImageView activitySaveGestureExpanded;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_save_picture);
        ButterKnife.bind(this);

        new SavePicturePresenter(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_save_photo, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menuSaveOk:
                startActivity(new Intent(this, ShowCaseActivity.class));
                return true;
            case R.id.menuSaveGalery:
                startActivity(new Intent(this, GalleryImagesActivity.class));
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void setPresenter(SavePicturePresenter presenter) {
        this.presenter = presenter;
        presenter.start();
    }

    @Override
    public void loadUserImage() {
        RequestOptions options = new RequestOptions();
        options.diskCacheStrategy(DiskCacheStrategy.NONE);
        options.skipMemoryCache(true);

        Glide.with(this)
                .load(userPhotoUri())
                .apply(options)
                .into(savePictureIvPhoto);
    }

    @Override
    public void openShare() {
        Bitmap framedBitmap = ImageUtils.getViewBitmap(savePictureFrame);
        ImageUtils.shareBitmap(this, framedBitmap);
    }

    @Override
    public void saveImageToGallery() {
        GalleryUtils.saveImageGallery(ImageUtils.getViewBitmap(savePictureFrame));
        savePictureBtnSave.setImageResource(R.drawable.ic_favorite);
        savePictureBtnSave.setColorFilter(Color.RED);
    }

    @Override
    public void configureToolbarAndButtonColors() {
        setSupportActionBar(savePictureToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeAsUpIndicator(ContextCompat.getDrawable(this, R.drawable.ic_arrow_back_white_24dp));
        String topColor = UserUtils.getBackgroundColor(this);
        if (!Strings.isNullOrEmpty(topColor)) {
            ScreenUtils.updateStatusBarcolor(this, topColor);
            savePictureToolbar.setBackgroundColor(Color.parseColor(topColor));
        }

        ViewCompat.setBackgroundTintList(savePictureBtnShare, ColorStateList.valueOf(Color.parseColor(topColor)));
        ViewCompat.setBackgroundTintList(savePictureBtnSave, ColorStateList.valueOf(Color.parseColor(topColor)));
    }


    @Override
    public void expandUserImage() {
        activitySaveConstraintExpand.setVisibility(View.VISIBLE);
        activitySaveConstraintExpand.bringToFront();
        savePictureBtnShare.setVisibility(View.GONE);

        activitySaveGestureExpanded.getController()
                .getSettings()
                .setMaxZoom(3f);

        Glide.with(this)
                .load(ImageUtils.bitmapToByte(ImageUtils.getViewBitmap(savePictureFrame)))
                .into(activitySaveGestureExpanded);
    }

    @Override
    public void closeExpandedUserImage() {
        activitySaveConstraintExpand.setVisibility(View.GONE);
        savePictureBtnShare.setVisibility(View.VISIBLE);
    }

    @OnClick({R.id.savePictureBtnSave, R.id.savePictureBtnShare, R.id.savePictureFrame, R.id.activitySaveIvBtnClose})
    void onClick(View v) {
        switch (v.getId()) {
            case R.id.savePictureBtnSave:
                presenter.onSaveClicked();
                break;
            case R.id.savePictureBtnShare:
                presenter.onShareClicked();
                break;
            case R.id.savePictureFrame:
                presenter.onPictureFrameClicked();
                break;
            case R.id.activitySaveIvBtnClose:
                presenter.onCloseBtnClicked();
                break;
        }
    }

    private Uri userPhotoUri() {
        return FileProvider.getUriForFile(this,
                AdaliveConstants.FILE_PROVIDER_URI,
                new File(getCacheDir(), USER_PIC));
    }

    public static void startActivity(BaseActivity activity, Bitmap userPhoto) {
        FileOutputStream outStream;
        try {
            File userPhotoFile = new File(activity.getCacheDir(), USER_PIC);
            if (userPhotoFile.exists()) userPhotoFile.delete();
            outStream = new FileOutputStream(userPhotoFile);
            userPhoto.compress(Bitmap.CompressFormat.JPEG, 100, outStream);
            outStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        activity.startActivity(new Intent(activity, SavePictureActivity.class));
    }
}
