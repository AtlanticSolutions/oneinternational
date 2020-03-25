package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import java.util.ArrayList;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.listeners.OnBannerLoadedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentPostedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentRemovedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentUpdatedListener;
import br.com.lab360.bioprime.logic.listeners.OnDataSummaryListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostCreatedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostLikedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostRemovedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostUnlikedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnPostsLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.datasummary.DataSummaryResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CreatePostRequest;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CommentRequest;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Message;
import br.com.lab360.bioprime.logic.model.pojo.timeline.MessageResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;
import br.com.lab360.bioprime.logic.model.pojo.timeline.PostCreation;
import br.com.lab360.bioprime.logic.model.pojo.timeline.PostLog;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 17/01/2017.
 */

public class TimelineInteractor extends BaseInteractor {

    public TimelineInteractor(Context context) {
        super(context);
    }

    public void createPost(final PostLog log, final PostCreation post, final OnPostCreatedListener listener) {
        CreatePostRequest request = new CreatePostRequest(log,post);
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.createTimelinePost(request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onCreatePostError(AdaliveApplication.getInstance().getString(R.string.ERROR_POST_TIMELINE));
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onCreatePostSuccess(post);
                    }
                });
    }

    public void loadFirstPosts(int masterEventId, int limit, final OnPostsLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.listTimelinePostsLimit(masterEventId, limit)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ArrayList<Post>>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onLoadPostError(e.getMessage());
                    }

                    @Override
                    public void onNext(ArrayList<Post> posts) {
                        listener.onLoadPostsSuccess(posts);
                    }
                });
    }

    public void loadPosts(int masterEventId, int postID, String type, final OnPostsLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        //aqui *****
        adaliveApi.listTimelinePosts(masterEventId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ArrayList<Post>>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onLoadPostError(e.getMessage());
                    }

                    @Override
                    public void onNext(ArrayList<Post> posts) {
                        listener.onLoadPostsSuccess(posts);
                    }
                });
    }

    public void removePost(int masterEventID, int userId, int postId, final OnPostRemovedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.removeTimelinePost(masterEventID, userId, postId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<MessageResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onRemovePostError(e.getMessage());
                    }

                    @Override
                    public void onNext(MessageResponse response) {
                        listener.onPostRemoveSuccess(response);
                    }
                });
    }

    public void likePost(final int postId, int userId, final OnPostLikedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.likeTimelinePost(postId, userId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onLikePostError(postId, e.getMessage());
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onLikePostSuccess(post);
                    }
                });
    }

    public void unlikePost(final int postId, int userId, final OnPostUnlikedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.unlikeTimelinePost(postId, userId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUnlikePostError(postId, e.getMessage());
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onUnlikePostSuccess(post);
                    }
                });
    }

    public void addPostComment(int postId, int userId, Message comment, final OnCommentPostedListener listener) {
        CommentRequest request = new CommentRequest(comment);
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.commentTimelinePost(postId, userId, request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onPostCommentError(e.getMessage());
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onPostCommentSuccess(post);
                    }
                });
    }

    public void updatePostComment(int postId, int userId, int commentId, Message comment, final OnCommentUpdatedListener listener) {
        CommentRequest request = new CommentRequest(comment);
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.updateTimelineComment(postId, userId, commentId, request)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onCommentUpdateError(e.getMessage());
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onCommentUpdateSuccess(post);
                    }
                });
    }

    public void removePostComment(int postId, int userId, int commentId, final OnCommentRemovedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.removeTimelineComment(postId, userId, commentId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Post>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onCommentRemoveError(e.getMessage());
                    }

                    @Override
                    public void onNext(Post post) {
                        listener.onCommentRemoveSuccess(post);
                    }
                });
    }

    public void getSummaryData(int appUserID, final OnDataSummaryListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getSummaryData(appUserID)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<DataSummaryResponse>() {
                    @Override
                    public void onCompleted() {}

                    @Override
                    public void onError(Throwable e) {
                        listener.onDataSummaryLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(DataSummaryResponse response) {
                        listener.onDataSummaryLoadSuccess(response.getDataSummary());
                    }
                });

    }

    public void loadBanner(final OnBannerLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getBanners()
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<BannerResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onBannerLoadError(e);
                    }

                    @Override
                    public void onNext(BannerResponse response) {
                        listener.onBannerLoadSuccess(response);
                    }
                });
    }
}
