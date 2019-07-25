package br.com.lab360.oneinternacional.ui.adapters.videos;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;

import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Video;
import br.com.lab360.oneinternacional.ui.viewholder.videos.VideoFeedViewHolder;
import br.com.lab360.oneinternacional.utils.ScreenUtils;


/**
 * Created by Alessandro Valenza on 26/10/2016.
 */
public class VideoFeedRecyclerAdapter extends RecyclerView.Adapter<VideoFeedViewHolder> {

    private List<Video> videos;
    private Context context;
    private int lastAnimatedPosition = -1;

    public VideoFeedRecyclerAdapter(List<Video> videos, Context context) {
        this.videos = videos;
        this.context = context;
    }

    @Override
    public VideoFeedViewHolder onCreateViewHolder(ViewGroup parent,
                                                  int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_video_feed_list_item, parent, false);
        return new VideoFeedViewHolder(v);
    }

    @Override
    public void onBindViewHolder(final VideoFeedViewHolder holder, final int position) {

        runEnterAnimation(holder.getItemView(), position);

        Video video = videos.get(position);

        if (video != null) {

            holder.setTitle(video.getTitle());
            holder.setThumb(video.getThumb(), context);
            holder.setTime(video.getDuration());
            holder.setAuthor(video.getAuthor());

        }

    }

    @Override
    public int getItemCount() {
        return videos.size();
    }

    public Video getVideo(int position) {
        return videos.get(position);
    }

    private void runEnterAnimation(View view, int position) {

        if (position > lastAnimatedPosition) {
            lastAnimatedPosition = position;
            view.setTranslationY(ScreenUtils.getScreenHeight(context));
            view.animate()
                    .translationY(0)
                    .setInterpolator(new DecelerateInterpolator(3.f))
                    .setDuration(700)
                    .start();
        }
    }

}