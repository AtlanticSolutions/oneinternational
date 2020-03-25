package br.com.lab360.bioprime.logic.presenter.managerapplication;

import android.util.Log;

import java.util.List;

import br.com.lab360.bioprime.logic.interactor.ManagerApplicationInteractor;
import br.com.lab360.bioprime.logic.listeners.OnManagerApplicationLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplication;
import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplicationResponse;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;

/**
 * Created by Edson on 28/06/2018.
 */

public class ManagerApplicationPresenter implements IBasePresenter, OnManagerApplicationLoadedListener {

    private ManagerApplicationPresenter.IManagerApplicationView mView;
    private ManagerApplicationInteractor mInteractor;

    public ManagerApplicationPresenter(ManagerApplicationPresenter.IManagerApplicationView mView) {
        this.mView = mView;
        this.mInteractor = new ManagerApplicationInteractor(mView.getContext());
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mInteractor.getManagerApplication(this);
    }

    @Override
    public void onManagerApplicationLoadSuccess(ManagerApplicationResponse response) {
        mView.configRecyclerView(response.getManagerApplications());
    }

    @Override
    public void onManagerApplicationLoadError(Throwable e) {
        Log.e("ERROR", e.getMessage());
    }

    public interface IManagerApplicationView extends IBaseView {
        void setmPresenter(ManagerApplicationPresenter mPresenter);
        void initToolbar();
        void configRecyclerView(List<ManagerApplication> responseBody);
    }
}