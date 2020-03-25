package br.com.lab360.bioprime.ui.activity.geofence;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.appcompat.widget.Toolbar;

import com.google.common.base.Strings;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.presenter.geofence.GeofencePresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.fragments.geofence.GeofenceMapFragment;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.ButterKnife;

/**
 * Created by Edson on 24/08/2018.
 */

public class GeofenceActivity extends BaseActivity implements GeofencePresenter.IGeofenceView {

    static public boolean geofencesAlreadyRegistered = false;
    GeofencePresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_geofence);

        ButterKnife.bind(this);
        new GeofencePresenter(this);
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        getSupportActionBar().setTitle(R.string.BUTTON_SHOWCASE);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void setPresenter(GeofencePresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void startFragmentMap() {
        Fragment f = new GeofenceMapFragment();
        FragmentManager fragmentManager = getSupportFragmentManager();
        fragmentManager.beginTransaction().replace(R.id.fragment, f).commit();
        fragmentManager.executePendingTransactions();
    }
}

