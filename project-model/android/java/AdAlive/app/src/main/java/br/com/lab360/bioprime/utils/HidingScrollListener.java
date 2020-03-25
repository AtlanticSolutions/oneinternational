package br.com.lab360.bioprime.utils;

/**
 * Created by Alessandro Valenza on 20/01/2017.
 */

import androidx.recyclerview.widget.RecyclerView;

public abstract class HidingScrollListener extends RecyclerView.OnScrollListener {

    private static final float HIDE_THRESHOLD = 10;
    private static final float SHOW_THRESHOLD = 70;

    private int mViewOffset = 0;
    private boolean mControlsVisible = true;
    private int mViewHeight;
    private int mTotalScrolledDistance;

    public HidingScrollListener(int height) {
        mViewHeight = height;
    }

    @Override
    public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
        super.onScrollStateChanged(recyclerView, newState);

        if(newState == RecyclerView.SCROLL_STATE_IDLE) {
            if(mTotalScrolledDistance < mViewHeight) {
                setVisible();
            } else {
                if (mControlsVisible) {
                    if (mViewOffset > HIDE_THRESHOLD) {
                        setInvisible();
                    } else {
                        setVisible();
                    }
                } else {
                    if ((mViewHeight - mViewOffset) > SHOW_THRESHOLD) {
                        setVisible();
                    } else {
                        setInvisible();
                    }
                }
            }
        }

    }

    @Override
    public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
        super.onScrolled(recyclerView, dx, dy);

        clipToolbarOffset();
        onMoved(mViewOffset);

        if((mViewOffset < mViewHeight && dy>0) || (mViewOffset >0 && dy<0)) {
            mViewOffset += dy;
        }
        if (mTotalScrolledDistance < 0) {
            mTotalScrolledDistance = 0;
        } else {
            mTotalScrolledDistance += dy;
        }
    }

    private void clipToolbarOffset() {
        if(mViewOffset > mViewHeight) {
            mViewOffset = mViewHeight;
        } else if(mViewOffset < 0) {
            mViewOffset = 0;
        }
    }

    private void setVisible() {
        if(mViewOffset > 0) {
            onShow();
            mViewOffset = 0;
        }
        mControlsVisible = true;
    }

    private void setInvisible() {
        if(mViewOffset < mViewHeight) {
            onHide();
            mViewOffset = mViewHeight;
        }
        mControlsVisible = false;
    }

    public abstract void onMoved(int distance);
    public abstract void onShow();
    public abstract void onHide();
}