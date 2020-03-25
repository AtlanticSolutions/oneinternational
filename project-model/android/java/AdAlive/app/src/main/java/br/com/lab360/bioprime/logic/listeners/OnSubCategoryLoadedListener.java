package br.com.lab360.bioprime.logic.listeners;


import br.com.lab360.bioprime.logic.model.pojo.category.SubCategoriesResponse;

/**
 * Created by Edson on 20/04/2018.
 */

public interface OnSubCategoryLoadedListener {

    void onSubCategoryLoadError(Throwable e);
    void onSubCategoryLoadSuccess(SubCategoriesResponse response);
}
