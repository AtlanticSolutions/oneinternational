package br.com.lab360.oneinternacional.ui.activity.showcase;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseGalery;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseProduct;
import br.com.lab360.oneinternacional.logic.presenter.showcase.ShowCasePresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.showcase.ShowCaseRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCaseActivity extends BaseActivity implements ShowCasePresenter.IShowCaseView {
    @BindView(R.id.rvShowCase)
    protected RecyclerView rvShowCase;
    @BindView(R.id.showCaseBanner)
    protected ImageView showCaseBanner;
    @BindView(R.id.showCaseBannerText)
    protected TextView showCaseBannerText;
    @BindView(R.id.showCaseBannerTextMessage)
    protected TextView showCaseBannerTextMessage;

    private ShowCasePresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_showcase);
        ButterKnife.bind(this);
        new ShowCasePresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(getString(R.string.SCREEN_SHOWCASE));
    }

    @Override
    public void setPresenter(ShowCasePresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void setupRecyclerView(final ShowCaseGalery showCaseGalery) {
        final ShowCaseRecyclerAdapter adapter = new ShowCaseRecyclerAdapter(showCaseGalery.getCategories(), this);
        loadBanner(showCaseGalery.getBannerURL(), showCaseGalery.getTitle(), showCaseGalery.getMessage());
        rvShowCase.setAdapter(adapter);
        rvShowCase.setHasFixedSize(true);
        rvShowCase.setLayoutManager(new GridLayoutManager(getApplication(), 2));
        rvShowCase.addOnItemTouchListener(new RecyclerItemClickListener(this, rvShowCase, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                CapturePhotoActivity.startActivity(ShowCaseActivity.this, showCaseGalery.getCategories().get(position));

                for (ShowCaseProduct p : showCaseGalery.getCategories().get(position).getProducts()) {
                    Glide.with(ShowCaseActivity.this)
                            .load(p.maskURL)
                            .preload();
                    Glide.with(ShowCaseActivity.this)
                            .load(p.pictureURL)
                            .preload();
                }
            }

            @Override
            public void onItemLongClick(View view, int position) {
            }
        }));
    }

    @Override
    public void emptyShowCase() {
        showToastMessage(getString(R.string.EMPTY_SHOWCASE));
    }

    private void loadBanner(String bannerURL, final String description, final String message) {
        Glide.with(this)
                .load(bannerURL)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        showCaseBannerText.setVisibility(View.VISIBLE);
                        showCaseBannerText.setText(description);
                        showCaseBannerTextMessage.setVisibility(View.VISIBLE);
                        showCaseBannerTextMessage.setText(message);
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        showCaseBanner.setVisibility(View.VISIBLE);
                        return false;
                    }
                })
                .into(showCaseBanner)
        ;
    }

    @OnClick(R.id.ivGallery)
    protected void onIvGalleryTouched() {
        Intent intent = new Intent(this, GalleryImagesActivity.class);
        startActivity(intent);
    }
}
