package br.com.lab360.oneinternacional.ui.adapters.timeline;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.appcompat.widget.PopupMenu;
import androidx.recyclerview.widget.RecyclerView;

import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.google.common.base.Strings;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.roles.RoleProfileObject;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.Post;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.LikeObject;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.LikeRequestFinishedEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.TimelineActionEvent;
import br.com.lab360.oneinternacional.ui.activity.mediaplayer.MediaPlayerActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.CommentActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.TimelineActivity;
import br.com.lab360.oneinternacional.ui.activity.webview.WebviewActivity;
import br.com.lab360.oneinternacional.ui.viewholder.timeline.TimelineViewHolder;
import br.com.lab360.oneinternacional.utils.UserUtils;
import rx.Observer;
import rx.Subscription;

import static br.com.lab360.oneinternacional.logic.rxbus.events.TimelineActionEvent.TimelineAction.LIKE;
import static br.com.lab360.oneinternacional.logic.rxbus.events.TimelineActionEvent.TimelineAction.REMOVE;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */
public class TimelineRecyclerAdapter extends RecyclerView.Adapter<TimelineViewHolder> implements PopupMenu.OnMenuItemClickListener {
    private static final int TYPE_SPONSOR = 0;
    private static final int TYPE_POST = 1;
    private final Context context;
    private List<Post> items;
    private Activity act;
    MediaPlayer mPlayer;
    private int btnMoreSelectedPosition = -1;
    private int appUserId;
    private RoleProfileObject roleProfileObject;

    public long i = 0;
    float volumeContol = 0.0f;
    public boolean first = true;

    public TimelineRecyclerAdapter(Context context, Activity act) {
        this.items = new ArrayList<>();
        this.context = context;
        this.act = act;

        appUserId = AdaliveApplication.getInstance().getUser().getId();
        roleProfileObject =  UserUtils.getCurrentUserRole(context);
    }


