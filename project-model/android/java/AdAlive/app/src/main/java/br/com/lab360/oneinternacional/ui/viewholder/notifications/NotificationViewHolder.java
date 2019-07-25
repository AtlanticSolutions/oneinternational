package br.com.lab360.oneinternacional.ui.viewholder.notifications;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;


public class NotificationViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tvTitle)
    protected TextView tvTitle;

    @BindView(R.id.iv_arrow_right)
    protected ImageView ivArrowRight;


    public NotificationViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setTitle(String title){
        tvTitle.setText(title);
    }

    public ImageView getIvArrowRight() {
        return ivArrowRight;
    }
}