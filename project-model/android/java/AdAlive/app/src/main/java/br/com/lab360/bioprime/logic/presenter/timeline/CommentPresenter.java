package br.com.lab360.bioprime.logic.presenter.timeline;

import com.google.common.base.Strings;

import java.util.ArrayList;
import java.util.Collections;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.interactor.TimelineInteractor;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentPostedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentRemovedListener;
import br.com.lab360.bioprime.logic.listeners.Timeline.OnCommentUpdatedListener;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CommentObject;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Message;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;
import br.com.lab360.bioprime.ui.view.IBaseView;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */
public class CommentPresenter implements
        OnCommentPostedListener,
        OnCommentRemovedListener,
        OnCommentUpdatedListener {

    private Post mSelectedPost;
    private final TimelineInteractor mTimelineInteractor;
    private final int mUserId;
    private ICommentView mView;

    public CommentPresenter(ICommentView view, Post post) {
        this.mView = view;
        this.mSelectedPost = post;
        this.mTimelineInteractor = new TimelineInteractor(mView.getContext());
        this.mUserId = AdaliveApplication.getInstance().getUser().getId();
        this.mView.setPresenter(this);
    }

    public void start() {
        mView.initToolbar();
        Collections.reverse(mSelectedPost.getComment());
        mView.setupCommentsRecyclerView(mSelectedPost.getComment());
    }

    public void onBtnSendMessageTouched(String insertedText) {
        if(Strings.isNullOrEmpty(insertedText)){
            return;
        }
        mView.clearEditText();
        mView.showProgress();
        mTimelineInteractor.addPostComment(mSelectedPost.getId(),mUserId,new Message(insertedText),this);
    }


    public void onBtnRemoveCommentTouched(int position) {
        mTimelineInteractor.removePostComment(mSelectedPost.getId(),mUserId,mSelectedPost.getComment().get(position).getId(),this);
    }

    public void onBtnUpdateCommentTouched(int position) {
        mTimelineInteractor.updatePostComment(mSelectedPost.getId(),mUserId,mSelectedPost.getComment().get(position).getId(),new Message("Esse comentário foi atualizado!"),this);
    }


    //region OnCommentPostedListener
    @Override
    public void onPostCommentError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }

    @Override
    public void onPostCommentSuccess(Post post) {
        mView.hideProgress();
        mSelectedPost = post;
        mView.populateCommentsRecyclerView(mSelectedPost.getComment());

    }
    //endregion

    //region OnCommentRemovedListener
    @Override
    public void onCommentRemoveSuccess(Post post) {
    }

    @Override
    public void onCommentRemoveError(String message) {
        mView.showToastMessage(message);
    }
    //endregion
    //region OnCommentUpdatedListener
    @Override
    public void onCommentUpdateError(String message) {
        mView.showToastMessage(message);
    }

    @Override
    public void onCommentUpdateSuccess(Post post) {
        mView.showToastMessage("onCommentUpdateSuccess");
    }
    //endregion

    public interface ICommentView extends IBaseView {
        void initToolbar();

        void setPresenter(CommentPresenter presenter);

        void clearEditText();

        void setupCommentsRecyclerView(ArrayList<CommentObject> comments);

        void populateCommentsRecyclerView(ArrayList<CommentObject> comments);
    }
}