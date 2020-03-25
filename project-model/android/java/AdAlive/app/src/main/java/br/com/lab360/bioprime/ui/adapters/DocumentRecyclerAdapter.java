package br.com.lab360.bioprime.ui.adapters;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.ui.viewholder.DocumentViewHolder;

/**
 * Created by Edson on 27/04/2018.
 */

public class DocumentRecyclerAdapter extends RecyclerView.Adapter<DocumentViewHolder> {
    private final Context context;
    private List<DownloadInfoObject> items;
    private OnDocumentClicked listener;

    public DocumentRecyclerAdapter(List<DownloadInfoObject> items, Context context, OnDocumentClicked listener) {
        this.items = items;
        this.context = context;
        this.listener = listener;
    }

    public DocumentRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public DocumentViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_document_item, parent, false);
        return new DocumentViewHolder(v);
    }

    @Override
    public void onBindViewHolder(DocumentViewHolder holder, final int position) {
        final DownloadInfoObject item = items.get(position);

        holder.setTitle(item.getTitle());
        holder.setThumb(item.getUrlImage(), context);
        holder.getItemView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onItemClick(item);
            }
        });
    }

    public interface OnDocumentClicked {
        void onItemClick(DownloadInfoObject document);
    }

    @Override
    public int getItemCount() {
        if (items == null) {
            return 0;
        }
        return items.size();
    }


    public DownloadInfoObject getDocument(int position) {
        return items.get(position);
    }
    public void replaceAll(ArrayList<DownloadInfoObject> files) {
        items.clear();
        items.addAll(files);
        notifyDataSetChanged();
    }
}
