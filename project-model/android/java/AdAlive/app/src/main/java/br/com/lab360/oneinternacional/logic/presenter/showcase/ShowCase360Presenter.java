package br.com.lab360.oneinternacional.logic.presenter.showcase;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCase360Presenter implements IBasePresenter{
    private ShowCase360Presenter.IShowCaseView mView;
    private ArrayList<NotificationObject> mItems;

    public ShowCase360Presenter(ShowCase360Presenter.IShowCaseView view) {
        this.mView = view;
        this.mItems = new ArrayList<>();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.setColorButtons();
    }

    public interface IShowCaseView extends IBaseView {
        void initToolbar();
        void setPresenter(ShowCase360Presenter presenter);
        void setColorButtons();
        void accessRotateProduct();
        void accessVideo360();
    }
}