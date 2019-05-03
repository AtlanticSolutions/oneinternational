package br.com.lab360.oneinternacional.logic.presenter.geofence;

import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 24/08/2018.
 */

public class GeofencePresenter implements IBasePresenter {
    private GeofencePresenter.IGeofenceView mView;

    public GeofencePresenter(GeofencePresenter.IGeofenceView view) {
        this.mView = view;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.startFragmentMap();
    }

    public interface IGeofenceView extends IBaseView {
        void initToolbar();
        void setPresenter(GeofencePresenter presenter);
        void startFragmentMap();
    }

}