package br.com.lab360.oneinternacional.logic.presenter.timeline;

import android.text.TextUtils;
import android.util.Log;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.LayoutInteractor;
import br.com.lab360.oneinternacional.logic.interactor.TimelineInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnDataSummaryListener;
import br.com.lab360.oneinternacional.logic.listeners.OnLayoutLoadedListener;
import br.com.lab360.oneinternacional.logic.listeners.Timeline.OnPostLikedListener;
import br.com.lab360.oneinternacional.logic.listeners.Timeline.OnPostRemovedListener;
import br.com.lab360.oneinternacional.logic.listeners.Timeline.OnPostUnlikedListener;
import br.com.lab360.oneinternacional.logic.listeners.Timeline.OnPostsLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;
import br.com.lab360.oneinternacional.logic.model.pojo.user.LayoutParam;
import br.com.lab360.oneinternacional.logic.model.pojo.datasummary.DataSummary;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.MessageResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.Post;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.LikeObject;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.BadgeMessageUpdateEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.LikeRequestFinishedEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.TimelineActionEvent;
import br.com.lab360.oneinternacional.ui.view.IBaseView;
import br.com.lab360.oneinternacional.utils.UserUtils;
import rx.Observer;
import rx.Subscription;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 *
 * Refactored by Paulo Age
 */
