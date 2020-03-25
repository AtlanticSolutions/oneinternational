package br.com.lab360.bioprime.ui.activity.showcase;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.constraintlayout.widget.ConstraintLayout;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestOptions;
import com.google.android.material.floatingactionbutton.FloatingActionButton;
import com.google.android.material.snackbar.Snackbar;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.alexvasilkov.gestures.views.GestureImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.google.common.base.Strings;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseCategory;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseProduct;
import br.com.lab360.bioprime.logic.presenter.showcase.PhotoShowcasePresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.adapters.showcase.MiniShowCaseRecyclerAdapter;
import br.com.lab360.bioprime.utils.ImageUtils;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PhotoShowcaseActivity extends BaseActivity implements PhotoShowcasePresenter.IPhotoShowcasePresenter, MiniShowCaseRecyclerAdapter.OnMiniClicked {

    private static final String SHOWCASE_OBJECTS = "SHOWCASE_OBJECTS";
    private static final String SHOWCASE_USER_PIC = "SHOWCASE_USER_PIC";

    ShowCaseCategory showcase;
    PhotoShowcasePresenter presenter;
    MiniShowCaseRecyclerAdapter adapter;
    File userBitmap;

    @BindView(R.id.photoShowcaseIvMask)
    GestureImageView photoShowcaseIvMask;
    @BindView(R.id.photoShowcaseIvUserPhoto)
    ImageView photoShowcaseIvUserPhoto;
    @BindView(R.id.photoShowcaseRvMasks)
    RecyclerView photoShowcaseRvMasks;
    @BindView(R.id.photoShowcaseConstraint)
    ConstraintLayout photoShowcaseConstraint;
    @BindView(R.id.photoShowcaseIvRemove)
    FloatingActionButton photoShowcaseIvRemove;
    @BindView(R.id.photoShowcaseIvAdd)
    FloatingActionButton photoShowcaseIvAdd;
    @BindView(R.id.photoShowcaseToolbar)
    Toolbar photoShowcaseToolbar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_photo_showcase);

        ButterKnife.bind(this);
        configureToolbar();

        Bundle b = getIntent().getExtras();

        if (b != null) {
            showcase = b.getParcelable(SHOWCASE_OBJECTS);
            if (showcase != null) setToolbarTitle(showcase.name);

            userBitmap = new File(getCacheDir(), SHOWCASE_USER_PIC);
            Uri userPhotoUri = Uri.fromFile(userBitmap);

            RequestOptions options = new RequestOptions();
            options.diskCacheStrategy(DiskCacheStrategy.NONE);
            options.skipMemoryCache(true);

            Glide.with(PhotoShowcaseActivity.this)
                    .load(userPhotoUri)
                    .apply(options)
                    .into(photoShowcaseIvUserPhoto);

            Glide.with(PhotoShowcaseActivity.this)
                    .load(showcase.getProducts().get(0).maskURL)
                    .into(photoShowcaseIvMask);
        }

        new PhotoShowcasePresenter(this);
        loadMask();
    }

    @Override
    public void setPresenter(PhotoShowcasePresenter presenter) {
        this.presenter = presenter;
        presenter.start();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (userBitmap.exists())
            userBitmap.delete();
    }

    @Override
    public void setupRecyclerView() {
        if (showcase != null)
            adapter = new MiniShowCaseRecyclerAdapter(showcase.getProducts(), this, this);

        photoShowcaseRvMasks.setAdapter(adapter);
        photoShowcaseRvMasks.setHasFixedSize(true);
        photoShowcaseRvMasks.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false));
    }

    @OnClick({R.id.photoShowcaseIvAdd, R.id.photoShowcaseIvRemove})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.photoShowcaseIvAdd:
                presenter.onAddClicked();
                break;
            case R.id.photoShowcaseIvRemove:
                presenter.onRemoveClicked();
                break;
        }
    }

    private void loadMask() {
        Glide.with(this)
                .load(showcase.maskModelURL)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        photoShowcaseIvMask.setImageDrawable(resource);
                        configGestureImageViewProperties(photoShowcaseIvMask);
                        return false;
                    }
                })
                .preload();
    }

    @Override
    public void addAnotherLayerImage() {
        GestureImageView newImageView = new GestureImageView(this);
        ConstraintLayout.LayoutParams params = (ConstraintLayout.LayoutParams) photoShowcaseIvMask.getLayoutParams();
        photoShowcaseConstraint.addView(newImageView, -1, params);

        configGestureImageViewProperties(newImageView);

        Glide.with(this)
                .load(showcase.getProducts().get(0).maskURL)
                .into(newImageView);

        showSnackbar("Máscara extra adicionada");

        photoShowcaseIvRemove.setVisibility(View.VISIBLE);
    }

    @Override
    public void removeImageLayer() {
        ArrayList<Integer> gestureViewIds = getGestureViewId(photoShowcaseConstraint);
        if (gestureViewIds.size() > 1) {
            int topViewId = gestureViewIds.get(gestureViewIds.size() - 1);
            photoShowcaseConstraint.removeViewAt(topViewId);
            gestureViewIds.remove(gestureViewIds.size() - 1);
        }

        if (gestureViewIds.size() == 1)
            photoShowcaseIvRemove.setVisibility(View.GONE);

        showSnackbar("Máscara extra removida");
    }

    private void configGestureImageViewProperties(GestureImageView gestureImageView) {
        gestureImageView.getController()
                .getSettings()
                .setMinZoom(0.5f)
                .setRotationEnabled(true)
                .disableBounds();
    }

    private ArrayList<Integer> getGestureViewId(ConstraintLayout constraintLayout) {
        ArrayList<Integer> gestureViewIds = new ArrayList<>();
        for (int i = 0; i < constraintLayout.getChildCount(); i++) {
            if (constraintLayout.getChildAt(i) instanceof GestureImageView) {
                gestureViewIds.add(i);
            }
        }
        return gestureViewIds;
    }

    @Override
    public void onItemClick(ShowCaseProduct showCaseProduct) {
        ArrayList<Integer> gestureViewIds = getGestureViewId(photoShowcaseConstraint);
        int topViewId = gestureViewIds.get(gestureViewIds.size() - 1);
        Glide.with(this)
                .load(showCaseProduct.maskURL)
                .into((GestureImageView) photoShowcaseConstraint.getChildAt(topViewId));
        showSnackbar(showCaseProduct.name);
    }

    private void showSnackbar(String text) {
        View view = findViewById(R.id.photoShowcaseCoodinator);
        Snackbar snack = Snackbar.make(view, text, Snackbar.LENGTH_SHORT);

        String topColor = UserUtils.getBackgroundColor(this);
        snack.getView().setBackgroundColor(Color.parseColor(topColor));

        TextView textView = (TextView) snack.getView().findViewById(com.google.android.material.R.id.snackbar_text);
        textView.setTextColor(getResources().getColor(R.color.white));
        snack.show();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_showcase_photo, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menuPhotoShowcaseFinish:
                SavePictureActivity.startActivity(this, generateCombinedBitmap());
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private Bitmap generateCombinedBitmap() {
        ArrayList<Integer> gestureIds = getGestureViewId(photoShowcaseConstraint);
        ArrayList<Bitmap> bitmaps = new ArrayList<>();

        for (int id : gestureIds) {
            View v = photoShowcaseConstraint.getChildAt(id);
            bitmaps.add(ImageUtils.getViewBitmap(v));
        }

        Bitmap combinedBitmap = ImageUtils.getViewBitmap(photoShowcaseIvUserPhoto);

        for (Bitmap b :
                bitmaps) {
            combinedBitmap = ImageUtils.mergeTwoBitmaps(combinedBitmap, b);
        }

        return combinedBitmap;
    }

    private void configureToolbar() {
        setSupportActionBar(photoShowcaseToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeAsUpIndicator(ContextCompat.getDrawable(this, R.drawable.ic_arrow_back_white_24dp));
        String topColor = UserUtils.getBackgroundColor(this);
        if (!Strings.isNullOrEmpty(topColor)) {
            ScreenUtils.updateStatusBarcolor(this, topColor);
            photoShowcaseToolbar.setBackgroundColor(Color.parseColor(topColor));
        }
    }

    private void setToolbarTitle(String title) {
        if (getSupportActionBar() != null)
            getSupportActionBar().setTitle(title);
    }

    public static void startActivity(BaseActivity activity, ShowCaseCategory showCaseCategory, Bitmap userPhoto) {
        Bundle b = new Bundle();
        b.putParcelable(SHOWCASE_OBJECTS, showCaseCategory);
        Intent intent = new Intent(activity, PhotoShowcaseActivity.class);
        intent.putExtras(b);

        FileOutputStream outStream;
        try {
            File userPhotoFile = new File(activity.getCacheDir(), SHOWCASE_USER_PIC);
            if (userPhotoFile.exists()) userPhotoFile.delete();
            outStream = new FileOutputStream(userPhotoFile);
            userPhoto.compress(Bitmap.CompressFormat.JPEG, 75, outStream);
            outStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        activity.startActivity(intent);
    }
}
