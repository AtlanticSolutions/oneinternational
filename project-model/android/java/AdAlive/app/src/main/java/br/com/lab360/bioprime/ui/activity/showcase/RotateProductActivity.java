package br.com.lab360.bioprime.ui.activity.showcase;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.ViewFlipper;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 07/05/2018.
 */

public class RotateProductActivity extends BaseActivity {

    @BindView(R.id.viewFlipper)
    protected ViewFlipper mViewFlipper;
    @BindView(R.id.imgvHdImages)
    protected ImageView imgvHdImages;

    private ProgressDialog progressDialog;

    int[] resources = {
            R.drawable.bud1,
            R.drawable.bud2,
            R.drawable.bud3,
            R.drawable.bud4,
            R.drawable.bud5,
            R.drawable.bud6,
            R.drawable.bud7,
            R.drawable.bud8,
            R.drawable.bud9,
            R.drawable.bud10,
            R.drawable.bud11,
            R.drawable.bud12,
            R.drawable.bud13,
            R.drawable.bud14,
            R.drawable.bud15,
            R.drawable.bud16,
            R.drawable.bud17,
            R.drawable.bud18,
            R.drawable.bud19,
            R.drawable.bud20,
            R.drawable.bud21,
            R.drawable.bud22,
            R.drawable.bud23,
            R.drawable.bud24
    };

    private GestureDetector mGestureDetector;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rotate_product);
        ButterKnife.bind(this);

        initToolbar("Product");

        // Add all the images to the ViewFlipper
        for (int i = 0; i < resources.length; i++) {
            ImageView imageView = new ImageView(this);
            imageView.setImageResource(resources[i]);
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

    //region Button Actions
    @OnClick({
            R.id.imgvHdImages
    })

    public void onButtonClick(View view) {
        switch (view.getId()) {
            case R.id.imgvHdImages:
                Intent i = new Intent(RotateProductActivity.this, RotateHDProductActivity.class);
                startActivity(i);
                break;
        }

    }


}
