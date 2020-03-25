package br.com.lab360.bioprime.ui.adapters.chat;

import android.content.Context;
import androidx.annotation.IntDef;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.lang.annotation.Retention;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.model.pojo.chat.EventMessage;
import br.com.lab360.bioprime.ui.viewholder.chat.ChatUserViewHolder;

import static br.com.lab360.bioprime.ui.adapters.chat.ChatMessagesRecyclerAdapter.ChatType.ME;
import static br.com.lab360.bioprime.ui.adapters.chat.ChatMessagesRecyclerAdapter.ChatType.SECTION;
import static br.com.lab360.bioprime.ui.adapters.chat.ChatMessagesRecyclerAdapter.ChatType.USER;
import static java.lang.annotation.RetentionPolicy.SOURCE;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatMessagesRecyclerAdapter extends RecyclerView.Adapter<ChatUserViewHolder> {
    private final Context context;
    private List<EventMessage> items;

    public ChatMessagesRecyclerAdapter(Context context, List<EventMessage> items) {
        this.items = items;
        this.context = context;
    }

    public ChatMessagesRecyclerAdapter(Context context) {
        this.context = context;
        this.items = new ArrayList<>();
    }

    @Override
    public ChatUserViewHolder onCreateViewHolder(ViewGroup viewGroup, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
        View v;
        switch (viewType) {
            case ME:
                v = inflater.inflate(R.layout.recycler_chat_current_user_item, viewGroup, false);
                break;
            case USER:
                v = inflater.inflate(R.layout.recycler_chat_another_user_item, viewGroup, false);
                break;
            case SECTION:
                v = inflater.inflate(R.layout.recycler_chat_section_item, viewGroup, false);
                break;
            default:
                v = inflater.inflate(R.layout.recycler_chat_another_user_item, viewGroup, false);
        }

        return new ChatUserViewHolder(v);
    }

    @Override
    public void onBindViewHolder(ChatUserViewHolder holder, int position) {
        EventMessage item = items.get(position);
        holder.setName(item.getSenderName());

        holder.setMessage(item.getMessage());

        holder.hideDate();
        holder.hideProgress();
        holder.hideWarning();

        String dateStr = item.getDate();
        if(TextUtils.isEmpty(dateStr)){
            dateStr = item.getSendDateMilli();
        }

        if (!TextUtils.isEmpty(dateStr)) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.getDefault());
                Date date = sdf.parse(dateStr);
                sdf = new SimpleDateFormat("HH:mm", Locale.getDefault());
                holder.setDate(sdf.format(date));
                holder.showDate();
            } catch (ParseException e) {
                e.printStackTrace();
            }
            return;
        }

        if(item.hasError()) {
            holder.showWarning();
            return;
        }

        holder.showProgress();
    }

    //Returns the view type of the item at position for the purposes of view recycling.
    @Override
    public int getItemViewType(int position) {
        int userId = AdaliveApplication.getInstance().getUser().getId();
        EventMessage item = items.get(position);
        if (item.getId() == userId || item.getSenderId() == userId) {
            return ME;
        } else if (item.isSection()) {
            return SECTION;
        }else {
            return USER;
        }
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(EventMessage object) {
        if (object == null)
            object = new EventMessage();

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

    public void remove(EventMessage object) {
        if (object == null)
            return;

        int pos = items.indexOf(object);
        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void replaceAll(ArrayList<EventMessage> mItems) {
        items.clear();
        items.addAll(mItems);
        notifyDataSetChanged();
    }

    public void setError(int position) {
        items.get(position).setError(true);
        notifyItemChanged(position);
    }

    public boolean itemHasError(int position) {
        return items.get(position).hasError();
    }

    public String getItemMessage(int position) {
        return items.get(position).getMessage();
    }

    public void updateMessage(int position, EventMessage messageSent) {
        items.set(position, messageSent);
        notifyItemChanged(position);
    }

    @Retention(SOURCE)
    @IntDef({ChatType.ME, ChatType.USER, ChatType.SECTION})
    protected @interface ChatType {
        int ME = 1;
        int USER = 2;
        int SECTION = 3;
    }
}