package br.com.lab360.bioprime.ui.fragments.sponsors;

import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.model.pojo.sponsor.Sponsor;
import br.com.lab360.bioprime.logic.model.pojo.sponsor.SponsorsPlan;
import br.com.lab360.bioprime.logic.presenter.sponsors.SponsorGridPresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.SponsorTitleEvent;
import br.com.lab360.bioprime.ui.activity.sponsors.SectionOrRow;
import br.com.lab360.bioprime.ui.adapters.sponsors.SponsorAdapter;
import br.com.lab360.bioprime.utils.RecyclerItemClickListener;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsGridFragment extends Fragment implements SponsorGridPresenter.ISponsorsGridView {

    public static final String SPONSORS = "SPONSOR";

    @BindView(R.id.rvGrid)
    protected RecyclerView rvSponsors;

    @BindView(R.id.tvEmpty)
    protected TextView tvEmpty;

    private SponsorAdapter sponsorAdapter;
    private SponsorGridPresenter mPresenter;

    public static SponsorsGridFragment newInstance(ArrayList<SponsorsPlan> sponsors) {

        SponsorsGridFragment sponsorsGridFragment = new SponsorsGridFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelableArrayList(SPONSORS, sponsors);
        sponsorsGridFragment.setArguments(bundle);

        return sponsorsGridFragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle bundle = getArguments();
        ArrayList<SponsorsPlan> mSponsors = null;

        if (bundle != null) {

            mSponsors = bundle.getParcelableArrayList(SPONSORS);
            mSponsors = mSponsors == null ? new ArrayList<SponsorsPlan>() : mSponsors;

        }

        mPresenter = new SponsorGridPresenter(this, mSponsors);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_sponsor_grid, container, false);
        ButterKnife.bind(this, view);

        if (mPresenter != null) {
            mPresenter.start();
        }

        return view;
    }


    @Override
    public void configGridView(final ArrayList<SponsorsPlan> sponsors) {
        rvSponsors.setHasFixedSize(true);


        //order by order field
        Collections.sort(sponsors, new Comparator<SponsorsPlan>() {
            @Override
            public int compare(SponsorsPlan sp1, SponsorsPlan sp2) {
                return  sp1.getOrder() - sp2.getOrder();
            }
        });

        List<SectionOrRow> listSection = new ArrayList<SectionOrRow>();

        //create list of sectionOrRow class
        for (SponsorsPlan section : sponsors) {

            listSection.add(SectionOrRow.createSection(section.getName()));

            for (Sponsor sponsor : section.getmSponsors()){
                listSection.add(SectionOrRow.createRow(sponsor));
            }

        }

        sponsorAdapter = new SponsorAdapter(getActivity(), listSection);

        GridLayoutManager layoutManager = new GridLayoutManager(getActivity(), 2);

        layoutManager.setSpanSizeLookup(new GridLayoutManager.SpanSizeLookup() {
            @Override
            public int getSpanSize(int position) {
                switch(sponsorAdapter.getItemViewType(position)){
                    case 0:
                        return 2;
                    case 1:
                        return 1;
                    default:
                        return -1;
                }
            }
        });

        rvSponsors.setLayoutManager(layoutManager);
        rvSponsors.setAdapter(sponsorAdapter);

        rvSponsors.addOnItemTouchListener(new RecyclerItemClickListener(getActivity(), rvSponsors, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {

                SectionOrRow sectionOrRow = sponsorAdapter.getSponsor(position);

                if (sectionOrRow.isRow()) {

                    Sponsor sponsor = sectionOrRow.getRow();

                    AdaliveApplication.getBus().publish(RxQueues.SPONSORS_TITLE_EVENT, new SponsorTitleEvent(sponsor.getName()));

                    navigateToSponsorDetails(sponsor);
                }

            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));

    }

    @Override
    public void navigateToSponsorDetails(Sponsor sponsor) {

        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        FragmentTransaction ft = fragmentManager.beginTransaction();

        SponsorDetailFragment sponsorDetailFragment = SponsorDetailFragment.newInstance(sponsor);
        String sponsorDetailFragmentName = sponsorDetailFragment.getClass().getName();

        ft.replace(R.id.fl_sponsor_container, sponsorDetailFragment, sponsorDetailFragmentName)
                .addToBackStack(sponsorDetailFragmentName).commit();


    }

    public void setmPresenter(SponsorGridPresenter mPresenter) {
        this.mPresenter = mPresenter;
    }

    @Override
    public void showEmptySponsorGridText() {
        rvSponsors.setVisibility(View.GONE);
        tvEmpty.setVisibility(View.VISIBLE);
    }

}
