package br.com.lab360.oneinternacional.ui.adapters;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.CountDownTimer;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.common.base.Strings;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.videos.Video;
import br.com.lab360.oneinternacional.ui.activity.mediaplayer.MediaPlayerActivity;
import br.com.lab360.oneinternacional.ui.viewholder.VideoViewHolder;

/**
 * Created by Edson on 02/05/2018.
 */

public class VideoRecyclerAdapter extends RecyclerView.Adapter<VideoViewHolder> {
    private final Context context;
    private List<Video> items;
    private CountDownTimer countDownTimer;
    private Activity act;
    MediaPlayer mPlayer;
    float volumeContol = 0.0f;

    public VideoRecyclerAdapter(List<Video> items, Activity act, Context context) {
        this.items = items;
        this.context = context;
        this.act = act;
    }

    public VideoRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public VideoViewHolder onCreateViewHolder(ViewGroup parent,
                                              int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_video_item, parent, false);
        return new VideoViewHolder(v);
    }

    @Override
    public void onBindViewHolder(final VideoViewHolder holder, final int position) {
        final Video item = items.get(position);

        holder.setTitle(item.getName());
        holder.loadImage(context, item.getThumb());

        if (Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.hideVideo();
        } else {
            holder.loadVideo(context, item.getHrefVideo());
        }

        if (!Strings.isNullOrEmpty(item.getThumb()) && !Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.getPlayButton().setVisibility(View.GONE);
            holder.loadVideo(context, item.getHrefVideo());
            holder.loadImage(context, item.getThumb());
        }

        if (Strings.isNullOrEmpty(item.getThumb()) && !Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.hidePhoto();
            holder.getPlayButton().setVisibility(View.VISIBLE);
            holder.getVideoView().setVisibility(View.VISIBLE);
            holder.loadVideo(context, item.getHrefVideo());
        }

        volumeContol = 0.0f;
        holder.getVideoView().setOnPreparedListener(new MediaPlayer.OnPreparedListener() {

            @Override
            public void onPrepared(MediaPlayer mp) {
                mPlayer = mp;
                mp.setVolume(volumeContol, volumeContol);
            }
        });


        if(holder.getCounterTimer() != 0){
            holder.setCounterTimer(0);
        }

        holder.getIvSound().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(volumeContol == 0.0f){
                    volumeContol = 0.8f;
                    mPlayer.setVolume(volumeContol, volumeContol);
                    holder.getIvSound().setImageResource(R.drawable.ic_no_sound);
                }else {
                    volumeContol = 0.0f;
                    mPlayer.setVolume(volumeContol, volumeContol);
                    holder.getIvSound().setImageResource(R.drawable.ic_sound);
                }

            }
        });

        holder.getIvPause().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!holder.getVideoView().isPlaying()){
                    holder.getVideoView().start();
                    holder.isCountDownPaused(false);
                    holder.getIvPause().setImageResource(R.drawable.ic_pause);

                }else{
                    holder.getVideoView().pause();
                    holder.getIvPause().setImageResource(R.drawable.ic_play_button);
                    holder.isCountDownPaused(true);
                }
            }
        });

        if(holder.getVideoView().isPlaying()){
            holder.getCountDownTimer().setVisibility(View.VISIBLE);
            holder.getProgressBar().setVisibility(View.VISIBLE);
        }else{
            holder.getCountDownTimer().setVisibility(View.GONE);
            holder.getProgressBar().setVisibility(View.GONE);
        }

        holder.getVideoFrame().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (Strings.isNullOrEmpty(item.getHrefVideo())) {
                    return;
                }

                holder.getVideoView().setVisibility(View.VISIBLE);
                if(!holder.getVideoView().isPlaying()){
                    holder.playVideo();
                    holder.hidePhoto();
                    holder.getLayPlayButton().setVisibility(View.GONE);
                    holder.initialCount(context);

                }else{
                    if(holder.getControlPanel().getVisibility() == View.GONE){
                        holder.getControlPanel().setVisibility(View.VISIBLE);
                    }else {
                        holder.getControlPanel().setVisibility(View.GONE);
                    }
                }
            }
        });

        holder.getIvFullScreen().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                /*
                holder.isCountDownPaused(true);
                holder.getLayPlayButton().setVisibility(View.VISIBLE);
                holder.getCountDownTimer().setVisibility(View.GONE);
                holder.getProgressBar().setVisibility(View.GONE);
                holder.getControlPanel().setVisibility(View.GONE);
                */
                Intent i = new Intent(context, MediaPlayerActivity.class);
                i.putExtra("currentPos", holder.getVideoView().getCurrentPosition());
                i.putExtra("videoUrl", item.getHrefVideo());
                act.startActivity(i);
                holder.getVideoView().stopPlayback();
            }
        });
    }


    @Override
    public void onViewRecycled(VideoViewHolder holder) {
        super.onViewRecycled(holder);
        holder.resetVideoViews();

    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public interface OnVideoClicked {
        void onItemClick(Video video);
    }

    public Video getVideo(int position) {
        return items.get(position);
    }
    public void replaceAll(ArrayList<Video> files) {
        items.clear();
        items.addAll(files);
        notifyDataSetChanged();
    }
}
