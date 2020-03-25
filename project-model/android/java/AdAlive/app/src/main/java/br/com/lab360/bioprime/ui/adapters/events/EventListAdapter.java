package br.com.lab360.bioprime.ui.adapters.events;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.DecelerateInterpolator;
import android.widget.ImageView;
import android.widget.TextView;
import com.google.common.base.Strings;

import java.util.List;
import java.util.Locale;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.utils.DateUtils;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;

/**
 * Events list adapter.
 * Created by Victor Santiago on 14/10/2016.
 */
public class EventListAdapter extends RecyclerView.Adapter<EventListAdapter.ViewHolder> {

    private List<Event> events;
    private Context context;
    private int lastAnimatedPosition = -1;


    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView textViewTitle, textViewDateHour;
        ImageView ivFavorited;

        ViewHolder(View v) {
            super(v);
            textViewTitle = (TextView) v.findViewById(R.id.tvTitle);
            textViewDateHour = (TextView) v.findViewById(R.id.tvDateTime);
            ivFavorited = (ImageView) v.findViewById(R.id.ivFavorited);
        }
    }

    public EventListAdapter(List<Event> events, Context context) {
        this.events = events;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent,
                                         int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_event_list_item, parent, false);
        return new ViewHolder(v);
    }

    // Replace the contents of a view (invoked by the layout manager)
    @Override
    public void onBindViewHolder(final ViewHolder holder, final int position) {

        runEnterAnimation(holder.itemView, position);

        Event event = events.get(position);

        String formatedDateHour;
        String hour = DateUtils.formatAdAliveDate(event.getSchedule(), "HH:mm");
        String language = Locale.getDefault().getDisplayLanguage();

        if (language.contains("português")) {

            formatedDateHour = DateUtils.formatAdAliveDate(event.getSchedule(), "dd/MM/yy") +
                    " às " + hour;

        } else {

            formatedDateHour = DateUtils.formatAdAliveDate(event.getSchedule(), "MM/dd/yy") +
                    " at " + hour;

        }

        holder.textViewDateHour.setText(formatedDateHour);

        holder.textViewTitle.setText(event.getName());

        if (event.isRegistered()) {
            holder.ivFavorited.setImageResource(R.drawable.ic_done);
        } else {
            holder.ivFavorited.setImageResource(R.drawable.ic_pencil);
        }

        String topColor = UserUtils.getBackgroundColor(context);

        if (!Strings.isNullOrEmpty(topColor)) {
            holder.ivFavorited.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
        }

    }

    @Override
    public int getItemCount() {
        return events.size();
    }


    public void updateItem(int updatedIndex,Event updateEvent) {
        this.events.set(updatedIndex,updateEvent);
        notifyItemChanged(updatedIndex);
    }

    public void remove(int updatedIndex) {
        this.events.remove(updatedIndex);
        notifyItemRemoved(updatedIndex);
    }

    public void add(Event updateEvent) {
        events.add(updateEvent);
        notifyItemInserted(events.size()-1);
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

}
