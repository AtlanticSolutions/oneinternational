package br.com.lab360.oneinternacional.logic.presenter.sponsors;

import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.Sponsor;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;

/**
 * Created by Victor Santiago on 01/12/2016.
 */

public class SponsorDetailPresenter implements IBasePresenter {
    private Sponsor mSponsor;
    private ISponsorDetailView mView;

    public SponsorDetailPresenter(ISponsorDetailView view, Sponsor sponsor) {
        this.mView = view;
        this.mSponsor = sponsor;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.configWebView(mSponsor.getUrlSponsorPage());
    }

    public interface ISponsorDetailView {
        void setPresenter(SponsorDetailPresenter presenter);

        void configWebView(String urlSponsorPage);

        void removeLoadingDialog();

    }

}