public class TimelinePresenter implements
        OnPostRemovedListener,
        OnPostLikedListener,
        OnPostUnlikedListener,
        OnPostsLoadedListener, OnLayoutLoadedListener,
        OnDataSummaryListener {

    private final TimelineInteractor mTimelineInteractor;
    private final LayoutInteractor mLayoutInteractor;
    private int mUserId;
    private ITimelineView mView;
    private Subscription actionSubscription;
    private Subscription chatBadgeSubscription;

    private int auxRemovePostPosition = -1;

    private ArrayList<Post> mPosts;
    private String mBannerLinkUrl;
    private int masterEventId;
    private Post lastPost;
    private Post firstPost;


    private Subscription cartItensSubscription;

    public TimelinePresenter(ITimelineView view) {
        this.mView = view;
        this.masterEventId = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();
        this.mTimelineInteractor = new TimelineInteractor(view.getContext());
        this.mLayoutInteractor = new LayoutInteractor(view.getContext());
        this.mView.setPresenter(this);
    }

    public void setLastPost(Post lastPost) {
        this.lastPost = lastPost;
    }

    public void setFirstPost(Post firstPost) {
        this.firstPost = firstPost;
    }

    public void start() {
        if (AdaliveApplication.getInstance().getUser() == null) {
            mView.navigateToLoginActivity();
            return;
        }
        mUserId = AdaliveApplication.getInstance().getUser().getId();
        mView.initToolbar();
        mView.setupSwipeRefresh();
        mView.setupTimelineRecyclerView();
        mView.loadUserProfileImage();

        ///Load posts with limit
        mTimelineInteractor.loadFirstPosts(masterEventId, AdaliveConstants.FIRST_REGISTERS, this);
        createPostActionSubscriptions();
        createBadgeSubscriptions();

        loadBanner();

        mView.verifyNotificationMessageExtra();
    }

    private  void loadBanner() {
        if(UserUtils.getSliderBanner(mView.getContext()) != null && UserUtils.getSliderBanner(mView.getContext()).getBanners().size() != 0){
            mView.loadSliderBanner(UserUtils.getSliderBanner(mView.getContext()));
        }else {
            AdaliveApplication application = AdaliveApplication.getInstance();
            if (UserUtils.getLayoutParam(mView.getContext()) == null) {
                mView.loadCachedBanner();
            } else {
                mBannerLinkUrl = UserUtils.getLayoutParam(mView.getContext()).getHomepageUrl();
                mView.loadApplicationBanner();
            }
        }
    }
    public void onResume() {
        loadLayout();

        mTimelineInteractor.loadFirstPosts(masterEventId, AdaliveConstants.FIRST_REGISTERS, this);
        mTimelineInteractor.getSummaryData(AdaliveApplication.getInstance().getUser().getId(), this);
    }

    public void onDestroy() {
        if (actionSubscription != null && !actionSubscription.isUnsubscribed())
            actionSubscription.unsubscribe();

        if (chatBadgeSubscription != null && !chatBadgeSubscription.isUnsubscribed())
            chatBadgeSubscription.unsubscribe();
    }

    public void attemptToLoadPosts() {

        //Aqui le somente os novos
//        mTimelineInteractor.loadFirstPosts(masterEventId, AdaliveConstants.FIRST_REGISTERS, this);

        if (lastPost == null) {
            mTimelineInteractor.loadFirstPosts(masterEventId, AdaliveConstants.FIRST_REGISTERS, this);
        } else {
            mTimelineInteractor.loadPosts(masterEventId, lastPost.getId(), "up", this);

        }
    }

    public void loadOldPosts(Post post) {
        mTimelineInteractor.loadPosts(masterEventId, post.getId(), "down", this);
    }


    private void onBtnRemovePostTouched(int position) {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
        auxRemovePostPosition = position;
        mView.showProgress();
        int masterEventID = AdaliveApplication.getInstance().getCodeParams().getMasterEventId();

        mTimelineInteractor.removePost(masterEventID, mUserId, mPosts.get(position).getId(), this);
    }

    private void onBtnLikePostTouched(int position) {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
        Post post = mPosts.get(position);
        for (LikeObject like : (ArrayList<LikeObject>) post.getLike().clone()) {
            if (like.getAppUser().getId() == mUserId) {
                post.getLike().remove(like);
                updatePostView(post);
                mTimelineInteractor.unlikePost(mPosts.get(position).getId(), mUserId, this);
                return;
            }
        }
        post.getLike().add(new LikeObject(new BaseObject(mUserId, "", "")));
        updatePostView(post);
        mTimelineInteractor.likePost(mPosts.get(position).getId(), mUserId, this);
    }

    private void createPostActionSubscriptions() {
        actionSubscription = AdaliveApplication.getBus().subscribe(RxQueues.TIMELINE_ACTION, new Observer<TimelineActionEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(TimelineActionEvent event) {
                switch (event.getAction()) {
                    case TimelineActionEvent.TimelineAction.LIKE:
                        onBtnLikePostTouched(event.getPosition());
                        break;
                  /*  case REPORT:
                        onBtnReportTouched(event.getPosition());
                        break;*/
                    case TimelineActionEvent.TimelineAction.REMOVE:
                        onBtnRemovePostTouched(event.getPosition());
                        break;
                    case TimelineActionEvent.TimelineAction.SHARE:
                        onBtnSharePostTouched(event.getPosition());
                        break;
                }
            }
        });
    }

    private void updatePostView(Post post) {
        for (int i = 0; i < mPosts.size(); i++) {
            if (mPosts.get(i).getId() == post.getId()) {
                mPosts.set(i, post);
                mView.notifyPostChanged(i, post);
            }
        }
    }

    private void onBtnReportTouched(int position) {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
    }

    private void onBtnSharePostTouched(int position) {
        //TODO
        Post post = mPosts.get(position);
        String pictureUrl = post.getPictureUrl();
        if (pictureUrl != null && !TextUtils.isEmpty(pictureUrl)) {
            mView.sharePost(pictureUrl);
        }
    }

    public void onPostContainerTouched() {
        mView.navigateToCreatePostActivity();
    }

    public void onBannerTouched() {
        if (Strings.isNullOrEmpty(mBannerLinkUrl)) {
            return;
        }
        mView.openUrl(mBannerLinkUrl);
    }

    public void setBannerLinkUrl(String cachedBannerLinkUrl) {
        this.mBannerLinkUrl = cachedBannerLinkUrl;
    }

    private void loadLayout() {
        AdaliveApplication application = AdaliveApplication.getInstance();
        if (UserUtils.getLayoutParam(mView.getContext()) == null) {
            int masterEventId = application.getCodeParams().getMasterEventId();
            mLayoutInteractor.getLayoutParams(AdaliveConstants.APP_ID, this);
        }
    }

    //region OnPostsLoadedListener
    @Override
    public void onLoadPostError(String message) {
        mView.hideRefreshLayout();
        //mView.showToastMessage(message);
    }

    @Override
    public void onLoadPostsSuccess(ArrayList<Post> posts) {
        this.mPosts = posts;
        mView.populateTimelineRecyclerView(mPosts);
        mView.hideRefreshLayout();
    }
    //endregion


    //region OnPostRemovedListener
    @Override
    public void onRemovePostError(String message) {
        mView.showToastMessage(message);
    }

    @Override
    public void onPostRemoveSuccess(MessageResponse response) {
        mView.hideProgress();
        mView.notifyPostRemoved(auxRemovePostPosition);
        auxRemovePostPosition = -1;

    }
    //endregion

    //region OnPostLikedListener
    @Override
    public void onLikePostError(int postId, String message) {
        AdaliveApplication.getBus().publish(RxQueues.LIKE_REQUEST_FINISHED_EVENT, new LikeRequestFinishedEvent(postId));
        mView.showToastMessage(message);
    }

    @Override
    public void onLikePostSuccess(Post post) {
        AdaliveApplication.getBus().publish(RxQueues.LIKE_REQUEST_FINISHED_EVENT, new LikeRequestFinishedEvent(post.getId()));
        updatePostView(post);
    }
    //endregion

    //region OnPostUnlikedListener
    @Override
    public void onUnlikePostError(int postId, String message) {
        AdaliveApplication.getBus().publish(RxQueues.LIKE_REQUEST_FINISHED_EVENT, new LikeRequestFinishedEvent(postId));
        mView.showToastMessage(message);
    }

    @Override
    public void onUnlikePostSuccess(Post post) {
        AdaliveApplication.getBus().publish(RxQueues.LIKE_REQUEST_FINISHED_EVENT, new LikeRequestFinishedEvent(post.getId()));
        updatePostView(post);
    }

    @Override
    public void onLayoutLoadError() {
        Log.d(getClass().getCanonicalName(), "TIMEOUT ERROR HERE! 12345");
    }

    @Override
    public void onLayoutLoadSuccess(LayoutParam params) {
        UserUtils.setLayoutParam(params, mView.getContext());
        mView.loadApplicationBackground();
    }
    //endregion


    //region Private Methods
    private void createBadgeSubscriptions() {
        chatBadgeSubscription = AdaliveApplication.getBus().subscribe(RxQueues.BADGE_UPDATE_EVENT, new Observer<BadgeMessageUpdateEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(BadgeMessageUpdateEvent sponsorTitleEvent) {

                mView.receiveMessage(sponsorTitleEvent.getTotalMessage());
            }
        });
    }



    @Override
    public void onDataSummaryLoadSuccess(DataSummary dataSummary) {

        Log.v(AdaliveConstants.ERROR, dataSummary.toString());

        mView.updateNotificationsBadges(dataSummary.getNotificationUnread(), dataSummary.getChatUnread());
    }

    @Override
    public void onDataSummaryLoadError(String message) {

    }
    //endregion

    public interface ITimelineView extends IBaseView {
        void initToolbar();

        void setPresenter(TimelinePresenter presenter);

        void setupTimelineRecyclerView();

        void populateTimelineRecyclerView(ArrayList<Post> mPosts);

        void notifyPostChanged(int index, Post updatedPost);

        void notifyPostRemoved(int index);

        void loadUserProfileImage();

        void navigateToLoginActivity();

        void setupSwipeRefresh();

        void hideRefreshLayout();

        void navigateToCreatePostActivity();

        void loadApplicationBanner();

        void loadCachedBanner();

        void loadBanner(final String bannerUrl);

        void loadSliderBanner(BannerResponse response);

        void openUrl(String bannerLinkUrl);

        void verifyNotificationMessageExtra();

        //void showProgressBar();

        void sharePost(String url);

        void receiveMessage(int messsages);

        void updateNotificationsBadges(int notificationsTotal, int chatTotal);

    }
}