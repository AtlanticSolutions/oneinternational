package br.com.lab360.bioprime.ui.viewholder.menu;

import android.content.Context;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;


import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.thoughtbot.expandablerecyclerview.viewholders.GroupViewHolder;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 07/06/2018.
 */

public class ChildMenuItemViewHolder extends GroupViewHolder {

    @BindView(R.id.tvBadgeCount)
    protected TextView tvBadgeCount;
    @BindView(R.id.btnChildMenuItem)
    protected Button btnChildMenuItem;
    @BindView(R.id.ivArrow)
    protected ImageView ivArrow;
    @BindView(R.id.ivChildMenuItem)
    protected ImageView ivChildMenuItem;
    @BindView(R.id.tvFeaturedMessage)
    protected TextView tvFeaturedMessage;
    @BindView(R.id.rvChildMenu)
    protected RecyclerView rvChildMenu;
    @BindView(R.id.rlChildMenuItem)
    protected RelativeLayout rlChildMenuItem;
    @BindView(R.id.llChildMenuItem)
    protected LinearLayout llChildMenuItem;

    public ChildMenuItemViewHolder(View v) {
        super(v);
        ButterKnife.bind(this, v);
    }

    public void setMenuTitle(String title) {
        btnChildMenuItem.setText(title);
    }

    public void setFeaturedMessage(String featuredMessage) {
        tvFeaturedMessage.setText(featuredMessage);
    }

    public void setFeaturedMessageColor(String color) {
        tvFeaturedMessage.setTextColor(Color.parseColor(color));
    }

    public void setBadgeCount(int count) {
        tvBadgeCount.setText(String.valueOf(count));
    }

    public void setChildMenuItemImage(Context context, String image){
        if (image != null) {
            Glide.with(context)
                    .load(image)
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            return false;
                        }
                    }).into(ivChildMenuItem);
        }
    }

    public void isArrowVisible(boolean bool){
        if(bool){
            ivArrow.setVisibility(View.VISIBLE);
        }else{
            ivArrow.setVisibility(View.GONE);
        }
    }

    public void isBadgeVisible(boolean bool){
        if(bool){
            tvBadgeCount.setVisibility(View.VISIBLE);
        }else{
            tvBadgeCount.setVisibility(View.GONE);
        }
    }

    public void isFeaturedMessageVisible(boolean bool){
        if(bool){
            tvFeaturedMessage.setVisibility(View.VISIBLE);
        }else{
            tvFeaturedMessage.setVisibility(View.GONE);
        }
    }

    public void animateExpand() {
        RotateAnimation rotate =
                new RotateAnimation(360, 180, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotate.setDuration(300);
        rotate.setFillAfter(true);
        ivArrow.setAnimation(rotate);
    }

    public void animateCollapse() {
        RotateAnimation rotate =
                new RotateAnimation(180, 360, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotate.setDuration(300);
        rotate.setFillAfter(true);
        ivArrow.setAnimation(rotate);
    }

    public LinearLayout getllChildMenuItem() {
        return llChildMenuItem;
    }

    public ImageView getIvArrow() {
        return ivArrow;
    }

    public RecyclerView getRvSubMenu() {
        return rvChildMenu;
    }
}
