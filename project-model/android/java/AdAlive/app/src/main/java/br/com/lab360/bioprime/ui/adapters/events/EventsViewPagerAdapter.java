package br.com.lab360.bioprime.ui.adapters.events;

import android.content.Context;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import android.view.LayoutInflater;
import android.view.View;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;

/**
 * Created by Victor Santiago on 14/10/2016.
 */
public class EventsViewPagerAdapter extends FragmentPagerAdapter {

    private final List<Fragment> mFragmentList = new ArrayList<>();
    private final List<String> mFragmentTitleList = new ArrayList<>();

    private Context context;

    public EventsViewPagerAdapter(FragmentManager manager, Context context) {
        super(manager);
        this.context = context;
    }

    @Override
    public Fragment getItem(int position) {

        return mFragmentList.get(position);
    }

    @Override
    public int getCount() {
        return mFragmentList.size();
    }

    public void addFragment(Fragment fragment, String title) {
        mFragmentList.add(fragment);
        mFragmentTitleList.add(title);
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mFragmentTitleList.get(position);
    }

    public View getTabView(int position) {

        View v;

        // Given you have a custom layout in `res/layout/custom_tab.xml` with a TextView and ImageView
        if (position == 0) {

            v = LayoutInflater.from(context).inflate(R.layout.fragment_event_list, null);

        } else {

            v = LayoutInflater.from(context).inflate(R.layout.fragment_event_calendar, null);

        }

        return v;
    }
}