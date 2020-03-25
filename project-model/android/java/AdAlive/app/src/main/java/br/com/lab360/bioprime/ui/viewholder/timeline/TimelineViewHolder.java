package br.com.lab360.bioprime.ui.viewholder.timeline;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.CountDownTimer;
import android.os.Handler;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.VideoView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions;
import com.bumptech.glide.request.RequestOptions;

import java.util.Timer;
import java.util.TimerTask;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;
import rx.Subscription;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class TimelineViewHolder extends RecyclerView.ViewHolder {

    protected CountDownTimer countDownTimer;

    @Nullable
    @BindView(R.id.tvPostDate)
    protected TextView tvPostDate;
    @Nullable
    @BindView(R.id.btnOpenAd)
    protected Button btnOpenAd;

    @Nullable
    @BindView(R.id.ivMore)
    protected ImageView ivMore;

    @BindView(R.id.tvMessage)
    protected TextView tvMessage;

    @BindView(R.id.tvPostOwnerName)
    protected TextView tvPostOwnerName;

    @BindView(R.id.btnCommentCount)
    protected Button btnCommentCount;

    @BindView(R.id.tvLikeCount)
    protected TextView tvLikeCount;

    @BindView(R.id.ivPhoto)
    protected ImageView ivPhoto;

    @BindView(R.id.ivPostProfilePhoto)
    protected CircleImageView ivPostProfilePhoto;

    @BindView(R.id.ivHeart)
    protected ImageView ivHeart;

    @BindView(R.id.btnLike)
    protected Button btnLike;

    @BindView(R.id.btnComment)
    protected Button btnComment;

    @Nullable
    @BindView(R.id.container_root)
    protected RelativeLayout containerRoot;

    @Nullable
    @BindView(R.id.container_open)
    protected RelativeLayout containerOpenUrl;

    @BindView(R.id.separator)
    protected ImageView separator;

    @BindView(R.id.videoView)
    protected VideoView videoView;

    @BindView(R.id.llPlayButton)
    protected LinearLayout llPlayButton;

    @BindView(R.id.playButton)
    protected ImageView playButton;

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

    @BindView(R.id.ivFullScreen)
    protected ImageView ivFullScreen;

    @BindView(R.id.ivPause)
    protected ImageView ivPause;

    private Subscription mSubscription;
    private boolean isPaused = false;
    int countDown = 0;
    private Timer t;
    private int videoDuration = 0;

    public TimelineViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
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
                .transition(transitionOptions)
                .apply(options)
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

    /*
    public void initialCount(){
        countDownTimer = new CountDownTimer(getVideoView().getDuration(), 1000){
            public void onTick(long millisUntilFinished) {
                long minutes = ((millisUntilFinished / 1000) % 3600) / 60;
                long seconds = (millisUntilFinished / 1000) % 60;
                getCountDownTimer().clearFocus();
                getCountDownTimer().setTextKeepState("" + String.format("%02d:%02d", minutes, seconds));

                getCountDownTimer().setText("" + String.format("%02d:%02d", minutes, seconds));
                getCountDownTimer().setVisibility(View.VISIBLE);

                long progress = (100 * getVideoView().getCurrentPosition()) / getVideoView().getDuration();
                getProgressBar().setProgress((int) progress);
            }

            public void onFinish() {
                getProgressBar().setProgress(100);
                //holder.getCountDownTimer().setText("done!");
            }
        };
        getProgressBar().setVisibility(View.VISIBLE);
    }
*/
    public int getCounterTimer(){
        return countDown;
    }


    public void setCounterTimer(int count){
        this.countDown = count;
    }


    public void initialCount(final Context context){
        getCountDownTimer().setVisibility(View.VISIBLE);
        getProgressBar().setVisibility(View.VISIBLE);

        t = new Timer();
        t.schedule(new TimerTask() {
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


    public void isCountDownPaused(boolean isPaused){
        this.isPaused = isPaused;
    }

    public void playVideo(){
        videoView.start();
    }

    public void setPostOwnerName(String name) {
        this.tvPostOwnerName.setText(name);
    }

    public void setPostDate(String dateString) {
        this.tvPostDate.setText(dateString.substring(0, dateString.lastIndexOf(":")));
    }

    public void setMessage(String message) {
        this.tvMessage.setText(message);
    }

    public void setCommentCount(String countStr) {
        btnCommentCount.setText(countStr);
    }

    public void setLikeCount(int count) {
        if (count == 0) {
            tvLikeCount.setText("");
            return;
        }
        tvLikeCount.setText(String.valueOf(count));
    }

    @Nullable
    public Button getBtnOpenAd() {
        return btnOpenAd;
    }

    public ImageView getIvPhoto() {
        return ivPhoto;
    }

    public CircleImageView getIvPostProfilePhoto() {
        return ivPostProfilePhoto;
    }

    public Button getBtnLike() {
        return btnLike;
    }

    public Button getBtnComment() {
        return btnComment;
    }

    public ImageView getHeartIcon() {
        return ivHeart;
    }

    public Button getBtnCommentCount() {
        return btnCommentCount;
    }

    public ImageView getIvMore() {
        return ivMore;
    }

    public void hideMessage() {
        tvMessage.setVisibility(View.GONE);
    }

    public void hidePhoto() {
        ivPhoto.setVisibility(View.GONE);
    }

    public void hideVideo() {
        llControlPanel.setVisibility(View.GONE);
        videoView.setVisibility(View.GONE);
        videoProgressBar.setVisibility(View.GONE);
        llPlayButton.setVisibility(View.GONE);
        tvCountDownTimer.setVisibility(View.GONE);
    }

    public LinearLayout getLayPlayButton(){
        return llPlayButton;
    }

    public ImageView getPlayButton(){
        return playButton;
    }

    public LinearLayout getControlPanel(){
        return llControlPanel;
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


    public void unsubscribeAll() {
        if (mSubscription != null && !mSubscription.isUnsubscribed())
            mSubscription.unsubscribe();
    }

    public void setSubscription(Subscription subscription) {
        this.mSubscription = subscription;
    }

    public void hideAll() {
        containerRoot.setVisibility(View.GONE);
    }

    public void hideOpenUrlContainer() {
        separator.setVisibility(View.VISIBLE);
        containerOpenUrl.setVisibility(View.GONE);
    }


    public void showOpenUrlContainer() {
        separator.setVisibility(View.GONE);
        containerOpenUrl.setVisibility(View.VISIBLE);

    }

    public void resetImageViews() {
        if (ivPhoto.getDrawable() instanceof BitmapDrawable) {
            Bitmap bitmap = ((BitmapDrawable) ivPhoto.getDrawable()).getBitmap();
            ivPhoto.setImageBitmap(null);
            bitmap.recycle();
        }
    }

    public void resetVideoViews() {
        if (t != null){
            t.cancel();
        }
        videoView.pause();
        ivSound.setImageResource(R.drawable.ic_sound);
        ivPause.setImageResource(R.drawable.ic_pause);
        videoView.setVisibility(View.GONE);
        ivPhoto.setVisibility(View.VISIBLE);
        llControlPanel.setVisibility(View.GONE);
        tvCountDownTimer.setVisibility(View.GONE);
        videoProgressBar.setVisibility(View.GONE);
    }

    public static int calculateInSampleSize(
            BitmapFactory.Options options, int reqWidth, int reqHeight) {

        final int height = options.outHeight;
        final int width = options.outWidth;
        int inSampleSize = 1;

        if (height > reqHeight || width > reqWidth) {

            final int heightRatio = Math.round((float) height / (float) reqHeight);
            final int widthRatio = Math.round((float) width / (float) reqWidth);

            inSampleSize = heightRatio < widthRatio ? heightRatio : widthRatio;
        }

        return inSampleSize;
    }

    public static Bitmap decodeSampledBitmapFromResource(Resources res, int resId,
                                                         int reqWidth, int reqHeight) {

        final BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeResource(res, resId, options);

        options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

        options.inJustDecodeBounds = false;
        return BitmapFactory.decodeResource(res, resId, options);
    }

    public void resetButtons() {
        btnLike.setEnabled(true);
    }
}