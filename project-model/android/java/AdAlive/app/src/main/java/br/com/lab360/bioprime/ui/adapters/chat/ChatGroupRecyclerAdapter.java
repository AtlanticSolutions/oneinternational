package br.com.lab360.bioprime.ui.adapters.chat;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;
import br.com.lab360.bioprime.logic.model.pojo.chat.Event;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.ChatEnterEvent;
import br.com.lab360.bioprime.logic.rxbus.events.ChatExitEvent;
import br.com.lab360.bioprime.ui.viewholder.chat.ChatGroupViewHolder;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatGroupRecyclerAdapter extends RecyclerView.Adapter<ChatGroupViewHolder> {
    private final Context context;
    private List<BaseObject> items;

    public ChatGroupRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public ChatGroupViewHolder onCreateViewHolder(ViewGroup parent,
                                                  int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_chat_group_item, parent, false);
        return new ChatGroupViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ChatGroupViewHolder holder, final int position) {
        BaseObject item = items.get(position);

        /* Remove exit button on reseller role */
        if (AdaliveApplication.getInstance().getUser().getRole().equals("reseller")){
            holder.getBtnExit().setVisibility(View.GONE);
            holder.getBtnExit().setOnClickListener(null);
        } else {
            holder.setBtnExitClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    AdaliveApplication.getBus().publish(RxQueues.CHAT_EXIT_BTN_EVENT, new ChatExitEvent(position,true));
                }
            });
        }

        holder.setTitle(item.getName());

        holder.setBtnTitleClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AdaliveApplication.getBus().publish(RxQueues.CHAT_ENTER_BTN_EVENT, new ChatEnterEvent(position,true, false));
            }
        });
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(BaseObject object) {
        if (object == null)
            object = new BaseObject();

        items.add(object);
        int pos = items.indexOf(object);
        notifyItemInserted(pos);
    }

    public void remove(int pos) {
        if (pos > items.size() - 1)
            return;

        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void remove(Event object) {
        if (object == null)
            return;

        int pos = items.indexOf(object);
        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void replaceAll(List<BaseObject> mItems) {
        this.items.clear();
        this.items.addAll(mItems);
        notifyDataSetChanged();
    }
}