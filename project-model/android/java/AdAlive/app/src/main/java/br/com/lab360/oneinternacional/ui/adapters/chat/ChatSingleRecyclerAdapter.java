package br.com.lab360.oneinternacional.ui.adapters.chat;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.Event;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.SingleChatUser;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.ChatEnterEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.SingleChatBlockEvent;
import br.com.lab360.oneinternacional.ui.viewholder.chat.ChatSingleViewHolder;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatSingleRecyclerAdapter extends RecyclerView.Adapter<ChatSingleViewHolder> {
    private final Context context;
    private List<SingleChatUser> items;

    public ChatSingleRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public ChatSingleViewHolder onCreateViewHolder(ViewGroup parent,
                                                   int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_chat_single_item, parent, false);
        return new ChatSingleViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ChatSingleViewHolder holder, final int position) {
        SingleChatUser item = items.get(position);

        holder.setTitle(item.getName());

        holder.setCity(item.getCity());
        holder.setEmail(item.getJobRole());

        holder.setBtnBlockClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AdaliveApplication.getBus().publish(RxQueues.SINGLE_CHAT_BLOCK_BTN_EVENT, new SingleChatBlockEvent(position));
            }
        });

        holder.setBtnTitleClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AdaliveApplication.getBus().publish(RxQueues.CHAT_ENTER_BTN_EVENT, new ChatEnterEvent(position, false, false));
            }
        });

        if (item.getUnRead() > 0) {
            holder.getTvTotalMessages().setVisibility(View.VISIBLE);
            holder.setTotalMessages(item.getUnRead());
        } else {
            holder.getTvTotalMessages().setVisibility(View.INVISIBLE);
        }

        if (item.getStatus().equals(SingleChatUser.UserStatus.ACTIVE)) {
            holder.setImageButtonColor(context, R.color.dark_gray);
            return;
        }
        holder.setImageButtonColor(context, android.R.color.holo_red_dark);

    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(SingleChatUser object) {
        if (object == null)
            object = new SingleChatUser();

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

    public void replaceAll(ArrayList<SingleChatUser> mItems) {
        this.items.clear();
        this.items.addAll(mItems);
        notifyDataSetChanged();
    }
}