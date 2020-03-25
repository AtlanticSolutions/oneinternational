package br.com.lab360.bioprime.logic.presenter.showcase;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.interactor.ShowCaseInteractor;
import br.com.lab360.bioprime.logic.listeners.OnShowCaseListener;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseGalery;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseResponse;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCasePresenter implements IBasePresenter, OnShowCaseListener{
    private ShowCasePresenter.IShowCaseView mView;
    private ShowCaseInteractor interactor;
    private ArrayList<NotificationObject> mItems;

    public ShowCasePresenter(ShowCasePresenter.IShowCaseView view) {
        this.mView = view;
        this.mItems = new ArrayList<>();
        interactor = new ShowCaseInteractor(mView.getContext());
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.showProgress();
        interactor.getShowcaseItems(this);
    }

    @Override
    public void onShowCaseLoadSuccess(ShowCaseResponse response) {
        mView.hideProgress();
        if (response.getShowCaseGalery() == null) {
            mView.emptyShowCase();
            mView.onBackPressed();
            return;
        }
        mView.setupRecyclerView(response.getShowCaseGalery());
    }

    @Override
    public void onShowCaseLoadError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }


    public interface IShowCaseView extends IBaseView {
        void initToolbar();
        void setPresenter(ShowCasePresenter presenter);
        void setupRecyclerView(final ShowCaseGalery showCaseGalery);
        void onBackPressed();
        void emptyShowCase();
    }
}