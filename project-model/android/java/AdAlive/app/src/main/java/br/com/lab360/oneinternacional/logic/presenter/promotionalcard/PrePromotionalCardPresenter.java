package br.com.lab360.oneinternacional.logic.presenter.promotionalcard;

import android.view.View;

import java.util.List;

import br.com.lab360.oneinternacional.logic.interactor.PromotionalCardInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnPromotionalCardLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard.Plist;
import br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard.PromotionalCard;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

public class PrePromotionalCardPresenter implements IBasePresenter, OnPromotionalCardLoadedListener {
    private PrePromotionalCardPresenter.IPrePromotionalCardView mView;
    private PromotionalCardInteractor interactor;

    public PrePromotionalCardPresenter(PrePromotionalCardPresenter.IPrePromotionalCardView view) {
        this.mView = view;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        interactor = new PromotionalCardInteractor(mView.getContext());
        mView.initToolbar();
        mView.setColorViews();
    }

    public void getPromotionalCard(String cardName) {
        mView.showProgress();
        interactor.getPromotionalCard("card_" + cardName, this);
    }

    @Override
    public void onPromotionalCardLoadSuccess(Plist response) {
        PromotionalCard promotionalCard = parseXMLToObject(response);
        mView.loadPromotionalCardSuccess(promotionalCard);
    }

    public PromotionalCard parseXMLToObject(Plist plist){
        PromotionalCard promotionalCard = PromotionalCard.parse(plist);
        return promotionalCard;
    }

    @Override
    public void onPromotionalCardLoadError(String message) {
        mView.hideProgress();
        mView.showErrorMessage(message);
    }

    public interface IPrePromotionalCardView extends IBaseView {
        void loadPromotionalCardSuccess(PromotionalCard promotionalCard);
        void initToolbar();
        void setColorViews();
        void setPresenter(PrePromotionalCardPresenter presenter);
        void showErrorMessage(String message);
        void showPromotionalTypeDialog(PromotionalCard promotionalCard, List<String> base64Images);
        void showInformativeDialog();
        void attemptToLoadImages(PromotionalCard promotionalCard);
        void attemptToNextActivity(PromotionalCard promotionalCard, List<String> base64Images, boolean isAwarded);
        View.OnClickListener onClickDialogButton(int id);
        void startNextActivity(PromotionalCard promotionalCard, List<String> base64Images, boolean isAwarded);
    }

}