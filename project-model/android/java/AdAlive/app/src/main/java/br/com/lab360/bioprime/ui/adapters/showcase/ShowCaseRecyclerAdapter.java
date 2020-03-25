package br.com.lab360.bioprime.ui.adapters.showcase;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseCategory;
import br.com.lab360.bioprime.ui.viewholder.showcase.ShowCaseViewHolder;

/**
 * Created by Edson on 07/05/2018.
 */

public class ShowCaseRecyclerAdapter extends RecyclerView.Adapter<ShowCaseViewHolder> {
    private final Context context;
    private List<ShowCaseCategory> items;

    public ShowCaseRecyclerAdapter( List<ShowCaseCategory> items, Context context) {
        this.items = items;
        this.context = context;
    }

    public ShowCaseRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public ShowCaseViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_showcase_item, parent, false);
        return new ShowCaseViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ShowCaseViewHolder holder, int position) {
        ShowCaseCategory item = items.get(position);
        holder.setCategory(item.name);
        holder.setIvCategory(item.pictureURL, context);
    }


    @Override
    public void onViewRecycled(ShowCaseViewHolder holder) {
        super.onViewRecycled(holder);
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }
}