package br.com.lab360.oneinternacional.ui.activity.sponsors;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.SponsorsPlan;
import br.com.lab360.oneinternacional.logic.presenter.sponsors.SponsorsPresenter;
import br.com.lab360.oneinternacional.ui.activity.NavigationDrawerActivity;
import br.com.lab360.oneinternacional.ui.fragments.sponsors.SponsorsGridFragment;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class SponsorsActivity extends NavigationDrawerActivity implements SponsorsPresenter.ISponsorsView {

    @BindView(R.id.container_loading)
    protected LinearLayout mContainerLoading;

    public Toolbar toolbar;

    private SponsorsPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sponsors);
        ButterKnife.bind(this);

        new SponsorsPresenter(this);

        mContainerLoading.bringToFront();

    }


    @Override
    protected void onDestroy() {
        mPresenter.onDestroy();
        super.onDestroy();
    }

    @Override
    public void initToolbar() {
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
        setToolbarTitle(R.string.SCREEN_TITLE_SPONSORS);

        ivMenu.setVisibility(View.GONE);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void initSponsorsGridFragment(ArrayList<SponsorsPlan> sponsors) {

        FragmentManager fragmentManager = getSupportFragmentManager();
        FragmentTransaction ft = fragmentManager.beginTransaction();

        SponsorsGridFragment sponsorsGridFragment = SponsorsGridFragment.newInstance(sponsors);
        String partnersGridFragmentName = sponsorsGridFragment.getClass().getName();

        ft.replace(R.id.fl_sponsor_container, sponsorsGridFragment, partnersGridFragmentName)
                .commit();

    }

    @Override
    public void setPresenter(SponsorsPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void hideLoadingContainer() {

        mContainerLoading.setVisibility(View.GONE);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }

        return super.onOptionsItemSelected(item);

    }
}
