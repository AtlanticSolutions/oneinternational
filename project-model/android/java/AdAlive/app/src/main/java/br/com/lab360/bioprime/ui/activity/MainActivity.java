package br.com.lab360.bioprime.ui.activity;

import android.graphics.drawable.Drawable;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.presenter.MainPresenter;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainActivity extends NavigationDrawerActivity implements MainPresenter.IMainView {

    @BindView(R.id.ivEventLogo)
    protected ImageView ivEventLogo;

    private MainPresenter mPresenter;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        new MainPresenter(this);
    }
    //endregion

    //Region IMainLogin
    public void setPresenter(MainPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        setToolbarTitle(R.string.SCREEN_TITLE_MAIN);
    }

    @Override
    public void navigateToEventsActivity() {
        /*
        Intent intent = new Intent(this, EventsTabActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED, false);
        startActivity(intent);
        */
    }

    @Override
    public void navigateToPartnersActivity() {
        /*
        Intent intent = new Intent(this, SponsorsActivity.class);
        startActivity(intent);
        */
    }

    @Override
    public void navigateToTeamActivity() {
        /*
        Intent intent = new Intent(this, EquipActivity.class);
        startActivity(intent);
        */
    }

    @Override
    public void navigateToScannerActivity() {
        /*
        Intent intent = new Intent(this, ScannerActivity.class);
        startActivity(intent);
        */
    }

    @Override
    public void loadApplicationLogo() {
        final String logoUrl = UserUtils.getLayoutParam(this).getLogo();
        Glide.with(this)
                .load(logoUrl)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        return false;
                    }
                }).preload();
    }

    @Override
    public void verifyUserLogged() {
        User user = UserUtils.loadUser(this);
        if (!TextUtils.isEmpty(user.getEmail())) {
            mPresenter.onSharedRegister(user);
        }
    }

    @OnClick({R.id.btnEvents, R.id.btnPartners, R.id.btnTeam, R.id.btnScanner})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnEvents:
                mPresenter.onBtnEventsTouched();
                break;
            case R.id.btnPartners:
                mPresenter.onBtnPartnersTouched();
                break;
            case R.id.btnTeam:
                mPresenter.onBtnTeamTouched();
                break;
            case R.id.btnScanner:
                mPresenter.onBtnScannerTouched();
                break;
        }
    }
}
