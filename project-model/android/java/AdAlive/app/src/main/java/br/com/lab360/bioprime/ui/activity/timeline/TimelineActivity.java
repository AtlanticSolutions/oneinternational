package br.com.lab360.bioprime.ui.activity.timeline;

import android.Manifest;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;

import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.google.android.material.appbar.CollapsingToolbarLayout;

import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.google.common.base.Strings;

import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

import br.com.lab360.bioprime.BuildConfig;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.interactor.InteractiveNotificationInteractor;
import br.com.lab360.bioprime.logic.interactor.WarningActionsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnWarningActionsListener;
import br.com.lab360.bioprime.logic.model.pojo.roles.RoleProfileObject;
import br.com.lab360.bioprime.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;
import br.com.lab360.bioprime.logic.model.pojo.warningactions.WarningAction;
import br.com.lab360.bioprime.logic.model.pojo.warningactions.WarningActionsResponse;
import br.com.lab360.bioprime.logic.presenter.timeline.TimelinePresenter;
import br.com.lab360.bioprime.ui.activity.NavigationDrawerActivity;
import br.com.lab360.bioprime.ui.activity.login.LoginActivity;
import br.com.lab360.bioprime.ui.activity.webview.WebviewActivity;
import br.com.lab360.bioprime.ui.adapters.timeline.SliderBannerAdapter;
import br.com.lab360.bioprime.ui.adapters.timeline.TimelineRecyclerAdapter;
import br.com.lab360.bioprime.ui.decorator.SliderBannerLoader;
import br.com.lab360.bioprime.utils.ImageUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import br.com.lab360.bioprime.utils.customdialog.CustomDialogBuilder;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import ss.com.bannerslider.Slider;
import ss.com.bannerslider.event.OnSlideChangeListener;
import ss.com.bannerslider.event.OnSlideClickListener;