    @Override
    public TimelineViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_timeline_item, parent, false);
        return new TimelineViewHolder(v);
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }

    @Override
    public void onBindViewHolder(final TimelineViewHolder holder, final int position) {
        final Post item = items.get(position);

        if (Strings.isNullOrEmpty(item.getMessage())) {
            holder.hideMessage();
        } else {
            holder.setMessage(item.getMessage());
        }


        if (!Strings.isNullOrEmpty(item.getPictureUrl()) && !Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.getPlayButton().setVisibility(View.GONE);
            holder.loadVideo(context, item.getHrefVideo());
            holder.loadImage(context, item.getPictureUrl());
        }

        if (Strings.isNullOrEmpty(item.getPictureUrl()) && !Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.hidePhoto();
            holder.getPlayButton().setVisibility(View.VISIBLE);
            holder.loadVideo(context, item.getHrefVideo());
        }

        if(!Strings.isNullOrEmpty(item.getPictureUrl()) && Strings.isNullOrEmpty(item.getHrefVideo())){
            holder.hideVideo();
            holder.getIvPhoto().setImageResource(R.drawable.ic_picture_placeholder);
            holder.loadImage(context, item.getPictureUrl());
        }
        if (Strings.isNullOrEmpty(item.getPictureUrl()) && Strings.isNullOrEmpty(item.getHrefVideo())) {
            holder.getVideoFrame().setVisibility(View.GONE);
        }

        holder.getIvPostProfilePhoto().setColorFilter(Color.parseColor(UserUtils.getBackgroundColor(context)), android.graphics.PorterDuff.Mode.MULTIPLY);
        if (!Strings.isNullOrEmpty(item.getAppUser().getImageUrl())) {

            RequestOptions options = new RequestOptions();
            options.placeholder(R.drawable.ic_user_timeline_default);
            options.diskCacheStrategy(DiskCacheStrategy.ALL);

            Glide.with(context)
                    .load(item.getAppUser().getImageUrl())
                    .apply(options)
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            holder.getIvPostProfilePhoto().setColorFilter(null);
                            return false;
                        }
                    })
                    .into(holder.getIvPostProfilePhoto());
        } else {
            holder.getIvPostProfilePhoto().setImageDrawable(ContextCompat.getDrawable(context, R.drawable.ic_user_timeline_default));
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
                holder.isCountDownPaused(true);

                holder.getControlPanel().setVisibility(View.GONE);
                Intent i = new Intent(context, MediaPlayerActivity.class);
                i.putExtra("currentPos", holder.getVideoView().getCurrentPosition());
                i.putExtra("videoUrl", item.getHrefVideo());
                act.startActivity(i);
                holder.getVideoView().stopPlayback();
            }
        });

        int commentSize = item.getComment().size();
        if (commentSize == 1) {
            holder.setCommentCount(context.getString(R.string.LABEL_SIGLE_COMMENT));
        } else if (commentSize > 1) {
            holder.setCommentCount(commentSize + " " + context.getString(R.string.LABEL_COMMENTS));
        } else {
            holder.setCommentCount(context.getString(R.string.LABEL_EMPTY_COMMENTS));
        }


        holder.setPostOwnerName(item.getAppUser().getName());
        holder.setLikeCount(item.getLike().size());

        holder.getHeartIcon().setImageDrawable(ContextCompat.getDrawable(context, R.drawable.ic_heart_outline));
        for (LikeObject like : item.getLike()) {
            if (like.getAppUser().getId() == appUserId) {
                holder.getHeartIcon().setImageDrawable(ContextCompat.getDrawable(context, R.drawable.ic_heart_fill));
            }
        }

        holder.getBtnComment().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                eventActionComment(item);
            }
        });

        holder.getBtnLike().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                holder.getBtnLike().setEnabled(false);
                eventActionLike(position);
            }
        });

        holder.setPostDate(item.getCreatedAt());

        if (item.isSponsor()) {
            if (TextUtils.isEmpty(item.getSponsorUrl())) {
                holder.hideOpenUrlContainer();
            } else {

                String topColor = UserUtils.getBackgroundColor(context);

                /* Update the background color */
                if (!Strings.isNullOrEmpty(topColor)) {
                    try {
                        ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                        holder.getBtnOpenAd().setBackground(cd);
                    } catch (Exception e) {
                        Log.d(getClass().getCanonicalName(), "Color exception");
                    }
                }


                holder.showOpenUrlContainer();
                holder.getBtnOpenAd().setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        StringBuilder url = new StringBuilder(item.getSponsorUrl());
                        if(!url.toString().contains("http"))
                            url.insert(0,"http://");

                        Intent it = new Intent(context, WebviewActivity.class);
                        it.putExtra(AdaliveConstants.TAG_ACTION_URL, url.toString());
                        context.startActivity(it);


                    }
                });
            }
        } else {
            holder.hideOpenUrlContainer();
        }

        holder.getIvMore().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                btnMoreSelectedPosition = position;
                actionClickMore(view);
            }
        });

        /*holder.getBtnReport().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                eventActionReport(position);
            }
        });*/

        holder.getBtnCommentCount().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                eventActionComment(item);
            }
        });

        Subscription subscription = AdaliveApplication.getBus().subscribe(RxQueues.LIKE_REQUEST_FINISHED_EVENT, new Observer<LikeRequestFinishedEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(LikeRequestFinishedEvent event) {
                if (item.getId() == event.getPostId()) {
                    holder.getBtnLike().setEnabled(true);
                }
            }
        });
        holder.setSubscription(subscription);


        /* Privileges here */
        if (!roleProfileObject.getCanCreatePost()){
            holder.getBtnComment().setVisibility(View.INVISIBLE);
            holder.getBtnCommentCount().setEnabled(false);
            holder.getBtnCommentCount().setOnClickListener(null);
        }

        if (!roleProfileObject.getCanLike()){
            holder.getBtnLike().setVisibility(View.INVISIBLE);
            holder.getHeartIcon().setVisibility(View.INVISIBLE);
        }
    }

    private void eventActionComment(Post item) {
        Intent intent = new Intent(context, CommentActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_TIMELINE_POST, item);
        context.startActivity(intent);
    }

    private void eventActionShare(Post item) {
        if(item.getHrefVideo() != null && !item.getHrefVideo().equals("")){
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_TEXT,item.getHrefVideo());
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, "");
            context.startActivity(Intent.createChooser(shareIntent, "Compartilhar"));

        }else if (item.getHrefVideo() == null || item.getHrefVideo().equals("") && item.getPictureUrl() != null || !item.getPictureUrl().contains("")){


            Glide.with(context)
                    .asBitmap()
                    .load(item.getPictureUrl()).addListener(new RequestListener<Bitmap>() {
                @Override
                public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                    return false;
                }

                @Override
                public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                    String path = MediaStore.Images.Media.insertImage(context.getContentResolver(), resource, "", null);
                    Uri uri = Uri.parse(path);
                    Intent i = new Intent(Intent.ACTION_SEND);
                    i.setType("image/*");
                    i.putExtra(Intent.EXTRA_STREAM, uri);
                    context.startActivity(Intent.createChooser(i, context.getString(R.string.com_facebook_share_button_text)));
                    return false;
                }
            }).preload();


        }else{
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType("text/plain");
            shareIntent.putExtra(Intent.EXTRA_TEXT,item.getMessage());
            shareIntent.putExtra(Intent.EXTRA_SUBJECT, "");
            context.startActivity(Intent.createChooser(shareIntent, context.getString(R.string.com_facebook_share_button_text)));
        }

    }

   /* private void eventActionReport(int position) {
        AdaliveApplication.getBus().publish(RxQueues.TIMELINE_ACTION, new TimelineActionEvent(REPORT, position));
    }*/

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private void actionClickMore(View view) {

        PopupMenu popupMenu = new PopupMenu(view.getContext(), view);
        ((TimelineActivity) context).getMenuInflater().inflate(R.menu.menu_timeline_more, popupMenu.getMenu());
        configMenu(popupMenu);
        popupMenu.show();

        //The following is only needed if you want to force a horizontal offset like margin_right to the PopupMenu
        try {
            Field fMenuHelper = PopupMenu.class.getDeclaredField("mPopup");
            fMenuHelper.setAccessible(true);
            Object oMenuHelper = fMenuHelper.get(popupMenu);

            Class[] argTypes = new Class[]{int.class};

            Field fListPopup = oMenuHelper.getClass().getDeclaredField("mPopup");
            fListPopup.setAccessible(true);
            Object oListPopup = fListPopup.get(oMenuHelper);
            Class clListPopup = oListPopup.getClass();

            int iWidth = (int) clListPopup.getDeclaredMethod("getWidth").invoke(oListPopup);

            clListPopup.getDeclaredMethod("setHorizontalOffset", argTypes).invoke(oListPopup, -iWidth);

            clListPopup.getDeclaredMethod("show").invoke(oListPopup);

        } catch (NoSuchFieldException | NoSuchMethodException | InvocationTargetException | IllegalAccessException nsfe) {
            nsfe.printStackTrace();
        }

        popupMenu.setOnMenuItemClickListener(this);

    }

    private void configMenu(PopupMenu popupMenu) {
        Menu menu = popupMenu.getMenu();
        Post gsemdPost = items.get(btnMoreSelectedPosition);

        boolean isAppUserLikedPost = false;
        for (LikeObject like : gsemdPost.getLike()) {
            if (like.getAppUser().getId() == appUserId) {
                isAppUserLikedPost = true;
                break;
            }
        }

        menu.findItem(R.id.action_like).setVisible(!isAppUserLikedPost);
        menu.findItem(R.id.action_unlike).setVisible(isAppUserLikedPost);

        boolean isAppUserPost = appUserId == gsemdPost.getAppUser().getId();
        menu.findItem(R.id.action_delete_post).setVisible(isAppUserPost);
//        menu.findItem(R.id.action_report_post).setVisible(!isAppUserPost);


        //Configure menu itens permissions
        if (!roleProfileObject.getCanComment()){
            menu.findItem(R.id.action_comment).setVisible(false);
        }

        if (!roleProfileObject.getCanLike()){
            menu.findItem(R.id.action_like).setVisible(false);
        }

        if (!roleProfileObject.getCanShare()){
            menu.findItem(R.id.action_share).setVisible(false);
        }


    }

    @Override
    public void onViewRecycled(TimelineViewHolder holder) {
        holder.resetVideoViews();
        //holder.resetImageViews();
        holder.resetButtons();
        holder.unsubscribeAll();
        super.onViewRecycled(holder);
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(Post object) {
        if (object == null)
            object = new Post();

        items.add(object);
        int pos = items.indexOf(object);
        notifyItemInserted(pos);
    }

    public void remove(int pos) {
        if (pos > items.size() - 1)
            return;

        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void remove(Post object) {
        if (object == null)
            return;

        int pos = items.indexOf(object);
        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void replaceAll(ArrayList<Post> posts) {

        ArrayList<Post> listResult = new ArrayList<Post>();

        listResult.addAll(posts);

        for (Post item: this.items) {

            if (!checkPostExist(posts, item)){
                listResult.add(item);
            }
        }

        this.items.clear();
        this.items.addAll(listResult);

        Collections.sort(this.items, new IDComparator());

        notifyDataSetChanged();
    }

    public void updatePost(int index, Post updatedPost) {
        this.items.set(index, updatedPost);
        notifyItemChanged(index);
    }

    public void removePost(int index) {

        if (index != -1 && index < this.items.size()) {
            this.items.remove(index);
            notifyItemRemoved(index);
            notifyItemRangeChanged(index, getItemCount());
        }

    }

    /**
     * This method will be invoked when a menu item is clicked if the item
     * itself did not already handle the event.
     *
     * @param item the menu item that was clicked
     * @return {@code true} if the event was handled, {@code false}
     * otherwise
     */
    @Override
    public boolean onMenuItemClick(MenuItem item) {
        Post gsemdPost = items.get(btnMoreSelectedPosition);
        switch (item.getItemId()) {

            case R.id.action_unlike:
            case R.id.action_like:
                eventActionLike(btnMoreSelectedPosition);
                break;
            case R.id.action_comment:
                eventActionComment(gsemdPost);
                break;
            case R.id.action_share:
                //AdaliveApplication.getBus().publish(RxQueues.TIMELINE_ACTION, new TimelineActionEvent(SHARE, btnMoreSelectedPosition));
                eventActionShare(gsemdPost);
                break;
            case R.id.action_delete_post:
                AdaliveApplication.getBus().publish(RxQueues.TIMELINE_ACTION, new TimelineActionEvent(REMOVE, btnMoreSelectedPosition));
                break;
/*            case R.id.action_report_post:
                eventActionReport(btnMoreSelectedPosition);
                break;*/

        }

        return false;
    }

    private void eventActionLike(int position) {
        AdaliveApplication.getBus().publish(RxQueues.TIMELINE_ACTION, new TimelineActionEvent(LIKE, position));
    }


    public class IDComparator implements Comparator<Post>
    {
        public int compare(Post left, Post right) {
//            return left.getId() - right.getId();

            return left.getId() > right.getId() ? -1 : 1;
        }
    }


    public boolean checkPostExist(ArrayList<Post> list, Post post){

        boolean contains = false;

        for (Post item : list) {

            if (item.getId() == post.getId()){
                contains = true;
                break;
            }
        }

        return  contains;
    }

}