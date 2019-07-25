package br.com.lab360.oneinternacional.ui.activity.showcase;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.viewpager.widget.ViewPager;
import androidx.appcompat.widget.Toolbar;

import com.google.common.base.Strings;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.ui.activity.NavigationDrawerActivity;
import br.com.lab360.oneinternacional.ui.adapters.showcase.SliderAdapter;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 18/05/2018.
 */

public class GallerySliderActivity extends NavigationDrawerActivity {


    @BindView(R.id.viewPager)
    ViewPager viewPager;

    List<Bitmap> imagesGallery = new ArrayList<>();
    int defaultPosition;
    SharedPrefsHelper sharedPrefsHelper;
    Gson gson;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_gallery_slider);
        ButterKnife.bind(this);

        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        gson = new Gson();

        imagesGallery = Arrays.asList(gson.fromJson( sharedPrefsHelper.get("imagesBitmap", ""), Bitmap[].class));
        defaultPosition = sharedPrefsHelper.get("positionItem", 0);

        SliderAdapter adapter = new SliderAdapter(this,imagesGallery, defaultPosition);
        viewPager.setAdapter(adapter);
        viewPager.setCurrentItem(defaultPosition);

        initToolbar();
    }


    public void initToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        setToolbarTitle(R.string.SCREEN_SHOWCASE);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

}
