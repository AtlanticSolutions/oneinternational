package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;

import br.com.lab360.bioprime.logic.listeners.OnSubCategoryLoadedListener;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategoriesResponse;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Edson on 20/04/2018.
 */

public class SubCategoryInteractor extends BaseInteractor {

    public SubCategoryInteractor(Context context) {
        super(context);
    }

    public void getSubCategoryCategories(String token, String limit, String offset, int typeCategory, int categoryId, int subCategoryId, final OnSubCategoryLoadedListener listener) {

        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.searchSubCategories(token, limit, offset, typeCategory, categoryId, subCategoryId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<SubCategoriesResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onSubCategoryLoadError(e);
                    }

                    @Override
                    public void onNext(SubCategoriesResponse response) {
                        listener.onSubCategoryLoadSuccess(response);
                    }
                });
    }

}