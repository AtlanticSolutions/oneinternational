package br.com.lab360.oneinternacional.ui.activity.showcase;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.appcompat.app.AlertDialog;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alexvasilkov.gestures.views.GestureImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.gallery.GalleryObject;
import br.com.lab360.oneinternacional.logic.presenter.showcase.GalleryPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.showcase.GalleryGridAdapter;
import br.com.lab360.oneinternacional.utils.GalleryUtils;
import br.com.lab360.oneinternacional.utils.ImageUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 14/05/2018.
 */

public class GalleryImagesActivity extends BaseActivity implements GalleryPresenter.IGalleryView {
    @BindView(R.id.tvEdit)
    protected TextView tvEdit;
    @BindView(R.id.gdGallery)
    protected GridView gdGallery;
    @BindView(R.id.llActions)
    protected LinearLayout llActions;
    @BindView(R.id.galleryConstraintExpand)
    protected ConstraintLayout galleryConstraintExpand;
    @BindView(R.id.galleryIvBtnClose)
    ImageButton galleryIvBtnClose;
    @BindView(R.id.galleryGestureExpanded)
    GestureImageView galleryGestureExpanded;
    @BindView(R.id.galleryTvEmpty)
    TextView galleryTvEmpty;

    public static int STATE_EDIT = 0;
    public static GalleryPresenter presenter;
    public static SharedPrefsHelper sharedPrefsHelper;

    public static List<GalleryObject> imagesFolder;
    public static List<GalleryObject> imagesSelected;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gallery_images);
        ButterKnife.bind(this);

        new GalleryPresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(getString(R.string.LABEL_GALLERY));
    }

    @Override
    public void setPresenter(GalleryPresenter presenter) {
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        this.presenter = presenter;
        this.presenter.start();
    }

    @Override
    public void setupGridView() {
        imagesFolder = GalleryUtils.readImagesGallery();
        if (imagesFolder != null) {
            final GalleryGridAdapter adapter = new GalleryGridAdapter(imagesFolder, this);

            gdGallery.setAdapter(adapter);
            gdGallery.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                public void onItemClick(AdapterView<?> parent, View v, int position, long id) {
                    if (GalleryImagesActivity.STATE_EDIT == 0) {
                        presenter.gridItemClicked(imagesFolder.get(position));
                    }
                }
            });
            if (imagesFolder.isEmpty())
                galleryTvEmpty.setVisibility(View.VISIBLE);
        }

    }

    @Override
    public void expandImage(Bitmap imageBitmap) {
        RequestOptions options = new RequestOptions();
        options.diskCacheStrategy(DiskCacheStrategy.NONE);
        options.skipMemoryCache(true);

        Glide.with(this)
                .load(ImageUtils.bitmapToByte(imageBitmap))
                .apply(options)
                .into(galleryGestureExpanded);
        imageContainerVisibility(true);

        galleryIvBtnClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                imageContainerVisibility(false);
            }
        });
    }

    public void removeImagesGallery() {
        for (int i = 0; imagesSelected.size() > i; i++) {
            GalleryUtils.removeImageGallery(imagesSelected.get(i));
        }
    }

    private void imageContainerVisibility(Boolean show) {
        if (show) {
            galleryConstraintExpand.setVisibility(View.VISIBLE);
            tvEdit.setText("");
            return;
        }
        galleryConstraintExpand.setVisibility(View.GONE);
        tvEdit.setText(R.string.ALERT_OPTION_EDIT);
    }

    public void shareImagesGallery() {
        ArrayList<Bitmap> selectedBitmaps = new ArrayList<>();
        for (GalleryObject g : imagesSelected) {
            selectedBitmaps.add(g.getImageBitmap());
        }
        ImageUtils.shareBitmapArray(this, selectedBitmaps);
    }

    public void dialogRemoveImagesGallery() {
        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle(getString(R.string.SCREEN_TITLE_REMOVE_GALLERY))
                .setMessage(getString(R.string.ALERT_MESSAGE_REMOVE_GALLERY))
                .setPositiveButton(getString(R.string.ALERT_OPTION_CONFIRM), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {

                        removeImagesGallery();

                        STATE_EDIT = 0;
                        tvEdit.setText(R.string.ALERT_OPTION_EDIT);
                        llActions.setVisibility(View.GONE);

                        setupGridView();
                    }
                })
                .setNegativeButton(getString(R.string.ALERT_OPTION_CANCEL), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        dialog.dismiss();
                    }
                }).create();
        dialog.show();
    }

    @OnClick({R.id.tvEdit, R.id.btnShare, R.id.btnRemove})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.txtEdit:
                if (galleryConstraintExpand.getVisibility() != View.VISIBLE) {
                    imagesSelected = new ArrayList<>();
                    if (STATE_EDIT == 1) {
                        STATE_EDIT = 0;
                        tvEdit.setText(R.string.ALERT_OPTION_EDIT);
                        llActions.setVisibility(View.GONE);
                    } else {
                        STATE_EDIT = 1;
                        tvEdit.setText(R.string.ALERT_OPTION_CANCEL);
                        llActions.setVisibility(View.VISIBLE);
                    }
                    setupGridView();
                }
                break;
            case R.id.btnShare:
                shareImagesGallery();
                break;
            case R.id.btnRemove:
                dialogRemoveImagesGallery();
                break;
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                STATE_EDIT = 0;
                Intent intent = new Intent(this, ShowCaseActivity.class);
                startActivity(intent);
                finish();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        STATE_EDIT = 0;
        Intent intent = new Intent(this, ShowCaseActivity.class);
        startActivity(intent);
        finish();
    }
}
