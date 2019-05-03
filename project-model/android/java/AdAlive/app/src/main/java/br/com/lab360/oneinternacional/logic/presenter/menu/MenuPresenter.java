package br.com.lab360.oneinternacional.logic.presenter.menu;

import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 07/06/2018.
 */

public class MenuPresenter implements IBasePresenter {

    private IMenuView view;

    public MenuPresenter(IMenuView view) {
        this.view = view;
    }

    @Override
    public void start() {
    }

    public interface IMenuView extends IBaseView {

        void setPresenter(MenuPresenter presenter);

    }
}
