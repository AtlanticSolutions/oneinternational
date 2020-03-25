package br.com.lab360.bioprime.logic.presenter;

import android.util.Log;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.interactor.ChatInteractor;
import br.com.lab360.bioprime.logic.interactor.LayoutInteractor;
import br.com.lab360.bioprime.logic.listeners.Chat.OnChatRequestListener;
import br.com.lab360.bioprime.logic.listeners.OnLayoutLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.user.LayoutParam;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;
import br.com.lab360.bioprime.ui.view.INavigationDrawerView;
import br.com.lab360.bioprime.utils.UserUtils;

/**
 * Created by Alessandro Valenza on 31/10/2016.
 */
public class MainPresenter implements IBasePresenter, OnLayoutLoadedListener, OnChatRequestListener {
    private final IMainView mView;
    private final LayoutInteractor mInteractor;
    private ChatInteractor mChatInteractor;

    public MainPresenter(IMainView view) {
        this.mView = view;
        this.mInteractor = new LayoutInteractor(mView.getContext());
        this.mChatInteractor = new ChatInteractor(mView.getContext());
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.verifyUserLogged();
    }
    //region Public Methods
    public void onBtnEventsTouched() {
        mView.navigateToEventsActivity();
    }

    public void onBtnPartnersTouched() {
        mView.navigateToPartnersActivity();
    }

    public void onBtnTeamTouched() {
        mView.navigateToTeamActivity();
    }

    public void onBtnScannerTouched() {
        mView.navigateToScannerActivity();
    }
    //endregion


    //region Private Methods
    public void onSharedRegister(User user) {
        AdaliveApplication.getInstance().setUser(user);
        mView.navigateToTimelineActivity();
        mChatInteractor.registerDeviceId(AdaliveConstants.ACCOUNT_ID, user.getId(), AdaliveApplication.getInstance().getFcmToken(),this);
    }
    //endregion

    @Override
    public void onLayoutLoadError() {
        Log.d(getClass().getCanonicalName(), "TIMEOUT ERROR HERE! 12345");
    }

    //region OnLayoutLoadedListener
    @Override
    public void onLayoutLoadSuccess(LayoutParam params) {
        UserUtils.setLayoutParam(params, mView.getContext());
        mView.loadApplicationBackground();
        mView.loadApplicationLogo();
    }
    //endregion

    //region OnChatRequestListener
    @Override
    public void onChatRequestError(String error, int requestType, int position) {
        //Token not registered
    }

    @Override
    public void onChatRequestSuccess(ChatBaseResponse response, int requestType, int position) {
        //Token registered
    }
    //endregion

    public interface IMainView extends INavigationDrawerView{
        void setPresenter(MainPresenter mPresenter);

        void initToolbar();

        void navigateToEventsActivity();

        void navigateToPartnersActivity();

        void navigateToTeamActivity();

        void navigateToScannerActivity();

        void loadApplicationLogo();

        void verifyUserLogged();

    }
}