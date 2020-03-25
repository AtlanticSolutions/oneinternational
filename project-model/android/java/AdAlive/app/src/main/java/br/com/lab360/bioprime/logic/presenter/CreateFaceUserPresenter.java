package br.com.lab360.bioprime.logic.presenter;

import br.com.lab360.bioprime.ui.view.IBaseView;

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