public class TimelineActivity extends NavigationDrawerActivity implements
        TimelinePresenter.ITimelineView, OnWarningActionsListener{
//region Binds
   @BindView(R.id.collapsing_toolbar)
   protected CollapsingToolbarLayout colapsingToolbar;

    @BindView(R.id.toolbarBottom)
    protected Toolbar mToolbar;

    @BindView(R.id.rvTimeline)
    protected RecyclerView rvTimeline;

    @BindView(R.id.tvChatNotifications)
    protected TextView tvChatNotifications;

    @BindView(R.id.tvGeneralNotifications)
    protected TextView tvGeneralNotifications;

    @BindView(R.id.rvRefresh)
    protected SwipeRefreshLayout rvRefresh;

    @BindView(R.id.ivBanner)
    protected ImageView ivBanner;

    @BindView(R.id.sliderBanner)
    protected Slider sliderBanner;

    @BindView(R.id.container_post)
    protected RelativeLayout containerPost;

    @BindView(R.id.progressBar)
    protected ProgressBar progressBar;

    @BindView(R.id.btnCamera)
    protected ImageView btnCamera;

    int timerSliderBanner;
    int countSliderBanner = 0;
//endregion

    private WarningAction warningAction;

    /* Consts */
    private static final int CREAT_POST_RESULT = 0x556;

    private Post lastPost;
    private Post firstPost;

    /* Presenter */
    private TimelinePresenter mPresenter;
    private boolean isFirstTimeLoad, loadPosts = true;
    private boolean isUpdating = false;

    private static final int AUDIO_PERMITION_REQUEST = 10;
    private static final String[] AUDIO_PERMITION = {Manifest.permission.MODIFY_AUDIO_SETTINGS};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_timeline);
        ButterKnife.bind(this);

        configureUI();
        initToolbar();
        initMainFunctions();
        initPresenter();

        progressBar.getIndeterminateDrawable().setColorFilter(Color.parseColor(UserUtils.getBackgroundColor(this)), android.graphics.PorterDuff.Mode.MULTIPLY);

    }

    @Override
    protected void onDestroy() {
        mPresenter.onDestroy();
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();

        checkWarningActions();

        if (loadPosts) {
            mPresenter.onResume();
        }
    }

    private void configureUI() {
        CollapsingToolbarLayout.LayoutParams lp = new CollapsingToolbarLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMargins(0, 0, 0, 0);
        ivBanner.setLayoutParams(lp);

        mToolbar.setVisibility(View.GONE);
        containerPost.setOnClickListener(null);
        containerPost.setVisibility(View.GONE);

        colapsingToolbar.setBackgroundColor(Color.parseColor(UserUtils.getBackgroundColor(this)));
    }

    public void checkWarningActions(){
        new WarningActionsInteractor(this).retrieveAllWarningApp(BuildConfig.VERSION_NAME.split("-")[0],BuildConfig.APP_ID, this );
    }
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (requestCode) {
            case CREAT_POST_RESULT:
                if (resultCode == RESULT_OK) {
                    loadPosts = data.getExtras().getBoolean(AdaliveConstants.LOAD_POSTS);
                }
                break;
        }
    }

    //region ITimelineVie
    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        setToolbarTitle(UserUtils.getLayoutParam(this).getName());
        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                Window window = getWindow();
                window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                window.setStatusBarColor(Color.parseColor(topColor));
            }

            RoleProfileObject roleProfileObject = UserUtils.getCurrentUserRole(this);

            if (roleProfileObject.getCanCreatePost()) {
                btnCamera.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
            } else {
                btnCamera.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void setPresenter(TimelinePresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void setupTimelineRecyclerView() {
        final LinearLayoutManager llm = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        rvTimeline.setLayoutManager(llm);
        rvTimeline.setHasFixedSize(false);

        TimelineRecyclerAdapter adapter = new TimelineRecyclerAdapter(this, TimelineActivity.this);
        rvTimeline.setAdapter(adapter);
        rvTimeline.setNestedScrollingEnabled(false);
        if (!isFirstTimeLoad) {
            progressBar.setVisibility(View.VISIBLE);
            rvTimeline.setVisibility(View.INVISIBLE);
        }
    }

/* @Override
public void showProgressBar() {
Transition scale = new Scale(0.2f);
scale.setDuration(600);
scale.setStartDelay(100);
scale.addTarget(progressBar);

TransitionSet set = new TransitionSet()
    .addTransition(scale)
    .addTransition(new ChangeBounds());

TransitionManager.beginDelayedTransition((LinearLayout) findViewById(R.id.content_timeline), set);
progressBar.setVisibility(View.VISIBLE);
}*/

    @Override
    public void populateTimelineRecyclerView(ArrayList<Post> posts) {

        progressBar.setVisibility(View.GONE);
        rvTimeline.setVisibility(View.VISIBLE);
        isFirstTimeLoad = true;


        if (posts.size() > 0) {
            firstPost = posts.get(0);
            lastPost = posts.get(posts.size() - 1);
            mPresenter.setLastPost(firstPost);
        } else {
            mPresenter.setLastPost(null);
        }

        ((TimelineRecyclerAdapter) rvTimeline.getAdapter()).replaceAll(posts);

        isUpdating = false;
    }

    @Override
    public void notifyPostChanged(int index, Post updatedPost) {
        ((TimelineRecyclerAdapter) rvTimeline.getAdapter()).updatePost(index, updatedPost);
    }

    @Override
    public void notifyPostRemoved(int index) {
        ((TimelineRecyclerAdapter) rvTimeline.getAdapter()).removePost(index);
    }

    @Override
    public void loadUserProfileImage() {
        RequestOptions options = new RequestOptions();
        options.placeholder(R.drawable.ic_user_timeline_default);
        options.override(120,120);

        Glide.with(this)
                .load(AdaliveApplication.getInstance().getUser().getProfileImageURL())
                .apply(options)
                .into(ivProfilePhoto);

        if ((AdaliveApplication.getInstance().getUser().getProfileImageURL() == null) ||
                (AdaliveApplication.getInstance().getUser().getProfileImageURL() == "")) {

            String topColor = UserUtils.getBackgroundColor(this);
            if (!Strings.isNullOrEmpty(topColor)) {
                ivProfilePhoto.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
            }
        }

    }

    @Override
    public void navigateToLoginActivity() {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
    }


    @Override
    public void setupSwipeRefresh() {

        rvTimeline.setOnTouchListener(new View.OnTouchListener() {

            float firstY = 0;


            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {

                switch (motionEvent.getAction()) {
                    case MotionEvent.ACTION_DOWN:

                        if (firstY > motionEvent.getY()) {
                            if (!isUpdating) {
                                mPresenter.loadOldPosts(lastPost);
//                                rvRefresh.setRefreshing(true);
                            }
                        }

                        firstY = motionEvent.getY();
                        break;

                    case MotionEvent.ACTION_UP:
                        Log.d("scroll", motionEvent.getY() - firstY + "");

                        break;

                    default:
                        break;
                }

                return false;
            }
        });


        rvRefresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                isUpdating = true;
                mPresenter.attemptToLoadPosts();
                checkWarningActions();
            }
        });
    }

    @Override
    public void hideRefreshLayout() {
        if (rvRefresh.isRefreshing()) {
            rvRefresh.setRefreshing(false);
        }
    }

    @Override
    public void navigateToCreatePostActivity() {
        Intent intent = new Intent(this, CreatePostActivity.class);
        startActivityForResult(intent, CREAT_POST_RESULT);
    }

    @Override
    public void loadApplicationBanner() {
        String bannerUrl = UserUtils.getLayoutParam(this).getHeadImage();
        loadBanner(bannerUrl);
    }

    @Override
    public void loadCachedBanner() {
        String bannerUrl = UserUtils.getCachedBannerUrl(this);
        loadBanner(bannerUrl);
        mPresenter.setBannerLinkUrl(UserUtils.getCachedBannerLinkUrl(this));
    }

    @Override
    public void loadBanner(final String bannerUrl) {
        if (Strings.isNullOrEmpty(bannerUrl)) {
            ivBanner.setVisibility(View.GONE);
            return;
        }

        Glide.with(this)
                .load(bannerUrl)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        if (ivBanner != null) {
                            ivBanner.setImageDrawable(resource);
                            ivBanner.requestLayout();
                        }
                        UserUtils.saveBannerUrl(TimelineActivity.this, bannerUrl);
                        return false;
                    }
                }).preload();
    }


    @Override
    public void loadSliderBanner(final BannerResponse bannerResponse){
        Slider.init(new SliderBannerLoader(this));
        sliderBanner.setAdapter(new SliderBannerAdapter(bannerResponse.getBanners()));
        sliderBanner.setLoopSlides(true);
        sliderBanner.setSelectedSlide(1);
        sliderBanner.setVisibility(View.VISIBLE);
        ivBanner.setVisibility(View.GONE);

        countSliderBanner = sliderBanner.selectedSlidePosition;
        sliderBanner.setSlideChangeListener(new OnSlideChangeListener() {
            @Override
            public void onSlideChange(int position) {
                countSliderBanner = position;
            }
        });

        sliderBanner.setOnSlideClickListener(new OnSlideClickListener() {
            @Override
            public void onSlideClick(int position) {
                if(!TextUtils.isEmpty(bannerResponse.getBanners().get(position).getHref())){
                    bannerResponse.getBanners().get(position).getHref();
                    Intent it = new Intent(TimelineActivity.this, WebviewActivity.class);
                    it.putExtra(AdaliveConstants.TAG_ACTION_URL, bannerResponse.getBanners().get(position).getHref());
                    startActivity(it);
                }
            }
        });

        if(bannerResponse.getTime() != 0){
            timerSliderBanner = bannerResponse.getTime();
        }else{
            timerSliderBanner = 6;
        }

        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        sliderBanner.setSelectedSlide(countSliderBanner);
                    }
                });

                if(countSliderBanner >= bannerResponse.getBanners().size()){
                    countSliderBanner = 1;
                }else {
                    countSliderBanner ++;
                }

            }
        },0,timerSliderBanner*1000);

        if(bannerResponse.getBanners().size() <= 1){
            sliderBanner.setLoopSlides(false);
            sliderBanner.hideIndicators();
        }
    }

    @Override
    public void openUrl(String bannerLinkUrl) {

        Uri uri = Uri.parse(bannerLinkUrl);
        CustomTabsIntent.Builder customTabsIntentBuilder = new CustomTabsIntent.Builder(null);
        CustomTabsIntent customTabsIntent = customTabsIntentBuilder.build();
        customTabsIntent.launchUrl(this, uri);

    }

    @Override
    public void verifyNotificationMessageExtra() {

        Intent intent = getIntent();
        final String stringExtra = intent.getStringExtra(AdaliveConstants.NOTIFICATION_MESSAGE);

        if (stringExtra != null) {

            showMessageDialog(TimelineActivity.this, stringExtra);

        } else {

            prepareNotificationByIntent();

        }

    }

    @Override
    public void sharePost(String url) {
        Glide.with(this)
                .load(url)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        Bitmap bitmap = ((BitmapDrawable)resource).getBitmap();
                        Intent i = new Intent(Intent.ACTION_SEND);
                        i.setType("image/*");
                        i.putExtra(Intent.EXTRA_STREAM, ImageUtils.getLocalBitmapUri(bitmap, TimelineActivity.this));
                        startActivity(Intent.createChooser(i, "Share Image"));
                        return false;
                    }
                }).preload();
    }

    @Override
    public void receiveMessage(int messsages) {

        AdaliveApplication.getInstance().setAddNotificationValue(1);

        if (AdaliveApplication.getInstance().getTotalNotifications() > 0) {
            tvChatNotifications.setText(String.valueOf(AdaliveApplication.getInstance().getTotalNotifications()));
            tvChatNotifications.setVisibility(View.VISIBLE);
        } else {
            tvChatNotifications.setVisibility(View.GONE);
        }
    }

    @Override
    public void updateNotificationsBadges(int notificationsTotal, int chatTotal) {

        if (chatTotal > 0) {
            tvChatNotifications.setVisibility(View.VISIBLE);
            tvChatNotifications.setText(String.valueOf(chatTotal));
        } else {
            tvChatNotifications.setVisibility(View.GONE);
        }

        if (notificationsTotal > 0) {
            tvGeneralNotifications.setVisibility(View.VISIBLE);
            tvGeneralNotifications.setText(String.valueOf(notificationsTotal));
        } else {
            tvGeneralNotifications.setVisibility(View.GONE);
        }

    }


    public static void showMessageDialog(Context context, String stringExtra) {

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setMessage(stringExtra).setPositiveButton(android.R.string.ok,
                new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        dialog.dismiss();
                    }
                });
        builder.create().show();

    }

    private void prepareNotificationByIntent() {

        Intent intent = getIntent();
        if (intent.getExtras() != null) {

            String type = (String) getIntent().getExtras().get("type");

            if (type != null && type.equals("INTERACTIVE")) {

                String notificationId = (String) getIntent().getExtras().get("notificationId");

                if (notificationId != null) {
                    InteractiveNotificationInteractor.postNotificationAction(this, notificationId);
                }

            }
        }
    }

    @OnClick({R.id.ivBanner, R.id.container_post})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.ivBanner:
                mPresenter.onBannerTouched();
                break;
            case R.id.container_post:
                mPresenter.onPostContainerTouched();
                break;
        }
    }
