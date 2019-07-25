package br.com.lab360.oneinternacional.ui.fragments.events;


import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.user.Event;
import br.com.lab360.oneinternacional.logic.presenter.events.EventListPresenter;
import br.com.lab360.oneinternacional.ui.activity.events.EventDetailActivity;
import br.com.lab360.oneinternacional.ui.adapters.events.EventListAdapter;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;


public class EventListFragment extends Fragment implements EventListPresenter.IEventListView {

    private static final String ARG_PARAM1 = "events";
    private static final String ARG_PARAM2 = "showOnlyRegistered";

    @BindView(R.id.recyclerview_events)
    RecyclerView recyclerviewEvents;
    @BindView(R.id.textview_empty)
    TextView textviewEmpty;

    private EventListPresenter mPresenter;
    private ArrayList<Event> events;
    private boolean showOnlyRegistered;


    public EventListFragment() {
        // Required empty public constructor
    }

    public static EventListFragment newInstance(ArrayList<Event> events, boolean showOnlyRegistered) {
        EventListFragment fragment = new EventListFragment();
        Bundle args = new Bundle();
        args.putParcelableArrayList(ARG_PARAM1, events);
        args.putBoolean(ARG_PARAM2, showOnlyRegistered);
        fragment.setArguments(args);
        return fragment;
    }

    //region Android Lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            events = getArguments().getParcelableArrayList(ARG_PARAM1);
            showOnlyRegistered  = getArguments().getBoolean(ARG_PARAM2);
        }
        mPresenter = new EventListPresenter(this,events, showOnlyRegistered);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_event_list, container, false);
        ButterKnife.bind(this, view);

        if(mPresenter != null)
            mPresenter.start();
        return view;
    }
    //endregion

    //region IEventListView
    @Override
    public void setPresenter(EventListPresenter presenter) {
        this.mPresenter = presenter;
    }

    @Override
    public void setupRecyclerView(ArrayList<Event> mEvents) {
        recyclerviewEvents.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false));
        recyclerviewEvents.setHasFixedSize(true);

        EventListAdapter adapter = new EventListAdapter(events,getContext());
        recyclerviewEvents.setAdapter(adapter);

        recyclerviewEvents.addOnItemTouchListener(new RecyclerItemClickListener(getContext(), recyclerviewEvents, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                mPresenter.onEventTouched(position);
            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));
    }

    @Override
    public void navigateToEventDetailsActivity(Event event, boolean showOnlyRegistered) {
        Intent intent = new Intent(getActivity(), EventDetailActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_EVENT, event);
        intent.putExtra(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED, showOnlyRegistered);
        startActivity(intent);
    }

    @Override
    public void showEmptyListText() {
        recyclerviewEvents.setVisibility(View.GONE);
        textviewEmpty.setVisibility(View.VISIBLE);
    }
    @Override
    public void setColorViews() {
        textviewEmpty.setTextColor(Color.parseColor(UserUtils.getBackgroundColor(getContext())));
    }

    //endregion

}
