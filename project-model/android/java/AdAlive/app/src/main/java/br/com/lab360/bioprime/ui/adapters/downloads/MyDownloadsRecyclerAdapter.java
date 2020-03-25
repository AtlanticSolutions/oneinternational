
package br.com.lab360.bioprime.ui.adapters.downloads;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.daimajia.swipe.adapters.RecyclerSwipeAdapter;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.listeners.OnBtnDeleteTouchListener;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.bioprime.ui.viewholder.downloads.MyDownloadInfoViewHolder;


/**
 * Created by Alessandro Valenza on 26/10/2016.
 */
public class MyDownloadsRecyclerAdapter extends RecyclerSwipeAdapter<MyDownloadInfoViewHolder> {

    private final Context context;
    private List<DownloadInfoObject> items;

    private OnBtnDeleteTouchListener listener;

    public MyDownloadsRecyclerAdapter(List<DownloadInfoObject> items, Context context, OnBtnDeleteTouchListener listener) {
        this.items = items;
        this.context = context;
        this.listener = listener;
    }

    public MyDownloadsRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public MyDownloadInfoViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_my_download_document_item, parent, false);
        return new MyDownloadInfoViewHolder(v);
    }

    @Override
    public void onBindViewHolder(MyDownloadInfoViewHolder holder, final int position) {
        DownloadInfoObject item = items.get(position);

        holder.setFileName(item.getTitle());
        holder.setAuthor(item.getAuthor());
        holder.setCompany(item.getDescription());

        holder.getImgDelete().setOnClickListener (new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.onBtnDeleteTouched(position);
            }
        });

        holder.getBtnOpen().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                listener.onBtnOpenFileTouched(position);
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

    @Override
    public int getSwipeLayoutResourceId(int position) {
        return R.id.swipe;
    }

    public void replaceAll(ArrayList<DownloadInfoObject> files) {
        items.clear();
        items.addAll(files);
        notifyDataSetChanged();
    }

    public void remove(int position) {
        items.remove(position);
        notifyDataSetChanged();
    }
}