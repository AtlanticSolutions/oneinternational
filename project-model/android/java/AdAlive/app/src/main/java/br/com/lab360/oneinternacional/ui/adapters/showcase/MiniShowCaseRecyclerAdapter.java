package br.com.lab360.oneinternacional.ui.adapters.showcase;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.showcase.ShowCaseProduct;
import br.com.lab360.oneinternacional.ui.viewholder.showcase.MiniShowCaseViewHolder;

/**
 * Created by Edson on 07/05/2018.
 */

public class MiniShowCaseRecyclerAdapter extends RecyclerView.Adapter<MiniShowCaseViewHolder> {

    private final Context context;
    private List<ShowCaseProduct> items;
    private OnMiniClicked listener;

    public MiniShowCaseRecyclerAdapter(List<ShowCaseProduct> items, Context context, OnMiniClicked listener) {
        this.items = items;
        this.context = context;
        this.listener = listener;
    }

    public MiniShowCaseRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public MiniShowCaseViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_showcase_mini_item, parent, false);
        return new MiniShowCaseViewHolder(v);
    }

    @Override
    public void onBindViewHolder(final MiniShowCaseViewHolder holder, int position) {
        holder.setShowcase(items.get(position).pictureURL, context);
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onItemClick(items.get(holder.getAdapterPosition()));
            }
        });
    }

    @Override
    public void onViewRecycled(MiniShowCaseViewHolder holder) {
        super.onViewRecycled(holder);
    }

    @Override
    public int getItemCount() {
        return items == null ? 0 : items.size();
    }

    public interface OnMiniClicked {
        void onItemClick(ShowCaseProduct showCaseProduct);
    }
}