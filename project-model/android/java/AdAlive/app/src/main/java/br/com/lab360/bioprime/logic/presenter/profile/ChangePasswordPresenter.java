package br.com.lab360.bioprime.logic.presenter.profile;

import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.ui.view.IBaseView;
import br.com.lab360.bioprime.utils.UserUtils;

/**
 * Created by Alessandro Valenza on 30/11/2016.
 */
public class ChangePasswordPresenter implements IBasePresenter {
    private IChangePasswordView mView;

    public ChangePasswordPresenter(IChangePasswordView view) {
        this.mView = view;
        this.mView.setPresenter(this);
    }

    public void attemptToSavePendingChanges(String newPassword, String confirmPassword) {
        if(!newPassword.equals(confirmPassword)){
            mView.showPasswordMatchError();
            return;
        }

        if(newPassword.length() < 8 || newPassword.length() > 14){
            mView.showPasswordLenghtError();
            return;
        }

        mView.hideKeyboard();
        mView.setActivityResult(newPassword);
    }

    @Override
    public void start() {
        //mView.initBackground();
        loadLayout();
        mView.setColorViews();
    }

    private void loadLayout() {
        if(UserUtils.getLayoutParam(mView.getContext()) == null) {
            mView.loadCachedBackground();
        }else{
            mView.loadApplicationBackground();
        }
    }

    public interface IChangePasswordView extends IBaseView{
        void setPresenter(ChangePasswordPresenter presenter);

        void setColorViews();

        void setActivityResult(String password);

        void showPasswordMatchError();

        void showPasswordLenghtError();

        //void initBackground();


    }
}