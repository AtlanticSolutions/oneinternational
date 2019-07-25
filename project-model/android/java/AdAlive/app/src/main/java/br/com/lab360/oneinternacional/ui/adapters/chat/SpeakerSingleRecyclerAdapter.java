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
import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatUser;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.Event;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.ChatEnterEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.SingleChatBlockEvent;
import br.com.lab360.oneinternacional.ui.viewholder.chat.ChatSingleViewHolder;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class SpeakerSingleRecyclerAdapter extends RecyclerView.Adapter<ChatSingleViewHolder> {
    private final Context context;
    private List<ChatUser> items;

    public SpeakerSingleRecyclerAdapter(Context context) {
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
        ChatUser item = items.get(position);

        holder.setTitle(item.getFirstName());

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
                AdaliveApplication.getBus().publish(RxQueues.CHAT_ENTER_BTN_EVENT, new ChatEnterEvent(position, false, true));
            }
        });

        holder.getBtnBlock().setVisibility(View.GONE);
        holder.setImageButtonColor(context, android.R.color.holo_red_dark);

    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(ChatUser object) {
        if (object == null)
            object = new ChatUser();

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

    public void replaceAll(ArrayList<ChatUser> mItems) {
        this.items.clear();
        this.items.addAll(mItems);
        notifyDataSetChanged();
    }
}