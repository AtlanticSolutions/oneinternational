package br.com.lab360.oneinternacional.ui.adapters.showcase;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.gallery.GalleryObject;
import br.com.lab360.oneinternacional.ui.activity.showcase.GalleryImagesActivity;
import br.com.lab360.oneinternacional.ui.viewholder.showcase.GalleryViewHolder;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;


/**
 * Created by Edson on 14/05/2018.
 */

public class GalleryGridAdapter extends BaseAdapter {

    private Context context;
    private LayoutInflater inflater;
    private List<GalleryObject> items;
    private SharedPrefsHelper sharedPrefsHelper;

    public GalleryGridAdapter(List<GalleryObject> items, Context context) {
        this.sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        this.items = items;
        this.context = context;
    }

    @Override
    public int getCount() {
        return items.size();
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(context).
                    inflate(R.layout.grid_gallery_item, parent, false);
            final GalleryViewHolder viewHolder = new GalleryViewHolder(convertView);

            final GalleryObject currentItem = items.get(position);
            viewHolder.setImage(currentItem.getImageBitmap());

            if(GalleryImagesActivity.STATE_EDIT == 1) {
                viewHolder.checkGalleryImage().setVisibility(View.VISIBLE);
                viewHolder.rlGalleryImage().setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (viewHolder.checkGalleryImage().isChecked()) {

                            viewHolder.checkGalleryImage().setChecked(false);
                            GalleryImagesActivity.imagesSelected.remove(currentItem);

                        } else {

                            viewHolder.checkGalleryImage().setChecked(true);
                            GalleryImagesActivity.imagesSelected.add(currentItem);
                        }
                    }
                });


            }else{
                viewHolder.checkGalleryImage().setVisibility(View.GONE);
            }
        }
        return convertView;
    }

}