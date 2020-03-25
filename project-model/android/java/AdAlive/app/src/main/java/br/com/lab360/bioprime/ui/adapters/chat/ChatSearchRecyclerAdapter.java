package br.com.lab360.bioprime.ui.adapters.chat;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.simplecityapps.recyclerview_fastscroll.views.FastScrollRecyclerView;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;
import br.com.lab360.bioprime.ui.viewholder.chat.ChatSearchViewHolder;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class ChatSearchRecyclerAdapter extends RecyclerView.Adapter<ChatSearchViewHolder> implements FastScrollRecyclerView.SectionedAdapter {
    private final Context context;
    private List<BaseObject> items;

    public ChatSearchRecyclerAdapter(Context context, List<BaseObject> items) {
        this.items = items;
        this.context = context;
    }

    public ChatSearchRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public ChatSearchViewHolder onCreateViewHolder(ViewGroup parent,
                                                   int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_chat_search_item, parent, false);
        return new ChatSearchViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ChatSearchViewHolder holder, int position) {
        BaseObject item = items.get(position);

        holder.setTitle(item.getName());

        holder.setRole(item.getCargo());
        holder.setCity(String.format("%s %s", item.getCidade(), item.getEstado()));

        if (item.isSelected()) {
            holder.toggleSelected();
        }
    }

    /**
     * Called when a view created by this adapter has been recycled.
     * <p>
     * <p>A view is recycled when a {@link LayoutManager} decides that it no longer
     * needs to be attached to its parent {@link RecyclerView}. This can be because it has
     * fallen out of visibility or a set of cached views represented by views still
     * attached to the parent RecyclerView. If an item view has large or expensive data
     * bound to it such as large bitmaps, this may be a good place to release those
     * resources.</p>
     * <p>
     * RecyclerView calls this method right before clearing ViewHolder's internal data and
     * sending it to RecycledViewPool. This way, if ViewHolder was holding valid information
     * before being recycled, you can call {@link ViewHolder#getAdapterPosition()} to get
     * its adapter position.
     *
     * @param holder The ViewHolder for the view being recycled
     */
    @Override
    public void onViewRecycled(ChatSearchViewHolder holder) {
        super.onViewRecycled(holder);
        holder.recycle();
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
        return String.valueOf(items.get(position).getName().charAt(0));
    }

    public void replaceAll(List<BaseObject> list) {
        this.items.clear();
        this.items.addAll(list);
        notifyDataSetChanged();
    }
}