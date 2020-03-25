package br.com.lab360.bioprime.logic.presenter.sponsors;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collection;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.interactor.SponsorsInteractor;
import br.com.lab360.bioprime.logic.listeners.OnGetSponsorsListener;
import br.com.lab360.bioprime.logic.listeners.OnGetSponsorsPlanListener;
import br.com.lab360.bioprime.logic.model.pojo.sponsor.SponsorsPlan;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.SponsorTitleEvent;
import br.com.lab360.bioprime.ui.view.INavigationDrawerView;
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
