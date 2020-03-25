package br.com.lab360.bioprime.ui.adapters;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategory;
import br.com.lab360.bioprime.ui.viewholder.SubCategoryViewHolder;


/**
 * Created by Edson on 26/04/2018.
 */

public class SubCategoryRecyclerAdapter extends RecyclerView.Adapter<SubCategoryViewHolder> {

    private List<SubCategory> subCategories;
    private Context context;
    private OnSubCategoryClicked listener;

    public SubCategoryRecyclerAdapter(List<SubCategory> subCategories, Context context, OnSubCategoryClicked listener) {
        this.subCategories = subCategories;
        this.context = context;
        this.listener = listener;
    }

    @Override
    public SubCategoryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_subcategory_item, parent, false);
        return new SubCategoryViewHolder(v);
    }

    @Override
    public void onBindViewHolder(final SubCategoryViewHolder holder, final int position) {
        final SubCategory subCategory = subCategories.get(position);

        holder.setTitle(subCategory.getName());
        holder.setThumb(subCategory.getImageUrl(), context);
        holder.getItemView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onItemClick(subCategory);
            }
        });
    }

    @Override
    public int getItemCount() {
        return subCategories.size();
    }

    public SubCategory getSubCategory(int position) {
        return subCategories.get(position);
    }

    public interface OnSubCategoryClicked {
        void onItemClick(SubCategory subCategory);
    }
}
