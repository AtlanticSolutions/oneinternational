package br.com.lab360.oneinternacional.ui.adapters.menu;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.menu.MenuItem;
import br.com.lab360.oneinternacional.ui.viewholder.menu.ParentMenuItemViewHolder;
import br.com.lab360.oneinternacional.utils.UserUtils;

/**
 * Created by Edson on 07/06/2018.
 */

public class ParentMenuRecyclerAdapter extends RecyclerView.Adapter<ParentMenuItemViewHolder> {
    private List<MenuItem> menus;
    private Context context;
    private OnParentMenuClicked listener;

    public ParentMenuRecyclerAdapter(List<MenuItem> menus, Context context, OnParentMenuClicked listener) {
        this.menus = menus;
        this.context = context;
        this.listener = listener;
    }

    @Override
    public ParentMenuItemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_menu_item, parent, false);
        return new ParentMenuItemViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull final ParentMenuItemViewHolder holder, int position) {
        final MenuItem menu = menus.get(position);
        holder.setMenuTitle(context,menu.getName(), menu.getIdentifier());

        if (menu.getMenuItems() != null && menu.getMenuItems().size() != 0) {
            holder.isArrowVisible(true);
            holder.getIvArrow().setImageResource(R.drawable.ic_arrow_down);
            holder.getRvSubMenu().setVisibility(View.GONE);

        } else {
            holder.isArrowVisible(false);
        }

        if (holder.getRvSubMenu().getVisibility() != View.GONE) {
            holder.getIvArrow().setImageResource(R.drawable.ic_arrow_up);

        } else {

            holder.getIvArrow().setImageResource(R.drawable.ic_arrow_down);
        }

        holder.getllMenuItem().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (holder.getRvSubMenu().getVisibility() == View.GONE) {
                    holder.getIvArrow().setImageResource(R.drawable.ic_arrow_up);
                    holder.getRvSubMenu().setVisibility(View.VISIBLE);

                } else {
                    holder.getIvArrow().setImageResource(R.drawable.ic_arrow_down);
                    holder.getRvSubMenu().setVisibility(View.GONE);
                }
                listener.onParentMenuClick(menu, holder.getRvSubMenu(), holder.getIvArrow());
            }
        });

        if (menu.getBadge() != 0) {
            holder.isBadgeVisible(true);
            holder.setBadgeCount(menu.getBadge());
        } else {
            holder.isBadgeVisible(false);
        }

        if (menu.getFeaturedMessage() != null && !menu.getFeaturedMessage().equals("")) {
            holder.isFeaturedMessageVisible(true);
            holder.setFeaturedMessage(menu.getFeaturedMessage());
            holder.setFeaturedMessageColor(UserUtils.getBackgroundColor(context));
        } else {
            holder.isFeaturedMessageVisible(false);
        }

        if (menu.getIconUrl() != null && !menu.getIconUrl().equals("")) {
            holder.setMenuItemImage(context,menu.getIconUrl());
        } else {
        }
    }

    @Override
    public int getItemCount() {
        return menus.size();
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }

    public interface OnParentMenuClicked {
        void onParentMenuClick(MenuItem menu, RecyclerView rvSubMenu, ImageView ivArrow);
    }
}