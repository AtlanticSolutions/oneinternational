package br.com.lab360.oneinternacional.ui.viewholder.showcase;

import android.content.Context;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCaseViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tvCategory)
    protected TextView tvCategory;

    @BindView(R.id.ivCategory)
    protected ImageView ivCategory;


    public ShowCaseViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setCategory(String title) {
        tvCategory.setText(title);
    }


    public void setIvCategory(String thumb, Context context) {
        if (thumb == null || thumb.isEmpty())
            return;

        Glide.with(context)
                .load(thumb)
                .into(ivCategory);
    }
}