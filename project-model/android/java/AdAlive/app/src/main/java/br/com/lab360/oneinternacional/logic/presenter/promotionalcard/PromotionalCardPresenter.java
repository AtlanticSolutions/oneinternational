package br.com.lab360.oneinternacional.logic.presenter.promotionalcard;

import android.graphics.Bitmap;
import android.view.View;

import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

public class PromotionalCardPresenter implements IBasePresenter {
    private PromotionalCardPresenter.IPromotionalCardView mView;

    public PromotionalCardPresenter(PromotionalCardPresenter.IPromotionalCardView view) {
        this.mView = view;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initDataExtras();
        mView.populateVariables();
        mView.initToolbar();
        mView.initialAnimations();
        mView.firstPopulationViews();
    }

    public interface IPromotionalCardView extends IBaseView {
        void initToolbar();
        void initDataExtras();
        void initialAnimations();
        void finalAnimations();
        void firstPopulationViews();
        void populateVariables();
        void loadLayoutImagePrize(Bitmap bitmap, int preferedSize, int preferedPosition);
        void loadImageBackgroundCard(Bitmap bitmap);
        void loadImageCoverCard(Bitmap bitmap);
        void loadImageBackgroundScreen(Bitmap bitmap);
        void loadAnimationImage(Bitmap bitmap);
        void loadTextInfo(String info);
        void loadColorBorderPromotionalCard(String color);
        void createRandomPlaceForPrize();
        void createCenterPlaceForPrize();
        void configurePositionImagePrize(int preferedPosition);
        double configureSizeImagePrize(int preferedSize);
        void setAreaToErase(int x, int y);
        void setEraserSize(double lineLimit);
        void setErasePercent(double coverLimit);
        void setEraseStatusListener();
        void configureCoverCard(double coverLimit, double lineLimit);
        void setPresenter(PromotionalCardPresenter presenter);
        void showAwardedDialog();
        void showNotAwardedDialog();
        void showProgressErasingDialog();
        void showTutorialDialog();
        View.OnClickListener onClickDialogButton(int id);
        void playSoundEffect();
        void disableToolbarActions();
    }

}