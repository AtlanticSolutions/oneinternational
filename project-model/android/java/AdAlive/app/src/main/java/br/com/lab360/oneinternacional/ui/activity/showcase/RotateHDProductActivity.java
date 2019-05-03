package br.com.lab360.oneinternacional.ui.activity.showcase;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.widget.ImageView;
import android.widget.ViewFlipper;

import com.bumptech.glide.Glide;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 07/05/2018.
 */

public class RotateHDProductActivity extends BaseActivity {

    @BindView(R.id.viewFlipper)
    protected ViewFlipper mViewFlipper;

    private ProgressDialog progressDialog;

    public String urls[] = {"https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0001.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0002.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0003.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0004.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0005.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0006.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0007.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0008.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0009.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0010.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0011.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0012.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0013.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0014.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0015.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0016.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0017.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0018.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0019.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0020.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0021.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0022.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0023.jpg",
            "https://s3-sa-east-1.amazonaws.com/ad-alive.com/downloads/lab360/viewer360/rotationalImagesHD/IMG_0024.jpg",
    };

    private GestureDetector mGestureDetector;
    private Context ctx;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rotate_hd_product);
        ButterKnife.bind(this);

        initToolbar("Product");

        ctx = this;

        progressDialog = new ProgressDialog(this);
        progressDialog.setMessage("Baixando imagens");
        progressDialog.show();
        // Add all the images to the ViewFlipper
        for(String s : urls){
            ImageView imageView = new ImageView(this);
            Glide.with(this).load(s).into(imageView);
            mViewFlipper.addView(imageView);
        }


        CustomGestureDetector customGestureDetector = new CustomGestureDetector();
        mGestureDetector = new GestureDetector(this, customGestureDetector);

    }


    class CustomGestureDetector extends GestureDetector.SimpleOnGestureListener {

        @Override
        public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
            if (e1.getX() > e2.getX()) {
                mViewFlipper.showNext();
            }

            // Swipe right (previous)
            if (e1.getX() < e2.getX()) {
                mViewFlipper.showPrevious();
            }
            return super.onScroll(e1, e2, distanceX, distanceY);
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        mGestureDetector.onTouchEvent(event);

        return super.onTouchEvent(event);
    }


}
