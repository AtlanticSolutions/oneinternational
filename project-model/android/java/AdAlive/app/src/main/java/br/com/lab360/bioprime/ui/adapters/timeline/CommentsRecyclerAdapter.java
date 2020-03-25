package br.com.lab360.bioprime.ui.adapters.timeline;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CommentObject;
import br.com.lab360.bioprime.ui.viewholder.timeline.CommentsViewHolder;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */
public class CommentsRecyclerAdapter extends RecyclerView.Adapter<CommentsViewHolder> {
    private final Context context;
    private List<CommentObject> items;

    public CommentsRecyclerAdapter(Context context, List<CommentObject> items) {
        this.items = items;
        this.context = context;
    }

    @Override
    public CommentsViewHolder onCreateViewHolder(ViewGroup parent,
                                                int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_timeline_comment_item, parent, false);
        return new CommentsViewHolder(v);
    }

    @Override
    public void onBindViewHolder(CommentsViewHolder holder, int position) {
        CommentObject item = items.get(position);
        holder.setPostOwnerName(item.getUser().getName());
        String date = item.getCreatedAt();
        holder.setPostDate(date.substring(0,date.lastIndexOf(":")+3));
        holder.setMessage(item.getMessage());
        Glide.with(context).load(item.getUser().getImageUrl()).into(holder.getCommentProfilePhoto());
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }

    public void add(CommentObject object) {
        if (object == null)
            object = new CommentObject();

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

    public void remove(CommentObject object) {
        if (object == null)
            return;

        int pos = items.indexOf(object);
        items.remove(pos);
        notifyItemRemoved(pos);
    }

    public void replaceAll(ArrayList<CommentObject> comments) {
        this.items.clear();
        this.items.addAll(comments);
        notifyDataSetChanged();
    }
}