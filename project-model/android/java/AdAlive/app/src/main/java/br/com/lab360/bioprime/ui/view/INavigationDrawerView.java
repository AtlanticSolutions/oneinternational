package br.com.lab360.bioprime.ui.view;

import java.util.List;

import br.com.lab360.bioprime.logic.model.pojo.menu.MenuItem;

/**
 * Created by Alessandro Valenza on 24/11/2016.
 */

public interface INavigationDrawerView extends IBaseView {
    void closeDrawer();

    void setUserPhoto(String imageUrl);

    void setToolbarTitle(int title);

    void setToolbarTitle(String title);

    void configRecyclerView();

    List<MenuItem> loadMenuItems();

    List<MenuItem> sortMenuItems(List<MenuItem> menuItems);

    void navigateToAgendaActivity();

    void navigateToTimelineActivity();

    void navigateToEventsActivity();

    void navigateToSponsorsActivity();

    void navigateToManagerApplicationActivity();

    void navigateToGeofenceActivity();

    void navigateToPromotionalCardActivity();

    void navigateToEquip();

    void navigateToScannerActivity();

    void navigateToShowCaseActivity();

    void navigateToAboutActivity();

    void navigateToShowCase360();

    void navigateToEditProfileActivity();

    void navigateToDocumentsActivity();

    void navigateToChatActivity();

    void navigateToVideosActivity();

    void createSubscription();

    void navigateLogOut();

    void navigateToParticipants();

    void navigateToGeneralSurvey();

}
