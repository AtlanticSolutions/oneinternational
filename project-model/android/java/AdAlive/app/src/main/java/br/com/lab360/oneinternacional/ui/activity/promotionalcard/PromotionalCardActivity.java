package br.com.lab360.oneinternacional.ui.activity.promotionalcard;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import androidx.core.content.ContextCompat;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AccelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.DecelerateInterpolator;
import android.view.animation.ScaleAnimation;
import android.widget.AbsoluteLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.common.base.Strings;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard.PromotionalCard;
import br.com.lab360.oneinternacional.logic.presenter.promotionalcard.PromotionalCardPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.decorator.AnimationPromotionalCard;
import br.com.lab360.oneinternacional.ui.decorator.CoverCardView;
import br.com.lab360.oneinternacional.utils.Base64Utils;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import br.com.lab360.oneinternacional.utils.customdialog.CustomDialogBuilder;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by Edson on 19/08/2018.
 */

public class PromotionalCardActivity extends BaseActivity implements PromotionalCardPresenter.IPromotionalCardView {

    @BindView(R.id.tvTitleBar)
    TextView tvTitleBar;
    @BindView(R.id.ivInformation)
    protected ImageView ivInformation;
    @BindView(R.id.animationParticleObject)
    AnimationPromotionalCard animationPromotionalCard;
    @BindView(R.id.ivBackgroundCard)
    ImageView ivBackgroundCard;
    @BindView(R.id.ivPrize)
    ImageView ivPrize;
    @BindView(R.id.absPrize)
    AbsoluteLayout absPrize;
    @BindView(R.id.rlPromotionalCard)
    RelativeLayout rlPromotionalCard;
    @BindView(R.id.rlPrize)
    RelativeLayout rlPrize;
    @BindView(R.id.llBackgroundScreen)
    LinearLayout llBackgroundScreen;
    @BindView(R.id.llBorderPromotionalCard)
    LinearLayout llBorderPromotionalCard;
    @BindView(R.id.coverCardView)
    CoverCardView coverCardView;
    @BindView(R.id.tvInfo)
    TextView tvInfo;

    Bitmap imagePrizeWon;
    Bitmap imagePrizeLose;
    Bitmap imagePrize;
    Bitmap backgroundCard;
    Bitmap coverCard;
    Bitmap backgroundScreen;
    Bitmap animationImage;
    String colorBorderPromotionalCard;
    String link;
    String message;
    String textInfo;
    String barTitle;
    String colorDetail;
    int preferedSize;
    int preferedPosition;
    double coverLimit;
    double lineWidth;
    boolean isAwarded;

    List<String> base64Images = new ArrayList<>();
    PromotionalCard promotionalCard = new PromotionalCard();

