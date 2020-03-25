package br.com.lab360.bioprime.ui.adapters.timeline;

import java.util.List;

import br.com.lab360.bioprime.logic.model.pojo.timeline.Banner;
import ss.com.bannerslider.adapters.SliderAdapter;
import ss.com.bannerslider.viewholder.ImageSlideViewHolder;

public class SliderBannerAdapter extends SliderAdapter {

    List<Banner> banners;

    public SliderBannerAdapter(List<Banner> banners){
        this.banners = banners;
    }

    @Override
    public int getItemCount() {
        return banners.size();
    }

    @Override
    public void onBindImageSlide(int position, ImageSlideViewHolder viewHolder) {
        viewHolder.bindImageSlide(banners.get(position).getImageUrl());

    }
}