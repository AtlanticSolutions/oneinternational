package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import br.com.lab360.oneinternacional.logic.model.pojo.customer.Customer;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by paulo on 08/11/2017.
 */
public class CustomerInteractor extends BaseInteractor {

    public CustomerInteractor(Context context) {
        super(context);
    }

    /**
     * This interface declares the mandatory methods to return the endPoint response.
     */
    public interface CustomerInteractorListener {
        /**
         * Return the data
         *
         * @param data A valid data
         */
        void onCustomerDataLoadSuccess(Customer data);

        /**
         * Returns a message in case of error
         *
         * @param message The message to be presented to the user
         */
        void onCustomerDataLoadError(String message);
    }

    /**
     * Retrieve the customer data
     *
     * @param listener The listener
     * @param token    The user token
     */
    public void getCustomerData(final CustomerInteractorListener listener, String token) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        // METHOD: GET
        // URL: <dominio>/api/v1/shopping/customer

        adaliveApi.getCustomerData(token)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Customer>() {
                    @Override
                    public void onCompleted() {
                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onCustomerDataLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(Customer response) {
                        listener.onCustomerDataLoadSuccess(response);
                    }
                });
    }

}
