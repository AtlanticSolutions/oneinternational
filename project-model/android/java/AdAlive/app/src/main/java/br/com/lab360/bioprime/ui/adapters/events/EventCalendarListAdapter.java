package br.com.lab360.bioprime.ui.adapters.events;

import android.content.Context;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.utils.DateUtils;
import br.com.lab360.bioprime.utils.ScreenUtils;

/**
 * Events calendar list adapter.
 * Created by Victor Santiago on 19/10/2016.
 */
public class EventCalendarListAdapter extends RecyclerView.Adapter<EventCalendarListAdapter.ViewHolder> {

    private List<Event> events;
    private Context context;

    private int lastAnimatedPosition = -1;


    public class ViewHolder extends RecyclerView.ViewHolder {
        // each data item is just a string in this case
        View viewStatus;
        TextView textViewTitle, textViewInitialHour, textViewFinalHour, textViewRegister;

        ViewHolder(View v) {
            super(v);
            viewStatus = v.findViewById(R.id.view_status);
            textViewTitle = (TextView) v.findViewById(R.id.textview_title_event);
            textViewInitialHour = (TextView) v.findViewById(R.id.textview_initial_hour_event);
            textViewFinalHour = (TextView) v.findViewById(R.id.textview_final_hour_event);
            textViewRegister = (TextView) v.findViewById(R.id.textview_sing);
        }
    }

    // Provide a suitable constructor (depends on the kind of dataset)
    public EventCalendarListAdapter(List<Event> events, Context context) {
        this.events = events;
        this.context = context;
    }

    // Create new views (invoked by the layout manager)
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent,
                                         int viewType) {
        // create a new view
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_calendar_event_list_item, parent, false);
        // set the view's size, margins, paddings and layout parameters
        return new ViewHolder(v);
    }

    // Replace the contents of a view (invoked by the layout manager)
    @Override
    public void onBindViewHolder(final ViewHolder holder, final int position) {
        runEnterAnimation(holder.itemView, position);

        Event event = events.get(position);

        String initialHour = DateUtils.formatAdAliveDate(event.getSchedule(), "HH:mm");
        holder.textViewInitialHour.setText(initialHour.equals("") ? "00:00" : initialHour);
        //TODO: Set Final hour
        //holder.textViewFinalHour.setText(finalHour.equals("") ? "00:00" : finalHour);

        holder.textViewFinalHour.setVisibility(View.GONE);

        holder.textViewTitle.setText(event.getName());

        if (event.isRegistered()) {
            holder.viewStatus.setBackgroundColor(ContextCompat.getColor(context, R.color.green));
            holder.textViewRegister.setText(context.getString(R.string.LABEL_REGISTERED));
        } else {
            holder.viewStatus.setBackgroundColor(ContextCompat.getColor(context, R.color.graySignUpCalendar));
            holder.textViewRegister.setText(context.getString(R.string.LABEL_SIGNUP));
        }

        holder.textViewRegister.setVisibility(View.GONE);
    }

    // Return the size of your dataset (invoked by the layout manager)
    @Override
    public int getItemCount() {
        return events.size();
    }

    public void add(Event event, int position) {
        events.add(position, event);
        notifyItemInserted(position);
    }

    private void runEnterAnimation(View view, int position) {

        if (position > lastAnimatedPosition) {
            lastAnimatedPosition = position;
            view.setTranslationY(ScreenUtils.getScreenHeight(context));
            view.animate()
                    .translationY(0)
                    .setInterpolator(new DecelerateInterpolator(3.f))
                    .setDuration(700)
                    .start();
        }
    }

    public void addAll(ArrayList<Event> eventsBySelectedDate) {
        events.clear();
        events.addAll(eventsBySelectedDate);
        notifyDataSetChanged();
    }
}
