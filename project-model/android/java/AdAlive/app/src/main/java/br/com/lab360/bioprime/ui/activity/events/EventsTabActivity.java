package br.com.lab360.bioprime.ui.activity.events;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import com.google.android.material.tabs.TabLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.view.View;

import com.google.common.base.Strings;


import java.util.ArrayList;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.presenter.events.EventsTabPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.adapters.events.EventsViewPagerAdapter;
import br.com.lab360.bioprime.ui.fragments.events.EventCalendarFragment;
import br.com.lab360.bioprime.ui.fragments.events.EventListFragment;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class EventsTabActivity extends BaseActivity implements EventsTabPresenter.IEventsTabView {

    @BindView(R.id.tablayout)
    protected TabLayout mTabLayout;

    @BindView(R.id.viewpager)
    protected ViewPager mViewPager;

    private EventsTabPresenter mPresenter;
    private boolean onlyRegistered;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_events_tab);

        ButterKnife.bind(this);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            onlyRegistered = extras.getBoolean(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED);
            AdaliveApplication.getInstance().setShowOnlyRegisteredEvents(onlyRegistered);
        }else{
            onlyRegistered = AdaliveApplication.getInstance().shouldShowOnlyRegisteredEvents();
        }
        new EventsTabPresenter(this, onlyRegistered);
    }
    //endregion

    //region IEventsTabView
    @Override
    public void setPresenter(EventsTabPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {

        if (onlyRegistered) {
            initToolbar(getString(R.string.SCREEN_TITLE_MY_AGENDA));
        }else {
            initToolbar(getString(R.string.SCREEN_TITLE_EVENT_TABS));
        }

        getSupportActionBar().setElevation(0);
    }

    @Override
    public void setupTabLayout() {
        mTabLayout.addTab(mTabLayout.newTab().setText(getString(R.string.LABEL_LIST)));
        mTabLayout.addTab(mTabLayout.newTab().setText(getString(R.string.LABEL_CALENDAR)));
        mTabLayout.setTabGravity(TabLayout.GRAVITY_FILL);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            mTabLayout.setBackground(cd);
        }

        mTabLayout.setupWithViewPager(mViewPager);
    }

    @Override
    public void setupViewPager(ArrayList<Event> events, boolean showOnlyRegistered) {
        Fragment eventListFragment = EventListFragment.newInstance(events, showOnlyRegistered);
        Fragment eventCalendarFragment = EventCalendarFragment.newInstance(events, showOnlyRegistered);

        EventsViewPagerAdapter adapter = new EventsViewPagerAdapter(getSupportFragmentManager(), this);

        adapter.addFragment(eventCalendarFragment, getString(R.string.LABEL_CALENDAR));
        adapter.addFragment(eventListFragment, getString(R.string.LABEL_LIST));

        mViewPager.setAdapter(adapter);
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
            }

            @Override
            public void onPageSelected(int position) {
                mViewPager.setCurrentItem(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    @Override
    public void showTabLayout() {
        mTabLayout.setVisibility(View.VISIBLE);
        mTabLayout.setAlpha(0);
        mTabLayout.animate()
                .alpha(1)
                .setDuration(1000)
                .withLayer()
                .setListener(new AnimatorListenerAdapter() {
                    @Override
                    public void onAnimationEnd(Animator animation) {
                        super.onAnimationEnd(animation);
                        mTabLayout.setScaleY(1);
                        mTabLayout.setAlpha(1);
                    }
                });
    }

    @Override
    public void showViewPager() {
        mViewPager.setVisibility(View.VISIBLE);

    }
    //endregion
}
