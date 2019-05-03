package br.com.lab360.oneinternacional.ui.view;

import android.app.Activity;

import br.com.lab360.oneinternacional.logic.model.pojo.user.User;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */

public interface IBaseView {

    void showProgress();

    void hideProgress();

    void showToastMessage(String message);

    void showSnackMessage(String message);

    void showNoConnectionSnackMessage();

    void showFixedSnackMessage(String message);

    void hideFixedSnackMessage();

    void hideKeyboard();

    boolean isGooglePlayServicesAvailable();

    boolean isOnline();

    String getResourceString(int resourceId);

    void saveUserIntoSharedPreferences(User response);

    void userLogOut();

    void loadApplicationBackground();

    void loadCachedBackground();

    void loadBackground(String url);

    String getDeviceId();

    Activity getContext();
}
