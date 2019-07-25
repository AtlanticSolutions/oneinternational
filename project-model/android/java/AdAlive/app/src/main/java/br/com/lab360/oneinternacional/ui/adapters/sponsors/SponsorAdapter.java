package br.com.lab360.oneinternacional.ui.adapters.sponsors;

import android.content.Context;
import android.graphics.Color;

import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.target.Target;
import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.ui.activity.sponsors.SectionOrRow;
import br.com.lab360.oneinternacional.utils.UserUtils;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private List<SectionOrRow> mSponsors;
    private Context context;

    public SponsorAdapter(Context context, List<SectionOrRow> sponsors) {
        this.context = context;
        this.mSponsors = sponsors;
    }


    public class ViewHolder extends RecyclerView.ViewHolder {
        ImageView ivSponsor;
        ProgressBar progressBar;

        ViewHolder(View v) {
            super(v);
            progressBar = (ProgressBar) v.findViewById(R.id.progress);
            ivSponsor = (ImageView) v.findViewById(R.id.iv_sponsor);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

        if(viewType == 0) {

            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_grid_sponsor_section, parent, false);
            return new SectionViewHolder(v);

        } else {

            View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recyclerview_grid_sponsor_item, parent, false);
             return new ViewHolder(v);
        }
    }

    @Override
    public void onBindViewHolder(final RecyclerView.ViewHolder holder, int position) {

        SectionOrRow item = mSponsors.get(position);

        if (!item.isRow()){

            SectionViewHolder h = (SectionViewHolder) holder;
            h.textView.setText(item.getSection());

            String topColor = UserUtils.getBackgroundColor(context);

            if (!Strings.isNullOrEmpty(topColor)) {
                h.textView.setTextColor(Color.parseColor(topColor));
            }

        } else {

            String urlImage = item.getRow().getUrlImage();

            if (urlImage != null) {

                Glide.with(context)
                        .load(urlImage)
                        .listener(new RequestListener<Drawable>() {
                            @Override
                            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                                ((ViewHolder)holder).progressBar.setVisibility(View.GONE);
                                return false;
                            }

                            @Override
                            public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                                ((ViewHolder)holder).progressBar.setVisibility(View.GONE);
                                return false;
                            }
                        })
                        .into(((ViewHolder)holder).ivSponsor);

            }
        }
    }

    @Override
    public int getItemCount() {
        return mSponsors.size();
    }

    public SectionOrRow getSponsor(int position) {
        return mSponsors.get(position);
    }

//    public String getUrlSponsorPage(int position) {
//        return getSponsor(position).getRow().getUrlSponsorPage();
//    }

    public class SectionViewHolder extends RecyclerView.ViewHolder{

        private TextView textView;

        public SectionViewHolder(View itemView) {
            super(itemView);
            textView = (TextView) itemView.findViewById(R.id.tvTitle);
        }
    }

    @Override
    public int getItemViewType(int position) {
        super.getItemViewType(position);
        SectionOrRow item = mSponsors.get(position);
        if(!item.isRow()) {
            return 0;
        } else {
            return 1;
        }
    }
}
