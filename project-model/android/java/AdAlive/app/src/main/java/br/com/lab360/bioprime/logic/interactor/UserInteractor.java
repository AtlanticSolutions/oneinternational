package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.model.pojo.user.UpdateUserRequest;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by David Canon on 17/01/2018.
 */
public class UserInteractor extends BaseInteractor {

    public UserInteractor(Context context) {
        super(context);
    }

    public interface UpdateCustomerListener {
        void onUpdateSuccess(User user);
        void onUpdateError(String message);
    }


    public void updateCustomer(String token, final UpdateUserRequest updateUser, final UpdateCustomerListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.updateUser(token, updateUser)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<UpdateUserRequest>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUpdateError(e.getMessage());
                    }

                    @Override
                    public void onNext(UpdateUserRequest updateUserRequest) {
                        listener.onUpdateSuccess(updateUser.getUser());
                    }
                });

    }

}
