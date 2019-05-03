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
import br.com.lab360.oneinternacional.ui.viewholder.menu.ChildMenuItemViewHolder;
import br.com.lab360.oneinternacional.utils.UserUtils;

/**
 * Created by Edson on 13/06/2018.
 */

public class ChildMenuRecyclerAdapter extends RecyclerView.Adapter<ChildMenuItemViewHolder> {

    private List<MenuItem> menus;
    private Context context;
    private OnChildMenuClicked listener;

    public ChildMenuRecyclerAdapter(List<MenuItem> menus, Context context, OnChildMenuClicked listener) {
        this.menus = menus;
        this.context = context;
        this.listener = listener;
    }

    @Override
    public ChildMenuItemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_menu_sub_item, parent, false);
        return new ChildMenuItemViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull final ChildMenuItemViewHolder holder, int position) {

        final MenuItem menu = menus.get(position);
        holder.setMenuTitle(menu.getName());

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
        holder.getllChildMenuItem().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (holder.getRvSubMenu().getVisibility() == View.GONE) {
                    holder.getIvArrow().setImageResource(R.drawable.ic_arrow_up);
                    holder.getRvSubMenu().setVisibility(View.VISIBLE);

                } else {
                    holder.getIvArrow().setImageResource(R.drawable.ic_arrow_down);
                    holder.getRvSubMenu().setVisibility(View.GONE);
                }
                listener.onChildMenuClick(menu, holder.getRvSubMenu(), holder.getIvArrow());
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
            holder.setChildMenuItemImage(context,menu.getIconUrl());
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

    public interface OnChildMenuClicked {
        void onChildMenuClick(MenuItem menu, RecyclerView rvSubMenu, ImageView ivArrow);
        void onChildofChildMenuClick(MenuItem menu, RecyclerView rvSubMenu);
    }

}