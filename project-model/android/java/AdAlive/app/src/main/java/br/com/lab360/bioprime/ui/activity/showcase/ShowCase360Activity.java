package br.com.lab360.bioprime.ui.activity.showcase;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.appcompat.widget.Toolbar;
import android.view.View;
import android.widget.Button;

import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseCategory;
import br.com.lab360.bioprime.logic.presenter.showcase.ShowCase360Presenter;
import br.com.lab360.bioprime.ui.activity.NavigationDrawerActivity;
import br.com.lab360.bioprime.ui.activity.video360.Video360Activity;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class ShowCase360Activity extends NavigationDrawerActivity implements ShowCase360Presenter.IShowCaseView {

    @BindView(R.id.buttRotateProduct)
    protected Button buttRotateProduct;
    @BindView(R.id.buttRotatePhoto)
    protected Button buttRotatePhoto;
    @BindView(R.id.buttVideo360)
    protected Button buttVideo360;

    private ShowCase360Presenter mPresenter;
    List<ShowCaseCategory> showCaseCategoryList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_showcase360);
        ButterKnife.bind(this);

        new ShowCase360Presenter(this);
    }

    @Override
    public void initToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        setToolbarTitle(R.string.SCREEN_SHOWCASE);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void setPresenter(ShowCase360Presenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void setColorButtons() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        buttRotatePhoto.setBackgroundColor(color);
        buttRotateProduct.setBackgroundColor(color);
        buttVideo360.setBackgroundColor(color);
    }

    @Override
    public void accessRotateProduct() {
        Intent i = new Intent(ShowCase360Activity.this, RotateProductActivity.class);
        startActivity(i);
    }

    @Override
    public void accessVideo360() {
        Intent i = new Intent(ShowCase360Activity.this, Video360Activity.class);
        startActivity(i);
    }

    //region Button Actions
    @OnClick({
            R.id.buttRotateProduct,
            R.id.buttVideo360
    })

    public void onButtonClick(View view) {
        switch (view.getId()) {
            case R.id.buttRotateProduct:
                accessRotateProduct();
                break;
            case R.id.buttVideo360:
                accessVideo360();
                break;
        }

    }
}
