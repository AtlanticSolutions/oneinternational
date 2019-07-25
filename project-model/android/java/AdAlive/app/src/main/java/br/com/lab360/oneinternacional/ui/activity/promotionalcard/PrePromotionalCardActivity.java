package br.com.lab360.oneinternacional.ui.activity.promotionalcard;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;

import com.bumptech.glide.request.target.Target;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.Nullable;
import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard.PromotionalCard;
import br.com.lab360.oneinternacional.logic.presenter.promotionalcard.PrePromotionalCardPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.Base64Utils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import br.com.lab360.oneinternacional.utils.customdialog.CustomDialogBuilder;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 19/08/2018.
 */

public class PrePromotionalCardActivity extends BaseActivity implements PrePromotionalCardPresenter.IPrePromotionalCardView {
    @BindView(R.id.edtPromotionalCard)
    protected EditText edtPromotionalCard;
    @BindView(R.id.btnPromotionalCard)
    protected Button btnPromotionalCard;
    @BindView(R.id.ivImage)
    protected ImageView ivImage;
    @BindView(R.id.ivInformation)
    protected ImageView ivInformation;

    PrePromotionalCardPresenter mPresenter;
    public static List<String> base64Images;
    public static PromotionalCard promotionalCard;
    public static int urlImageCount = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pre_promotional_card);
        ButterKnife.bind(this);

        base64Images = new ArrayList<>();
        new PrePromotionalCardPresenter(this);
    }

    @Override
    public void initToolbar() {
        initToolbar(getString(R.string.SCREEN_TITLE_PRE_PROMOTIONAL_CARDS));
        GradientDrawable drawable = (GradientDrawable) ivInformation.getBackground();
        drawable.setStroke(10, getResources().getColor(R.color.white));
        drawable.setColor(Color.parseColor("#00000000"));
    }

    @Override
    public void setColorViews() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        btnPromotionalCard.setBackgroundColor(color);
    }

    @Override
    public void setPresenter(PrePromotionalCardPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void loadPromotionalCardSuccess(final PromotionalCard promotionalCard) {
        this.promotionalCard = promotionalCard;
        attemptToLoadImages(promotionalCard);
    }

    @Override
    public void attemptToLoadImages(final PromotionalCard promotionalCard) {
        List<String> urlImages = new ArrayList<>();
        urlImages.add(promotionalCard.getUrlPrizeWon());
        urlImages.add(promotionalCard.getUrlPrizeLose());
        urlImages.add(promotionalCard.getUrlPrizePedding());
        urlImages.add(promotionalCard.getUrlBackgroundCard());
        urlImages.add(promotionalCard.getUrlCoverCard());
        urlImages.add(promotionalCard.getUrlBackgroundScreen());
        urlImages.add(promotionalCard.getUrlParticleObject());

        if(urlImageCount <= 6){
            Glide.with(this)
                    .load(urlImages.get(urlImageCount))
                    .listener(new RequestListener<Drawable>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                            urlImageCount++;
                            base64Images.add("");
                            loadPromotionalCardSuccess(promotionalCard);
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                            Bitmap bitmap = ((BitmapDrawable)resource).getBitmap();
                            base64Images.add(Base64Utils.encodeFileToBase64(bitmap, Bitmap.CompressFormat.PNG, 100));
                            urlImageCount++;
                            loadPromotionalCardSuccess(promotionalCard);
                            return false;
                        }
                    }).preload();
        }else{
            urlImageCount = 0;
            showPromotionalTypeDialog(promotionalCard, base64Images);
        }
    }

    @Override
    public void attemptToNextActivity(PromotionalCard promotionalCard, List<String> base64Images, boolean isAwarded) {
        hideProgress();
        startNextActivity(promotionalCard, base64Images, isAwarded);
    }

    @Override
    public void startNextActivity(PromotionalCard promotionalCard, List<String> base64Images, boolean isAwarded) {
        Gson gson = new Gson();
        Intent intent = new Intent(PrePromotionalCardActivity.this, PromotionalCardActivity.class);
        SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        sharedPrefsHelper.put("base64Images", gson.toJson(base64Images));
        sharedPrefsHelper.put("promotionalCard", gson.toJson(promotionalCard));
        sharedPrefsHelper.put("isAwarded", isAwarded);
        startActivity(intent);
    }

    @Override
    public void showPromotionalTypeDialog(final PromotionalCard promotionalCard, final List<String> base64Images) {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.INFORMATION,
                getString(R.string.DIALOG_TITLE_ATENTION),
                getString(R.string.DIALOG_MESSAGE_TYPE_PRE_PROMOTIONAL_CARDS),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_AWARDED),
                R.color.white,
                R.drawable.blue_button_background,
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_NOT_AWARDED),
                R.color.white,
                R.drawable.red_button_background,
                onClickDialogButton(R.id.DIALOG_BUTTON_2)
        );

        showCustomDialog();
    }

    @Override
    public void showInformativeDialog() {
        infoDialog(getString(R.string.DIALOG_TITLE_HELP),
                getString(R.string.DIALOG_MESSAGE_INFORMATIVE_PRE_PROMOTIONAL_CARDS),
                null
        );
    }

    @Override
    public void showErrorMessage(String message) {
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR),
                message,
                null
        );
    }

    @OnClick(R.id.btnPromotionalCard)
    public void onClickPromotionalCardButton(View view){
        mPresenter.getPromotionalCard(edtPromotionalCard.getText().toString());
    }

    @OnClick(R.id.ivInformation)
    public void onClickInformative(View view) {
        showInformativeDialog();
    }

    @Override
    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        attemptToNextActivity(promotionalCard, base64Images, true);
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        attemptToNextActivity(promotionalCard, base64Images, false);
                        break;
                }
            }
        };
    }
}