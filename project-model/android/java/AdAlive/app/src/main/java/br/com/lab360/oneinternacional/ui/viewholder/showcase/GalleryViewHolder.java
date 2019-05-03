package br.com.lab360.oneinternacional.ui.viewholder.showcase;

import android.graphics.Bitmap;
import android.view.View;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 14/05/2018.
 */

public class GalleryViewHolder {

    @BindView(R.id.rlGalleryImage)
    protected RelativeLayout rlGalleryImage;

    @BindView(R.id.ivGalleryImage)
    protected ImageView ivGalleryImage;

    @BindView(R.id.checkGalleryImage)
    protected CheckBox checkGalleryImage;

    public GalleryViewHolder(View itemView) {
        ButterKnife.bind(this, itemView);
    }

    public void setImage(Bitmap bitmap){
        ivGalleryImage.setImageBitmap(bitmap);
    }

    public RelativeLayout rlGalleryImage(){
        return rlGalleryImage;
    }

    public ImageView ivGalleryImage(){
        return ivGalleryImage;
    }

    public CheckBox checkGalleryImage(){
        return checkGalleryImage;
    }
}
