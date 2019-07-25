package br.com.lab360.oneinternacional.ui.adapters.showcase;

import android.content.Context;
import android.graphics.Bitmap;
import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import java.util.List;

/**
 * Created by Edson on 18/05/2018.
 */

public class SliderAdapter extends PagerAdapter {
    private Context context;
    private List<Bitmap> bitmaps;
    private int defaultPosition;

    public SliderAdapter(Context context, List<Bitmap> bitmaps, int defaultPosition) {
        this.context = context;
        this.bitmaps = bitmaps;
        this.defaultPosition = defaultPosition;
    }

    @Override
    public int getCount() {
        return bitmaps.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }


    @NonNull
    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        ImageView imageView = new ImageView(context);
        imageView.setImageBitmap(bitmaps.get(position));
        container.addView(imageView);

        return imageView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }
}