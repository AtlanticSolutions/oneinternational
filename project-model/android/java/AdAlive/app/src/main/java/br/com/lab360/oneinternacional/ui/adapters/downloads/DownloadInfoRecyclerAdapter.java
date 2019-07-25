package br.com.lab360.oneinternacional.ui.adapters.downloads;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import androidx.core.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.daimajia.swipe.adapters.RecyclerSwipeAdapter;
import java.util.ArrayList;
import java.util.List;
import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.ui.viewholder.downloads.DownloadInfoViewHolder;
import br.com.lab360.oneinternacional.utils.DownloadUtils;


/**
 * Created by Alessandro Valenza on 26/10/2016.
 */
public class DownloadInfoRecyclerAdapter extends RecyclerSwipeAdapter<DownloadInfoViewHolder> {
    private final Context context;
    private List<DownloadInfoObject> items;



    public DownloadInfoRecyclerAdapter(List<DownloadInfoObject> items, Context context) {
        this.items = items;
        this.context = context;
    }

    public DownloadInfoRecyclerAdapter(Context context) {
        this.items = new ArrayList<>();
        this.context = context;
    }

    @Override
    public DownloadInfoViewHolder onCreateViewHolder(ViewGroup parent,
                                                     int viewType) {
        View v = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.recycler_download_document_item, parent, false);
        return new DownloadInfoViewHolder(v);
    }

    @Override
    public void onBindViewHolder(DownloadInfoViewHolder holder, final int position) {
        DownloadInfoObject item = items.get(position);

        holder.setFileName(item.getTitle());
        holder.setAuthor(item.getAuthor());
        holder.setCompany(item.getDescription());

        if(DownloadUtils.alreadyDownloadedFile(context,item)){
            Drawable icon = ContextCompat.getDrawable(context, R.drawable.ic_download);
            icon.setColorFilter(new PorterDuffColorFilter(ContextCompat.getColor(context, R.color.green), PorterDuff.Mode.MULTIPLY));
            holder.setIconDrawable(icon);
        }
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
}