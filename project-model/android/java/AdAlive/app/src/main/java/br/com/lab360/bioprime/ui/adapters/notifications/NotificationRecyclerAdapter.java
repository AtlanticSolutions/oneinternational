package br.com.lab360.bioprime.ui.adapters.notifications;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.common.base.Strings;
import com.simplecityapps.recyclerview_fastscroll.views.FastScrollRecyclerView;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.bioprime.ui.viewholder.notifications.NotificationViewHolder;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class NotificationRecyclerAdapter extends RecyclerView.Adapter<NotificationViewHolder> implements FastScrollRecyclerView.SectionedAdapter {
    private final Context context;
    private List<NotificationObject> items;

    public NotificationRecyclerAdapter(Context context, List<NotificationObject> items) {
        this.items = items;
        this.context = context;
    }

    public NotificationRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public NotificationViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_notifications_item, parent, false);
        return new NotificationViewHolder(v);
    }

    @Override
    public void onBindViewHolder(NotificationViewHolder holder, int position) {
        NotificationObject item = items.get(position);

        holder.setTitle(item.getMessage());

        if (!Strings.isNullOrEmpty(item.getInfo())){
            holder.getIvArrowRight().setVisibility(View.VISIBLE);
        } else {
            holder.getIvArrowRight().setVisibility(View.GONE);
        }

        //ivArrowRight

    }


    @Override
    public void onViewRecycled(NotificationViewHolder holder) {
        super.onViewRecycled(holder);
//        holder.recycle();
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }



    @NonNull
    @Override
    public String getSectionName(int position) {
        return String.valueOf(items.get(position).getMessage().charAt(0));
    }

    public void replaceAll(List<NotificationObject> list) {
        this.items.clear();
        this.items.addAll(list);
        notifyDataSetChanged();
    }
}