package br.com.lab360.bioprime.ui.viewholder.showcase;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

public class MiniShowCaseViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.showcaseMiniItemIv)
    protected ImageView showcaseMiniItemIv;

    public MiniShowCaseViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setShowcase(String imgUrl, Context context) {
        if (imgUrl != null) {
            Glide.with(context)
                    .load(imgUrl)
                    .into(showcaseMiniItemIv);
        }
    }
}