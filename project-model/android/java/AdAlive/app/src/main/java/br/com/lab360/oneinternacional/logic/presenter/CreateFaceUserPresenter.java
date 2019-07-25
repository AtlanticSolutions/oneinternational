package br.com.lab360.oneinternacional.logic.presenter;

import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by thiagofaria on 18/01/17.
 */

public class CreateFaceUserPresenter implements IBasePresenter{



    @Override
    public void start() {

    }

    public interface ICreateUserView extends IBaseView {

        void initToolbar();

    }
}
