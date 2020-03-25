package br.com.lab360.bioprime.ui.decorator;

import android.content.Context;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;

import ss.com.bannerslider.ImageLoadingService;

public class SliderBannerLoader implements ImageLoadingService {
    public Context context;

    public SliderBannerLoader(Context context) {
        this.context = context;
    }

    @Override
    public void loadImage(String url, ImageView imageView) {
       Glide.with(context).load(url).into(imageView);
    }

    @Override
    public void loadImage(int resource, ImageView imageView) {
        Glide.with(context).load(resource).into(imageView);
    }

    @Override
    public void loadImage(String url, int placeHolder, int errorDrawable, ImageView imageView) {
        RequestOptions options = new RequestOptions();
        options.placeholder(placeHolder);

        Glide.with(context).load(url).apply(options).into(imageView);
    }
}