package br.com.lab360.oneinternacional.logic.presenter.showcase;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.interactor.ShowCaseInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnShowCaseListener;
import br.com.lab360.oneinternacional.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseGalery;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseResponse;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

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