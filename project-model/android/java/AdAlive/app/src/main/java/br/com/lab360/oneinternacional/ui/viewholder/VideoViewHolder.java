package br.com.lab360.oneinternacional.ui.viewholder;

import android.app.Activity;
import android.content.Context;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Handler;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.VideoView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions;
import com.bumptech.glide.request.RequestOptions;

import java.util.Timer;
import java.util.TimerTask;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 02/05/2018.
 */

public class VideoViewHolder  extends RecyclerView.ViewHolder {

    @BindView(R.id.videoView)
    protected VideoView videoView;

    @BindView(R.id.ivFullScreen)
    protected ImageView ivFullScreen;

    @BindView(R.id.playButton)
    protected ImageView playButton;

    @BindView(R.id.ivPhoto)
    protected ImageView ivPhoto;

    @BindView(R.id.videoFrame)
    protected FrameLayout videoFrame;

    @BindView(R.id.tvCountDownTimer)
    protected TextView tvCountDownTimer;

    @BindView(R.id.videoProgressBar)
    protected ProgressBar videoProgressBar;

    @BindView(R.id.llControlPanel)
    protected LinearLayout llControlPanel;

    @BindView(R.id.ivSound)
    protected ImageView ivSound;

    @BindView(R.id.ivPause)
    protected ImageView ivPause;

    @BindView(R.id.tvTitle)
    protected TextView tvTitle;

    @BindView(R.id.llPlayButton)
    protected LinearLayout llPlayButton;

    private boolean isPaused = false;
    int countDown = 0;
    public Timer t;
    public TimerTask timerTask;

    public VideoViewHolder(View v) {
        super(v);
        ButterKnife.bind(this, v);
    }


    public void loadImage(Context context, String url) {
        ivPhoto.setVisibility(View.VISIBLE);

        RequestOptions options = new RequestOptions();
        options.placeholder(R.drawable.ic_picture_placeholder);
        options.fitCenter();

        DrawableTransitionOptions transitionOptions = new DrawableTransitionOptions();
        transitionOptions.crossFade();

        Glide
                .with(context)
                .load(url)
                .apply(options)
                .transition(transitionOptions)
                .into(ivPhoto);

    }

    public void loadVideo(Context context, String url){
        Uri vidUri = Uri.parse(url);
        videoView.setVideoURI(vidUri);
        videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                final Handler handler = new Handler();
                handler.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        if(t != null){
                            t.cancel();
                        }
                        getVideoView().setVisibility(View.GONE);
                        getIvPhoto().setVisibility(View.VISIBLE);
                        countDown = 0;
                        getProgressBar().setProgress(100);
                    }
                }, 1000);

            }
        });
    }

    public void initialCount(final Context context){
        getCountDownTimer().setVisibility(View.VISIBLE);
        getProgressBar().setVisibility(View.VISIBLE);

        t = new Timer();
        t.schedule(timerTask = new TimerTask() {
            @Override
            public void run() {

                if(!videoView.isPlaying()){
                    isPaused = true;
                }else{
                    isPaused = false;
                }

                if(!isPaused){

                    if(getVideoView().getDuration() > 0){

                        if (countDown == 0) {

                            countDown = getVideoView().getDuration();

                        } else {
                            countDown = countDown - 1000;
                        }
                    }else{

                        if (countDown == 0) {

                            countDown = getVideoView().getDuration() - 1000;

                        } else {
                            countDown = countDown - 1000;
                        }
                    }

                    final long minutes = ((countDown / 1000) % 3600) / 60;
                    final long seconds = (countDown / 1000) % 60;

                    ((Activity) context).runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            getCountDownTimer().setText("" + String.format("%02d:%02d", minutes, seconds));
                        }
                    });
                }

                try{
                    long progress = (100 * getVideoView().getCurrentPosition()) / getVideoView().getDuration();
                    getProgressBar().setProgress((int) progress);
                }catch (ArithmeticException e){

                }

            }
        }, 0, 1000);
    }

    public void removeCounters(){
        if (t != null){
            t.cancel();
            t.purge();
            setCounterTimer(0);
        }
        if (timerTask != null){
            timerTask.cancel();
        }
    }

    public void resetVideoViews() {
        removeCounters();
        videoView.pause();
        ivSound.setImageResource(R.drawable.ic_sound);
        ivPause.setImageResource(R.drawable.ic_pause);
        videoView.setVisibility(View.GONE);
        ivPhoto.setVisibility(View.VISIBLE);
        llControlPanel.setVisibility(View.GONE);
        llPlayButton.setVisibility(View.VISIBLE);
        tvCountDownTimer.setVisibility(View.GONE);
        videoProgressBar.setVisibility(View.GONE);
    }

    public ImageView getIvFullScreen(){
        return ivFullScreen;
    }

    public ImageView getIvSound(){
        return ivSound;
    }

    public ImageView getIvPause(){
        return ivPause;
    }

    public FrameLayout getVideoFrame(){
        return videoFrame;
    }

    public void isCountDownPaused(boolean isPaused){
        this.isPaused = isPaused;
    }

    public int getCounterTimer(){
        return countDown;
    }

    public void setCounterTimer(int count){
        this.countDown = count;
    }

    public ImageView getIvPhoto() {
        return ivPhoto;
    }

    public void hidePhoto() {
        ivPhoto.setVisibility(View.GONE);
    }

    public LinearLayout getLayPlayButton(){
        return llPlayButton;
    }

    public void playVideo(){
        videoView.start();
    }

    public LinearLayout getControlPanel(){
        return llControlPanel;
    }

    public void hideVideo() {
        videoView.setVisibility(View.GONE);
        videoProgressBar.setVisibility(View.GONE);
        playButton.setVisibility(View.GONE);
        tvCountDownTimer.setVisibility(View.GONE);
    }

    public ImageView getPlayButton(){
        return playButton;
    }

    public VideoView getVideoView(){
        return videoView;
    }

    public ProgressBar getProgressBar(){
        return videoProgressBar;
    }

    public TextView getCountDownTimer(){
        return tvCountDownTimer;
    }

    public void setTitle(String title) {
        tvTitle.setText(title);
    }

}
