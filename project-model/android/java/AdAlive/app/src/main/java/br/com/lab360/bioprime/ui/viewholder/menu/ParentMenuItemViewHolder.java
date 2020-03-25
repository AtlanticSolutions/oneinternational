package br.com.lab360.bioprime.ui.viewholder.menu;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;

import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.thoughtbot.expandablerecyclerview.viewholders.GroupViewHolder;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 07/06/2018.
 */

public class ParentMenuItemViewHolder extends GroupViewHolder {

    @BindView(R.id.tvBadgeCount)
    protected TextView tvBadgeCount;
    @BindView(R.id.btnMenuItem)
    protected Button btnMenuItem;
    @BindView(R.id.ivArrow)
    protected ImageView ivArrow;
    @BindView(R.id.ivMenuItem)
    protected ImageView ivMenuItem;
    @BindView(R.id.tvFeaturedMessage)
    protected TextView tvFeaturedMessage;
    @BindView(R.id.rvChildMenu)
    protected RecyclerView rvChildMenu;
    @BindView(R.id.rlMenuItem)
    protected RelativeLayout rlMenuItem;
    @BindView(R.id.llMenuItem)
    protected LinearLayout llMenuItem;

    public ParentMenuItemViewHolder(View v) {
        super(v);
        ButterKnife.bind(this, v);
    }

    public void setMenuTitle(Context context, String title, String identifier) {
        if(identifier.contains("mock")){
            btnMenuItem.setTypeface(Typeface.DEFAULT_BOLD);
            llMenuItem.setBackgroundColor(context.getResources().getColor(R.color.gray_btn_bg_color));
        }
        btnMenuItem.setText(title);
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

    public void setMenuItemImage(Context context, String image){
        if (image != null) {
            Glide.with(context)
                    .load(image)
                   .into(ivMenuItem);
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

    public LinearLayout getllMenuItem() {
        return llMenuItem;
    }

    public ImageView getIvArrow() {
        return ivArrow;
    }

    public RecyclerView getRvSubMenu() {
        return rvChildMenu;
    }
}
