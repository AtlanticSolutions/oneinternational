package br.com.lab360.bioprime.logic.presenter.events;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */
public class EventListPresenter implements IBasePresenter {
    private final ArrayList<Event> mEvents;
    private final boolean showOnlyRegistered;
    private IEventListView mView;

    public EventListPresenter(IEventListView view, ArrayList<Event> events, boolean showOnlyRegistered) {
        this.mView = view;
        this.mEvents = events;
        this.showOnlyRegistered = showOnlyRegistered;
        this.mView.setPresenter(this);
    }

    //region Public Methods
    @Override
    public void start() {
        mView.setColorViews();
        if(showOnlyRegistered){
            for(Event event : (ArrayList<Event>)mEvents.clone()){
                if(!event.isRegistered())
                    mEvents.remove(event);
            }
        }

        if(mEvents.size() == 0){
            mView.showEmptyListText();
            return;
        }
        mView.setupRecyclerView(mEvents);
    }

    public void onEventTouched(int position) {
        mView.navigateToEventDetailsActivity(mEvents.get(position),showOnlyRegistered);
    }
    //endregion


    public interface IEventListView {
        void setPresenter(EventListPresenter presenter);

        void setColorViews();

        void setupRecyclerView(ArrayList<Event> mEvents);

        void navigateToEventDetailsActivity(Event event, boolean showOnlyRegistered);

        void showEmptyListText();

    }
}