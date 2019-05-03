package br.com.lab360.oneinternacional.logic.interactor;

import android.content.Context;

import br.com.lab360.oneinternacional.logic.model.pojo.utils.CepResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.customer.Customer;
import br.com.lab360.oneinternacional.logic.model.pojo.customer.CustomerResponse;
import br.com.lab360.oneinternacional.logic.rest.AdaliveApi;
import br.com.lab360.oneinternacional.logic.rest.AdaliveServiceFactory;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by paulo on 08/11/2017.
 */

public class PromotionRegisterInteractor extends BaseInteractor{

    public PromotionRegisterInteractor(Context context) {
        super(context);
    }

    /**
     * Call back interface that retrieve the success or not about address information that is retrieve from postmail service
     */
    public interface CepInteractorListener{
        void onGetCepSuccess(CepResponse cepResponse);

        void onCepError(String message);
    }

    public interface RetrieveCustomerInteractorListener{

        void onRetrieveCustomerSuccess(Customer customer);

        void onRetrieveCustomerError(String message);

    }

    /**
     *
     *
     */
    public interface RetrieveCustomerByCpf{

        void onGetCustomerByCpfSuccess(CustomerResponse customerResponse);

        void onGetCustomerByCpfError(String message);


    }


    /**
     *
     * It calls a resp api service that retrieve the customer data if the customer already exists.
     * @param token
     * @param listener
     */
    @Deprecated
    public void retrieveUser(String token, final RetrieveCustomerInteractorListener listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getCustomerData(token)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<Customer>() {
                    @Override
                    public void onCompleted() {}

                    @Override
                    public void onError(Throwable e) {
                        listener.onRetrieveCustomerError(e.getMessage());
                    }

                    @Override
                    public void onNext(Customer response) {
                        listener.onRetrieveCustomerSuccess(response);
                    }
                });

    }


    /**
     * This method gets user information like name by cpf
     * @param token
     * @param cpf user cpf that's writedown by the user
     * @param listener
     */
    public void getCustomerByCpf(String token, String cpf, final RetrieveCustomerByCpf listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getCustomerByCPF(token, cpf)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<CustomerResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetCustomerByCpfError(e.getMessage());
                    }

                    @Override
                    public void onNext(CustomerResponse customerResponse) {
                        if (customerResponse.getCustomer() == null) {
                            listener.onGetCustomerByCpfError(customerResponse.getStatus());
                        } else {
                            listener.onGetCustomerByCpfSuccess(customerResponse);
                        }

                    }
                });


    }

    /**
     *
     * @param cep
     * @param listener
     */
    public void getCepAdress(String cep, final CepInteractorListener listener){
        AdaliveApi adaliveApi = AdaliveServiceFactory.createAdaliveService();//ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getAdress(cep).subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<CepResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                      listener.onCepError(e.getMessage());
                    }

                    @Override
                    public void onNext(CepResponse cepResponse) {
                        listener.onGetCepSuccess(cepResponse);
                    }
                });
    }

}
