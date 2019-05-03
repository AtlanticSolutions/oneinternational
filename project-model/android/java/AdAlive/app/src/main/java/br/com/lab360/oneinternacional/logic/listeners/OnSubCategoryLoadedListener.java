package br.com.lab360.oneinternacional.logic.listeners;


import br.com.lab360.oneinternacional.logic.model.pojo.category.SubCategoriesResponse;

/**
 * Created by Edson on 20/04/2018.
 */

public interface OnSubCategoryLoadedListener {

    void onSubCategoryLoadError(Throwable e);
    void onSubCategoryLoadSuccess(SubCategoriesResponse response);
}
