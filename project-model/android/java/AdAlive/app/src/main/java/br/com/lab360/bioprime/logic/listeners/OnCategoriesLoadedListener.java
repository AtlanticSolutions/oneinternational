package br.com.lab360.bioprime.logic.listeners;


import java.util.List;

import br.com.lab360.bioprime.logic.model.pojo.category.Category;

/**
 * Created by Edson on 20/04/2018.
 */

public interface OnCategoriesLoadedListener {

    void onCategoriesLoadError(String message);
    void onCategoriesLoadSuccess(List<Category> response);
}
