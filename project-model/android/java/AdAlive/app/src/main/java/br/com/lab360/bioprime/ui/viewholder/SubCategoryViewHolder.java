package br.com.lab360.bioprime.ui.viewholder;

import android.content.Context;

import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 25/04/2018.
 */

public class SubCategoryViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.ll_container)
    protected LinearLayout itemView;

    @BindView(R.id.tvTitle)
    protected TextView tvTitle;

    @BindView(R.id.ivThumb)
    protected ImageView ivThumb;

    public SubCategoryViewHolder(View v) {
        super(v);
        ButterKnife.bind(this, v);
    }

    public LinearLayout getItemView() {
        return itemView;
    }

    public void setTitle(String title) {
        tvTitle.setText(title);
    }


    public void setThumb(String thumb, Context context) {
        if (thumb != null && !TextUtils.isEmpty(thumb)) {
            Glide.with(context)
                    .load(thumb)
                    .into(ivThumb);

        }
    }
}