package br.com.lab360.bioprime.ui.viewholder.videos;

import android.content.Context;
import android.graphics.drawable.Drawable;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.utils.DateUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Victor Santiago on 06/12/2016.
 */
public class VideoFeedViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.ll_container)
    protected LinearLayout itemView;
    @BindView(R.id.tvTitle)
    protected TextView tvTitle;
    @BindView(R.id.tvTime)
    protected TextView tvTime;
    @BindView(R.id.tvAuthor)
    protected TextView tvAuthor;
    @BindView(R.id.progress)
    protected ProgressBar progressBar;
    @BindView(R.id.ivThumb)
    protected ImageView ivThumb;

    public VideoFeedViewHolder(View v) {
        super(v);
        ButterKnife.bind(this, v);
    }

    public LinearLayout getItemView() {
        return itemView;
    }

    public void setTitle(String title) {
        tvTitle.setText(title);
    }

    public void setTime(int time) {
        String formattedTime = DateUtils.secondsToMinuteAndSeconds(time);
        tvTime.setText(formattedTime);
    }

    public void setAuthor(String author) {
        tvAuthor.setText(author);
    }

    public void setThumb(String thumb, Context context) {
        if (thumb != null) {
            Glide.with(context)
                    .load(thumb)
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            progressBar.setVisibility(View.GONE);
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            progressBar.setVisibility(View.GONE);
                            return false;
                        }
                    }).into(ivThumb);
        }
    }
}