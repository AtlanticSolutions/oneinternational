package br.com.lab360.bioprime.ui.adapters;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.ui.viewholder.CategoryViewHolder;

/**
 * Created by Edson on 25/04/2018.
 */

public class CategoryRecyclerAdapter extends RecyclerView.Adapter<CategoryViewHolder> {

    private List<Category> categories;
    private Context context;
    private OnCategoryClicked listener;
    public CategoryRecyclerAdapter(List<Category> categories, Context context, OnCategoryClicked listener) {
        this.categories = categories;
        this.context = context;
        this.listener = listener;
    }

    @Override
    public CategoryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_category_item, parent, false);
        return new CategoryViewHolder(v);
    }

    @Override
    public void onBindViewHolder(final CategoryViewHolder holder, final int position) {
        final Category category = categories.get(position);

        holder.setTitle(category.getName());
        holder.setThumb(category.getImageUrl(), context);
        holder.getItemView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onItemClick(category);
            }
        });
    }

    @Override
    public int getItemCount() {
        return categories.size();
    }

    public Category getCategory(int position) {
        return categories.get(position);
    }

    public interface OnCategoryClicked {
        void onItemClick(Category category);
    }
}

