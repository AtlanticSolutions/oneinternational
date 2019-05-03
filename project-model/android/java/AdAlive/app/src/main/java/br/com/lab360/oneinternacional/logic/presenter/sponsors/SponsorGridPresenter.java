package br.com.lab360.oneinternacional.logic.presenter.sponsors;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.Sponsor;
import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.SponsorsPlan;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorGridPresenter implements IBasePresenter {
    private ArrayList<SponsorsPlan> mSponsors;
    private ISponsorsGridView mView;

    public SponsorGridPresenter(ISponsorsGridView mView, ArrayList<SponsorsPlan> sponsors) {
        this.mView = mView;
        this.mSponsors = sponsors;
        this.mView.setmPresenter(this);
    }

    @Override
    public void start() {

        if(mSponsors.size() == 0) {
            mView.showEmptySponsorGridText();
            return;
        }

        mView.configGridView(mSponsors);
    }

    public interface ISponsorsGridView {

        void configGridView(ArrayList<SponsorsPlan> sponsors);

        void navigateToSponsorDetails(Sponsor sponsor);

        void setmPresenter(SponsorGridPresenter mPresenter);

        void showEmptySponsorGridText();
    }
}
