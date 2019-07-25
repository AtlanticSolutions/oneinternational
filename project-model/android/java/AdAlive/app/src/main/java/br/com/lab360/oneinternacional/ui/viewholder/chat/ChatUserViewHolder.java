package br.com.lab360.oneinternacional.ui.viewholder.chat;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatUserViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tvMessage)
    protected TextView tvMessage;

    @Nullable
    @BindView(R.id.tvName)
    protected TextView tvName;

    @Nullable
    @BindView(R.id.tvDate)
    protected TextView tvDate;

    @Nullable
    @BindView(R.id.progress)
    protected ProgressBar progress;

    @Nullable
    @BindView(R.id.ivWarning)
    protected ImageView ivWarning;

    public ChatUserViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setMessage(String message) {
        this.tvMessage.setText(message);
    }

    public void setName(String name) {
        if(tvName == null)
            return;

        this.tvName.setText(name);
    }

    public void setDate(String date) {
        if(tvDate == null)
            return;

        this.tvDate.setText(date);
    }

    public void hideProgress() {
        if (progress == null)
            return;
        progress.setVisibility(View.GONE);
    }

    public void showProgress() {
        if (progress == null)
            return;
        progress.setVisibility(View.VISIBLE);
    }

    public void hideDate() {
        if(tvDate == null)
            return;
        tvDate.setVisibility(View.GONE);
    }

    public void showDate() {
        tvDate.setVisibility(View.VISIBLE);
    }

    public void showWarning() {
        if (ivWarning == null)
            return;
        ivWarning.setVisibility(View.VISIBLE);
    }

    public void hideWarning() {
        if (ivWarning == null)
            return;
        ivWarning.setVisibility(View.GONE);
    }
}
