package br.com.lab360.oneinternacional.logic.presenter.sponsors;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.SponsorsInteractor;
import br.com.lab360.oneinternacional.logic.listeners.OnGetSponsorsListener;
import br.com.lab360.oneinternacional.logic.listeners.OnGetSponsorsPlanListener;
import br.com.lab360.oneinternacional.logic.model.pojo.sponsor.SponsorsPlan;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.SponsorTitleEvent;
import br.com.lab360.oneinternacional.ui.view.INavigationDrawerView;
import rx.Observer;
import rx.Subscription;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsPresenter implements IBasePresenter, OnGetSponsorsListener, OnGetSponsorsPlanListener {

    private ISponsorsView mView;
    private SponsorsInteractor mInteractor;
    private Subscription sponsorTitleSubscription;

    public SponsorsPresenter(ISponsorsView mView) {
        this.mView = mView;
        this.mInteractor = new SponsorsInteractor(mView.getContext());
        createSubscriptions();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
//        mInteractor.getSponsors(AdaliveApplication.getInstance().getCodeParams().getMasterEventId(),this);
        mInteractor.getSponsorsPlans(AdaliveConstants.APP_ID,this);
    }

    public void onDestroy(){
        if(sponsorTitleSubscription != null && !sponsorTitleSubscription.isUnsubscribed()){
            sponsorTitleSubscription.unsubscribe();
        }
    }

    //region OnGetSponsorsListener
    @Override
    public void onSponsorsLoadSuccess(JsonArray jsonArray) {
        Gson gson = new Gson();
        Type collectionType = new TypeToken<Collection<SponsorsPlan>>(){}.getType();
        Collection<SponsorsPlan> sponsorCollection = gson.fromJson(jsonArray, collectionType);

        mView.hideLoadingContainer();
        mView.initSponsorsGridFragment(new ArrayList<SponsorsPlan>(sponsorCollection));

    }

    @Override
    public void onSponsorsLoadError(String error) {
        mView.hideLoadingContainer();
        mView.showToastMessage(error);
    }
    //endregion

    //region Private Methods
    private void createSubscriptions() {
        sponsorTitleSubscription = AdaliveApplication.getBus().subscribe(RxQueues.SPONSORS_TITLE_EVENT, new Observer<SponsorTitleEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(SponsorTitleEvent sponsorTitleEvent) {
                mView.setToolbarTitle(sponsorTitleEvent.getTitle());
            }
        });
    }
    //endregion

    public interface ISponsorsView extends INavigationDrawerView {

        void initToolbar();

        void initSponsorsGridFragment(ArrayList<SponsorsPlan> sponsors);

        void setPresenter(SponsorsPresenter presenter);

        void hideLoadingContainer();
    }
}