//endregion

    private void initPresenter() {
        new TimelinePresenter(this);
    }

    private void initMainFunctions() {
        this.initToolbar();
    }

    @Override
    public void onWarningActionsLoadSuccess(WarningActionsResponse warningActionsResponse) {
        for (WarningAction warningAction : warningActionsResponse.getConfigs()) {
            if (warningAction.isCmdLock() && warningAction.getPlataform().contains("A")) {
                onCmdLock(warningAction);
                return;
            } else {
                if (loadPosts) {
                    mPresenter.onResume();
                }

            }
        }

        for (WarningAction warningAction : warningActionsResponse.getConfigs()) {
            if (warningAction.isCmdPersistentWarning() && warningAction.getPlataform().contains("A")) {
                onCmdPersistent(warningAction);
            } else {
                if (loadPosts) {
                    mPresenter.onResume();
                }

            }
        }
    }

    @Override
    public void onWarningActionsLoadError(String message) {

    }

    private void onCmdPersistent(final WarningAction warningAction) {
        this.warningAction = warningAction;

        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ATENTION,
                getString(R.string.TITLE_MESSAGE_UPDATE),
                warningAction.getAppMessage(),
                0
        );

        customDialogButton(
                getString(R.string.BUTTON_UPDATE),
                R.color.white,
                R.drawable.background_button_yellow,
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CANCEL),
                R.color.white,
                R.drawable.gray_button_background,
                null
        );

        showCustomDialog();
    }

    private void onCmdLock(final WarningAction warningAction) {
        this.warningAction = warningAction;
        atentionDialog(getString(R.string.TITLE_MESSAGE_UPDATE), warningAction.getAppMessage(),onClickDialogButton(R.id.DIALOG_BUTTON_2));

    }

    private void dismissAndLoadPlayStore(String url) {
        if (!url.contains("http")) {
            url = "http://" + url;
        }

        try {
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        } catch (Exception ex) {
            //TODO
        }
    }

    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        dismissAndLoadPlayStore(warningAction.getExternalAddr());
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        dismissAndLoadPlayStore(warningAction.getExternalAddr());
                        break;
                }
            }
        };
    }
}
