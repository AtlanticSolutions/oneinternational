package br.com.lab360.bioprime.logic.listeners;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnGroupLoadedListener {
    void onActiveGroupsLoadSuccess(ArrayList<BaseObject> groups);

    void onActiveGroupsLoadError(String message);
}