    AbsoluteLayout.LayoutParams ivPrizeParams;
    PromotionalCardPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_promotional_card);
        ButterKnife.bind(this);

        new PromotionalCardPresenter(this);
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        if (!Strings.isNullOrEmpty(getBarTitle())) {
            getSupportActionBar().setTitle("");
            tvTitleBar.setText(getBarTitle());
        }else{
            getSupportActionBar().setTitle("");
        }

        if (!Strings.isNullOrEmpty(getColorDetail())) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(getColorDetail()));
            getSupportActionBar().setBackgroundDrawable(cd);
            ScreenUtils.updateStatusBarcolor(this, getPromotionalCard ().getColorDetail());
        }else{
            String topColor = UserUtils.getBackgroundColor(this);
            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
                ScreenUtils.updateStatusBarcolor(this, topColor);
            }
        }

        GradientDrawable drawable = (GradientDrawable) ivInformation.getBackground();
        drawable.setStroke(10, getResources().getColor(R.color.white));
        drawable.setColor(Color.parseColor("#00000000"));
    }

    @Override
    public void setPresenter(PromotionalCardPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void initDataExtras() {
        Gson gson = new Gson();
        SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        setBase64Images(Arrays.asList(gson.fromJson(sharedPrefsHelper.get("base64Images", ""),String[].class )));
        setPromotionalCard(gson.fromJson(sharedPrefsHelper.get("promotionalCard", ""), PromotionalCard.class));
        setAwarded(sharedPrefsHelper.get("isAwarded",false));
    }

    @Override
    public void populateVariables() {
        setImagePrizeWon(Base64Utils.decodeBase64(getBase64Images().get(0)));
        setImagePrizeLose(Base64Utils.decodeBase64(getBase64Images().get(1)));
        setImagePrize(Base64Utils.decodeBase64(getBase64Images().get(2)));
        setImageBackgroundCard(Base64Utils.decodeBase64(getBase64Images().get(3)));
        setImageCoverCard(Base64Utils.decodeBase64(getBase64Images().get(4)));
        setImageBackgroundScreen(Base64Utils.decodeBase64(getBase64Images().get(5)));
        setImageAnimation(Base64Utils.decodeBase64(getBase64Images().get(6)));
        setColorBorderPromotionalCard(getPromotionalCard().getColorDetail());
        setLink(getPromotionalCard().getLink());
        setMessage(getPromotionalCard().getMessage());
        setTextInfo(getPromotionalCard().getInfo());
        setBarTitle(getPromotionalCard().getTitle());
        setColorDetail(getPromotionalCard().getColorDetail());
        setPreferedSize(getPromotionalCard().getPreferedSize());
        setPreferedPosition(getPromotionalCard().getPreferedPosistion());
        setCoverLimit(getPromotionalCard().getCoverLimit());
        setLineWidth(getPromotionalCard().getLineWidth());
    }

    @Override
    public void firstPopulationViews() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                loadLayoutImagePrize(getImagePrize(), getPreferedSize(), getPreferedPosition());
            }
        }, 500);

        loadImageBackgroundCard(getImageBackgroundCard());
        loadImageCoverCard(getImageCoverCard());
        loadImageBackgroundScreen(getImageBackgroundScreen());
        loadAnimationImage(getImageAnimation());
        loadColorBorderPromotionalCard(getColorBorderPromotionalCard());
        loadTextInfo(getTextInfo());
    }

    @Override
    public void loadLayoutImagePrize(Bitmap bitmap, int preferedSize, int preferedPosition) {
        int size = (int) configureSizeImagePrize(preferedSize);
        ivPrizeParams = new AbsoluteLayout.LayoutParams(size, size, 0, 0);
        ivPrize.setLayoutParams(ivPrizeParams);
        ivPrize.setImageBitmap(bitmap);
        configurePositionImagePrize(preferedPosition);
    }

    @Override
    public void loadImageBackgroundCard(Bitmap bitmap) {
        ivBackgroundCard.setImageBitmap(bitmap);
    }

    @Override
    public void loadImageCoverCard(Bitmap bitmap) {
        coverCardView.setWatermark(bitmap);
        configureCoverCard(getCoverLimit(), getLineWidth());
    }

    @Override
    public void loadImageBackgroundScreen(Bitmap bitmap) {
        BitmapDrawable bitmapDrawable = new BitmapDrawable(bitmap);
        llBackgroundScreen.setBackgroundDrawable(bitmapDrawable);
    }

    @Override
    public void loadAnimationImage(Bitmap bitmap) {
        if (bitmap != null && !bitmap.equals("")) {
            Drawable drawable = new BitmapDrawable(getResources(), bitmap);
            animationPromotionalCard.setImages(drawable);
        }else{
            Drawable drawable = getResources().getDrawable(R.drawable.coin);
            animationPromotionalCard.setImages(drawable);
        }
    }

    @Override
    public void loadColorBorderPromotionalCard(String color) {
        Drawable background = llBorderPromotionalCard.getBackground();
        GradientDrawable gradientDrawable = (GradientDrawable) background;

        if (!Strings.isNullOrEmpty(color)) {
            gradientDrawable.setColor(Color.parseColor(color));
        }else{
            gradientDrawable.setColor(Color.parseColor(UserUtils.getBackgroundColor(this)));
        }
    }

    @Override
    public void loadTextInfo(String info) {
        tvInfo.setText(info);
    }

    @Override
    public void configureCoverCard(double coverLimit, double lineLimit) {
        setEraserSize(lineLimit);
        setErasePercent(coverLimit);
        setEraseStatusListener();
    }

    @Override
    public void configurePositionImagePrize(int preferedPosition) {
        if (preferedPosition == 1) {
            createRandomPlaceForPrize();
        }else if (preferedPosition == 2) {
            createCenterPlaceForPrize();
        }else {
            createCenterPlaceForPrize();
        }
    }

    @Override
    public double configureSizeImagePrize(int preferedSize) {
        int preferedPercetage;
        double preferedResult;
        int sizeView;

        if (preferedSize == 1) {
            preferedPercetage = 25;
        } else if (preferedSize == 2) {
            preferedPercetage = 40;
        } else if (preferedSize == 3) {
            preferedPercetage = 55;
        } else {
            preferedPercetage = 40;
        }

        sizeView = llBorderPromotionalCard.getMeasuredWidth();
        preferedResult = sizeView* preferedPercetage;
        preferedResult = preferedResult / 100;

        return  preferedResult;
    }

    @Override
    public void createRandomPlaceForPrize() {
        ViewTreeObserver vto = llBorderPromotionalCard.getViewTreeObserver();
        vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {

            public boolean onPreDraw() {
                ivBackgroundCard.getViewTreeObserver().removeOnPreDrawListener(this);
                int ivBackgroundCardHeight = ivBackgroundCard.getMeasuredHeight();
                int ivBackgroundCardWidth = ivBackgroundCard.getMeasuredWidth();

                Random randomPlace = new Random();
                AbsoluteLayout.LayoutParams pos =
                        (AbsoluteLayout.LayoutParams)ivPrize.getLayoutParams();

                pos.x =  randomPlace.nextInt(ivBackgroundCardWidth - ivPrize.getWidth());
                pos.y =  randomPlace.nextInt(ivBackgroundCardHeight - ivPrize.getHeight());
                ivPrize.setLayoutParams(pos);

                setAreaToErase(pos.x, pos.y);
                return true;
            }
        });
    }

    @Override
    public void createCenterPlaceForPrize() {
        ViewTreeObserver vto = llBorderPromotionalCard.getViewTreeObserver();
        vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {

            public boolean onPreDraw() {
                llBorderPromotionalCard.getViewTreeObserver().removeOnPreDrawListener(this);
                int ivBackgroundCardHeight = ivBackgroundCard.getMeasuredHeight();
                int ivBackgroundCardWidth = ivBackgroundCard.getMeasuredWidth();

                AbsoluteLayout.LayoutParams pos =
                        (AbsoluteLayout.LayoutParams)ivPrize.getLayoutParams();

                pos.x = (ivBackgroundCardWidth / 2) - (ivPrize.getWidth() / 2);
                pos.y = (ivBackgroundCardHeight / 2) - (ivPrize.getHeight() / 2);
                ivPrize.setLayoutParams(pos);

                setAreaToErase(pos.x, pos.y);
                return true;
            }
        });
    }

    @Override
    public void setEraserSize(double lineLimit) {
        if (lineLimit > 0.0f) {
            coverCardView.setEraserSize((float) lineLimit);
        } else{
            coverCardView.setEraserSize(0.80f);
        }
    }

    @Override
    public void setErasePercent(double coverLimit) {
        if (coverLimit > 0) {
            coverCardView.setMaxPercent(new Double(coverLimit*100).intValue());
        } else {
            coverCardView.setMaxPercent(100);
        }
    }

    @Override
    public void setEraseStatusListener() {
        coverCardView.setEraseStatusListener(new CoverCardView.EraseStatusListener() {
            @Override
            public void onProgress(int percent) {
            }

            @Override
            public void onCompleted(View view) {
                disableToolbarActions();
                finalAnimations();
            }
        });
    }

    @Override
    public void setAreaToErase(int x, int y) {
        coverCardView.viewX1 = x;
        coverCardView.viewY1 = y;
        coverCardView.viewX2= x + ivPrize.getWidth();
        coverCardView.viewY2 = y + ivPrize.getHeight();
        coverCardView.prizeWidth = ivPrizeParams.width;
        coverCardView.prizeHeight = ivPrizeParams.height;
    }

    public void animationFlip(final ImageView view, final Bitmap bitmap) {
        final ObjectAnimator oa1 = ObjectAnimator.ofFloat(view, "scaleX", 1f, 0f);
        final ObjectAnimator oa2 = ObjectAnimator.ofFloat(view, "scaleX", 0f, 1f);
        oa1.setInterpolator(new DecelerateInterpolator());
        oa2.setInterpolator(new AccelerateDecelerateInterpolator());
        oa1.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                view.setImageBitmap(bitmap);
                oa2.start();
                if (isAwarded()) {
                    animationPulse(view);
                }
            }
        });
        oa1.start();
    }

    public void animationPulse(View view) {
        Animation anim = new ScaleAnimation(1f, 0.9f, 1f, 0.9f, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        anim.setFillAfter(true);
        anim.setRepeatCount(ObjectAnimator.INFINITE);
        anim.setRepeatMode(ObjectAnimator.REVERSE);
        anim.setDuration(100);
        view.startAnimation(anim);
    }

    public static void animationFadeIn(View view) {
        Animation fadeIn = new AlphaAnimation(0, 1);
        fadeIn.setInterpolator(new DecelerateInterpolator());
        fadeIn.setDuration(1000);
        AnimationSet animation = new AnimationSet(false);
        animation.addAnimation(fadeIn);
        view.startAnimation(animation);
        view.setVisibility(View.VISIBLE);
    }

    public static void animationFadeOut(View view) {
        Animation fadeOut = new AlphaAnimation(1, 0);
        fadeOut.setInterpolator(new AccelerateInterpolator());
        fadeOut.setStartOffset(1000);
        fadeOut.setDuration(1000);
        AnimationSet animation = new AnimationSet(false);
        animation.addAnimation(fadeOut);
        view.startAnimation(animation);
        view.setVisibility(View.GONE);
    }

    @Override
    public void initialAnimations() {
        animationFadeIn(rlPromotionalCard);
    }

    @Override
    public void finalAnimations() {
        if (isAwarded()) {
            animationPromotionalCard.setVisibility(View.VISIBLE);
            animationPromotionalCard.start();
            animationFlip(ivPrize, getImagePrizeWon());
        }else{

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    showNotAwardedDialog();
                }
            }, 3000);
            animationFlip(ivPrize, getImagePrizeLose());
        }

        playSoundEffect();
        animationFadeOut(coverCardView);
    }

    @Override
    public void disableToolbarActions() {
        ivInformation.setVisibility(View.GONE);
        getSupportActionBar().setDisplayHomeAsUpEnabled(false);
    }

    @Override
    public void playSoundEffect() {
        MediaPlayer player;
        if(isAwarded()){
            player = MediaPlayer.create(this, R.raw.promotionalcard_good_result);
        }else{
            player = MediaPlayer.create(this, R.raw.promotionalcard_bad_result);
        }
        player.start();
    }

    @Override
    public void showProgressErasingDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ERROR,
                getString(R.string.DIALOG_TITLE_ATENTION),
                getString(R.string.DIALOG_MESSAGE_PREVIOUS_ACTIVITY_ACTION),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_OK),
                R.color.white,
                R.drawable.background_red,
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CANCEL),
                R.color.white,
                R.drawable.gray_button_background,
                null
        );

        showCustomDialog();
    }

    @Override
    public void showTutorialDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.INFORMATION,
                getString(R.string.DIALOG_TITLE_HELP),
                getString(R.string.DIALOG_MESSAGE_TUTORIAL_PROMOTIONAL_CARDS),
                R.raw.tutorial_promotionalcard
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_OK),
                R.color.white,
                R.drawable.blue_button_background,
                null
        );

        showCustomDialog();
    }

    @Override
    public void showNotAwardedDialog() {
        errorDialog(getString(R.string.DIALOG_TITLE_NOT_AWARDED_PROMOTIONAL_CARDS),
                getString(R.string.DIALOG_MESSAGE_NOT_AWARDED_PROMOTIONAL_CARDS),
                onClickDialogButton(R.id.DIALOG_BUTTON_2)
        );
    }

    @Override
    public void showAwardedDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.SUCCESS,
                getString(R.string.DIALOG_TITLE_AWARDED_PROMOTIONAL_CARDS),
                getMessage(),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_SHOW_MORE),
                R.color.white,
                Color.parseColor(getColorDetail()),
                onClickDialogButton(R.id.DIALOG_BUTTON_3)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CLOSE),
                R.color.white,
                R.drawable.gray_button_background,
                onClickDialogButton(R.id.DIALOG_BUTTON_4)
        );

        showCustomDialog();
    }

    @OnClick(R.id.animationParticleObject)
    public void onClickParticleObject(View view){
        showAwardedDialog();
    }

    @OnClick(R.id.ivInformation)
    public void onClickInformative(View view) {
        showTutorialDialog();
    }

    @Override
    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent;
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        intent = new Intent(PromotionalCardActivity.this, PrePromotionalCardActivity.class);
                        startActivity(intent);
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        intent = new Intent(PromotionalCardActivity.this, PrePromotionalCardActivity.class);
                        startActivity(intent);
                        break;
                    case R.id.DIALOG_BUTTON_3:
                        intent = new Intent(Intent.ACTION_VIEW, Uri.parse(getLink()));
                        startActivity(intent);
                        break;
                    case R.id.DIALOG_BUTTON_4:
                        intent = new Intent(PromotionalCardActivity.this, PrePromotionalCardActivity.class);
                        startActivity(intent);
                        break;
                }
            }
        };
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                if(coverCardView.getTotalErased() > 0){
                    showProgressErasingDialog();

                }else{
                    Intent intent = new Intent(PromotionalCardActivity.this, PrePromotionalCardActivity.class);
                    startActivity(intent);
                    finish();
                }
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
    }

    public List<String> getBase64Images() {
        return base64Images;
    }

    public void setBase64Images(List<String> base64Images) {
        this.base64Images = base64Images;
    }

    public PromotionalCard getPromotionalCard() {
        return promotionalCard;
    }

    public void setPromotionalCard(PromotionalCard promotionalCard) {
        this.promotionalCard = promotionalCard;
    }

    public boolean isAwarded() {
        return isAwarded;
    }

    public void setAwarded(boolean awarded) {
        isAwarded = awarded;
    }

    public Bitmap getImagePrizeWon() {
        return imagePrizeWon;
    }

    public void setImagePrizeWon(Bitmap imagePrizeWon) {
        this.imagePrizeWon = imagePrizeWon;
    }

    public Bitmap getImagePrizeLose() {
        return imagePrizeLose;
    }

    public void setImagePrizeLose(Bitmap imagePrizeLose) {
        this.imagePrizeLose = imagePrizeLose;
    }

    public void setImagePrize(Bitmap imagePrize) {
        this.imagePrize = imagePrize;
    }

    public Bitmap getImagePrize() {
        return imagePrize;
    }

    public void setImageBackgroundCard(Bitmap backgroundCard) {
        this.backgroundCard = backgroundCard;
    }

    public Bitmap getImageBackgroundCard() {
        return backgroundCard;
    }

    public void setImageCoverCard(Bitmap coverCard) {
        this.coverCard = coverCard;
    }

    public Bitmap getImageCoverCard() {
        return coverCard;
    }

    public void setImageBackgroundScreen(Bitmap backgroundScreen) {
        this.backgroundScreen = backgroundScreen ;
    }

    public Bitmap getImageBackgroundScreen() {
        return backgroundScreen;
    }

    public void setImageAnimation(Bitmap animationImage) {
        this.animationImage = animationImage;
    }

    public Bitmap getImageAnimation() {
        return animationImage;
    }

    public void setColorBorderPromotionalCard(String colorBorderPromotionalCard) {
        this.colorBorderPromotionalCard = colorBorderPromotionalCard;
    }

    public String getColorBorderPromotionalCard() {
        return colorBorderPromotionalCard;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setTextInfo(String textInfo) {
        this.textInfo = textInfo;
    }

    public String getTextInfo() {
        return textInfo;
    }

    public String getBarTitle() {
        return barTitle;
    }

    public void setBarTitle(String title) {
        this.barTitle = title;
    }

    public String getColorDetail() {
        return colorDetail;
    }

    public void setColorDetail(String colorDetail) {
        this.colorDetail = colorDetail;
    }

    public int getPreferedSize() {
        return preferedSize;
    }

    public void setPreferedSize(int preferedSize) {
        this.preferedSize = preferedSize;
    }

    public int getPreferedPosition() {
        return preferedPosition;
    }

    public void setPreferedPosition(int preferedPosition) {
        this.preferedPosition = preferedPosition;
    }

    public double getCoverLimit() {
        return coverLimit;
    }

    public void setCoverLimit(double coverLimit) {
        this.coverLimit = coverLimit;
    }

    public double getLineWidth() {
        return lineWidth;
    }

    public void setLineWidth(double lineWidth) {
        this.lineWidth = lineWidth;
    }
}