package br.com.lab360.oneinternacional.ui.activity.product;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.widget.Toolbar;
import android.transition.Explode;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;
import com.github.ksoichiro.android.observablescrollview.ObservableScrollView;
import com.github.ksoichiro.android.observablescrollview.ObservableScrollViewCallbacks;
import com.github.ksoichiro.android.observablescrollview.ScrollState;
import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.List;
import java.util.Observable;
import java.util.Observer;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.adalive.Action;
import br.com.lab360.oneinternacional.logic.adalive.Product;
import br.com.lab360.oneinternacional.logic.model.pojo.product.ProductLocal;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.activity.mediaplayer.ExoPlayerActivity;
import br.com.lab360.oneinternacional.ui.activity.survey.SurveyActionActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import lib.enumeration.ActionType;
import lib.error.NullTargetNameException;
import lib.error.NullUrlServerException;
import lib.ui.AdAliveWS;
import lib.utils.ConstantsAdAlive;


/**
 * Created by Victor on 20/08/2015.
 * Represents screen app ({@link Activity}) with information of the {@link Product}.
 */
public class ProductActivity extends BaseActivity implements ObservableScrollViewCallbacks, Observer {

    private boolean isChecked = false;
    private Toolbar toolbar;
    private ImageView ivImgProduct;
    //private TouchImageView ivLandscape;

    private ObservableScrollView mScrollView;
    private android.view.GestureDetector gestureDetector;
    private SharedPreferences prefs;

    private boolean isAutoLauncher;
    private BannerComponent bannerComponent;
    private FrameLayout flPortrait;
    private ViewGroup.MarginLayoutParams params;
    private LinearLayout llBanner;

    private ProductLocal product;


    private AdAliveWS mAdAliveWS;
    private String urlServer;
    private String userEmail;

    private Context ctx;

    @BindView(R.id.container_loading)
    protected LinearLayout mContainerLoading;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ctx = this;

        urlServer = ApiManager.getInstance().getUrlAdaliveApi(this);
        userEmail = AdaliveApplication.getInstance().getUser().getEmail();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            // set an enter transition
            getWindow().setEnterTransition(new Explode());
            // set an exit transition
            getWindow().setExitTransition(new Explode());
        }

        setContentView(R.layout.activity_product);

        ButterKnife.bind(this);

        mContainerLoading.setVisibility(View.VISIBLE);

        product = AdaliveApplication.getInstance().getProduct();


        initAdAliveWS();

        initComponents();
        configStatusBarColor();


    }

    private void initComponents() {


        initToolbar();
        configLayout();
        initHeaderLayout();

        initCardsAction();
        initRecyclerViewRecommends();

        //ivLandscape = (TouchImageView) findViewById(R.id.ivLandscape);

        initBanner();

        mContainerLoading.setVisibility(View.INVISIBLE);

    }

    /**
     * Initialize the banner component.
     */
    private void initBanner() {

        flPortrait = (FrameLayout) findViewById(R.id.flPortrait);

        params = (ViewGroup.MarginLayoutParams) flPortrait.getLayoutParams();

        llBanner = (LinearLayout) findViewById(R.id.banner);

        params.setMargins(0, 0, 0, 60);
        flPortrait.setLayoutParams(params);

        bannerComponent = new BannerComponent(this, (ImageView) findViewById(R.id.ivBanner));

        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {

            bannerComponent.hideBannerProductScreen(flPortrait, params, llBanner);

            //ivLandscape.requestLayout();

        }

    }




    private void execAutoLaunch() {

        List<Action> actions = product.getActions();

        isAutoLauncher = true;

        for (Action action : actions) {

            if (action.getAutoLaunch()) {
                execProductAction(product, action);
                break;
            }

        }
    }


    public void initToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                onBackPressed();
            }

        });

        //Paulo Create a generic method - Paulo
        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }


    private void initCardsAction() {

        LinearLayout llContainerActions = (LinearLayout) findViewById(R.id.llContainerActions);
        LayoutInflater inflater = LayoutInflater.from(this);

        for (final Action action : product.getActions()) {

            View inflatedLayout = inflater.inflate(R.layout.item_card_actions_product, null, false);

            ((TextView) inflatedLayout.findViewById(R.id.tvAction)).setText(action.getLabel());

            int resImageAction = 0;
            final int typeAction = action.getActionType();

            if (typeAction == ActionType.EMAIL_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_email;
            } else if (typeAction == ActionType.INFO_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_info;
            } else if (typeAction == ActionType.LIKE_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_info;
            } else if (typeAction == ActionType.LINK_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_link;
            } else if (typeAction == ActionType.PHONE_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_phone;
            } else if (typeAction == ActionType.PRICE_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_price;
            } else if (typeAction == ActionType.TWEET_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_tweet;
            } else if (typeAction == ActionType.VIDEO_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_video;
            } else if (typeAction == ActionType.ORDER_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_order;
            } else if (typeAction == ActionType.AUDIO_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_audio;
            } else if (typeAction == ActionType.SURVEY_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_survey;
            } else if (typeAction == ActionType.PROMOTION_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_coupon;
            } else if (typeAction == ActionType.MASK_ACTION.getActionType()) {
                resImageAction = R.drawable.ic_action_mask;
            }

            if (resImageAction != 0) {
                ((ImageView) inflatedLayout.findViewById(R.id.ivAction)).setImageResource(resImageAction);
            }

            LinearLayout card = (LinearLayout) inflatedLayout.findViewById(R.id.llActionContainer);

            card.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    if (action.getActionType() == ActionType.SURVEY_ACTION.getActionType()) {

                        try {

                            mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), action.getId());

                        } catch (Exception e) {

                            Log.e(AdaliveConstants.ERROR, "update: " + e);

                        }


                    } else if (action.getActionType() == ActionType.INFO_ACTION.getActionType()) {


                        mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), action.getId());

                    }

                    else if (action.getActionType() == ActionType.VIDEO_ACTION.getActionType()) {


                        mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), action.getId());
                        //Intent i = null;
                        //i = ExoPlayerActivity.build(ctx, action.getHref());
                        //startActivity(i);
                    }


                }
            });

            llContainerActions.addView(inflatedLayout);

            ViewGroup.MarginLayoutParams p = (ViewGroup.MarginLayoutParams) inflatedLayout.getLayoutParams();
            p.setMargins(5, 1, 1, 5);
            inflatedLayout.requestLayout();

        }

    }

    private void configLayout() {

        mScrollView = (ObservableScrollView) findViewById(R.id.scroll);
        mScrollView.setScrollViewCallbacks(this);
        mScrollView.scrollVerticallyTo(0);

    }


    private void initHeaderLayout() {
        ivImgProduct = (ImageView) findViewById(R.id.ivImgProduct);
        TextView tvTitleProd = (TextView) findViewById(R.id.tvTitleProd);
        TextView tvSubTitleProd = (TextView) findViewById(R.id.tvSubTitleProd);

        if (product != null) {
            RequestOptions options = new RequestOptions();
            options.diskCacheStrategy(DiskCacheStrategy.ALL);

            Glide.with(this)
                    .load(product.getImageUrl())
                    .apply(options)
                    .into(ivImgProduct);

            tvTitleProd.setText(product.getTitle());
            tvSubTitleProd.setText(product.getSubtitle());
        }

    }

    private void initRecyclerViewRecommends() {
//        final RecyclerView rvRecommends = (RecyclerView) findViewById(R.id.rvProductRecommends);
//
//        if(product.getRecommends().size() > 0) {
//
//            final RecommendsProductAdapter adapter = new RecommendsProductAdapter(this, product.getRecommends());
//            LinearLayoutManager mLayoutManager = new LinearLayoutManager(this);
//            mLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
//            rvRecommends.setLayoutManager(mLayoutManager);
//
//            rvRecommends.setAdapter(adapter);
//            rvRecommends.setHasFixedSize(true);
//
//            rvRecommends.addOnItemTouchListener(new RecyclerItemClickListener(this, rvRecommends,
//                    new RecyclerItemClickListener.OnItemClickListener() {
//                        @Override
//                        public void onItemClick(View view, int position) {
//                            RecommendsProductAdapter adapter = (RecommendsProductAdapter) rvRecommends.getAdapter();
//                            ArrayList<Recommends> recommendsList = adapter.getRecommends();
//
//                            Recommends recommends = recommendsList.get(position);
//
//                            callGetProduct(String.valueOf(recommends.getId()));
//                        }
//
//                        @Override
//                        public void onItemLongClick(View view, int position) {
//                        }
//                    }));
//        } else {
//            TextView tvRecommend = (TextView) findViewById(R.id.tvRecommend);
//            View viewDivider = findViewById(R.id.viewDivider);
//
//            tvRecommend.setVisibility(View.GONE);
//            viewDivider.setVisibility(View.GONE);
//            rvRecommends.setVisibility(View.GONE);
//        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_product, menu);
        return true;
    }


    /**
     * Restore last configuration.
     *
     * @param savedInstanceState: {@link Bundle}
     */
    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {

        super.onRestoreInstanceState(savedInstanceState);
        onScrollChanged(mScrollView.getCurrentScrollY(), false, false);

    }

    /**
     * Event scrolling.
     *
     * @param scrollY:     <code>int</code>
     * @param firstScroll: <code>boolean</code>
     * @param dragging:    <code>boolean</code>
     */
    @Override
    public void onScrollChanged(int scrollY, boolean firstScroll, boolean dragging) {

        updateTitleToolbar(scrollY);

    }

    @Override
    public void onDownMotionEvent() {
    }

    @Override
    public void onUpOrCancelMotionEvent(ScrollState scrollState) {
    }

    private void updateTitleToolbar(int scrollY) {

//        ActionBar actionBar = getSupportActionBar();
//
//        if (actionBar != null) {
//
//            if (scrollY >= minYScroll) {
//                actionBar.setTitle(product.getTotalMessage());
//            } else {
//                actionBar.setTitle(title);
//            }
//
//        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);

        // Checks the orientation of the screen
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

            //ivLandscape.setVisibility(View.VISIBLE);
            bannerComponent.hideBannerProductScreen(flPortrait, params, llBanner);

        } else {
            if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);

                //ivLandscape.setVisibility(View.GONE);

                params.setMargins(0, 0, 0, 60);

                flPortrait.setVisibility(View.VISIBLE);
                llBanner.setVisibility(View.VISIBLE);

                bannerComponent.setVisibility(View.VISIBLE);

            }
        }

        //ivLandscape.requestLayout();
        flPortrait.setLayoutParams(params);
        flPortrait.requestLayout();
        llBanner.requestLayout();
    }

    /**
     * Set color to status bar.
     */
    private void configStatusBarColor() {

        String topColor = UserUtils.getBackgroundColor(ProductActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);

    }

    private void execProductAction(Product product, final Action action) {

        Intent i = null;

        final int typeAction = action.getActionType();

        if (typeAction == ActionType.EMAIL_ACTION.getActionType()) {
            Intent emailIntent = new Intent(Intent.ACTION_SENDTO, Uri.fromParts(
                    "mailto", "", null));
            emailIntent.putExtra(Intent.EXTRA_SUBJECT, product.getTitle());
            emailIntent.putExtra(Intent.EXTRA_TEXT, action.getHref());
            startActivity(Intent.createChooser(emailIntent, getString(R.string.send_email)));

        } else if (typeAction == ActionType.INFO_ACTION.getActionType()) {
            i = callBrowser(action.getHref());
        } else if (typeAction == ActionType.LIKE_ACTION.getActionType()) {
            configCallSocialShare("com.facebook.katana", action);
        } else if (typeAction == ActionType.LINK_ACTION.getActionType()) {
            i = callBrowser(action.getHref());
        } else if (typeAction == ActionType.PHONE_ACTION.getActionType()) {
            i = new Intent(Intent.ACTION_CALL, Uri.parse("tel:" + action.getHref()));
        } else if (typeAction == ActionType.PRICE_ACTION.getActionType()) {

        } else if (typeAction == ActionType.TWEET_ACTION.getActionType()) {
            configCallSocialShare("com.twitter.android", action);
        } else if (typeAction == ActionType.VIDEO_ACTION.getActionType()) {
            mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), action.getId());
            //startActivity(i);
        } else if (typeAction == ActionType.ORDER_ACTION.getActionType()) {

        } else if (typeAction == ActionType.AUDIO_ACTION.getActionType()) {

        } else if (typeAction == ActionType.SURVEY_ACTION.getActionType()) {

            mAdAliveWS.callGetActionDetail(String.valueOf(AdaliveConstants.APP_ID), action.getId());

        } else if (typeAction == ActionType.PROMOTION_ACTION.getActionType()) {

        } else if (typeAction == ActionType.MASK_ACTION.getActionType()) {
            if (!action.getHref().equals("")) {

//                    i = new Intent(ProductActivity.this, MaskActivity.class);
//                    i.putExtra(ConstantsAdAlive.ACTION_MASK_ID, action.getHref());

            }
        }

        if (i != null) {

            startActivity(i);

            if (!isAutoLauncher) {
//                overridePendingTransition(R.anim.enter, R.anim.exit);
            }

        }
    }


    private Intent callBrowser(String url) {
//        Intent i = new Intent(this, WebViewActivity.class);
//        i.putExtra(ConstantsAdAlive.URL_WEBVIEW, url);
//        return i;
        return null;
    }

    //    /**
//     * Share {@link Actions} with correct social app.
//     * @param packageApp: {@link String}
//     * @param action: {@link Actions}
//     */
    private void configCallSocialShare(String packageApp, Action action) {

//        Intent intent;
//
//        if(UtilsAdAlive.appInstalledOrNot(packageApp, this)) {
//            intent = new Intent(Intent.ACTION_SEND);
//            intent.setType("text/plain");
//            intent.setPackage(packageApp);
//            intent.putExtra(Intent.EXTRA_TEXT, action.getHref());
//        } else {
//
//            StringBuilder sharerUrl = new StringBuilder();
//
//            if (packageApp.equals("com.facebook.katana")) {
//                sharerUrl.append("https://www.facebook.com/sharer/sharer.php?u=").append(action.getHref());
//            } else {
//                sharerUrl.append("https://twitter.com/intent/tweet?text=&url=").append(action.getHref());
//            }
//
//            intent = new Intent(Intent.ACTION_VIEW, Uri.parse(sharerUrl.toString()));
//        }
//
//        if (packageApp.equals("com.facebook.katana")) {
//            startActivity(Intent.createChooser(intent, getString(R.string.share_fb)));
//        } else {
//            startActivity(Intent.createChooser(intent, getString(R.string.share_tw)));
//        }

    }

    @Override
    protected void onPause() {
        super.onPause();

        if (bannerComponent != null) {

            if (bannerComponent.getHandler() != null && bannerComponent.getRunnable() != null) {
                bannerComponent.getHandler().removeCallbacks(bannerComponent.getRunnable());
            }
        }

    }

    @Override
    protected void onResume() {
        super.onResume();

        if (!isAutoLauncher) {
            execAutoLaunch();
        }
    }


    /**
     * Init AdAlive WS.
     */
    public void initAdAliveWS() {
        try {

            mAdAliveWS = new AdAliveWS(this, urlServer, userEmail);
            observe(mAdAliveWS);

        } catch (NullUrlServerException e) {

            Log.e(AdaliveConstants.ERROR, "initAdAliveWS: " + e.toString());

        }
    }


    //region Observer
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////// Observer ////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////

    /**
     * Add {@code Observable} object.
     *
     * @param o {@code Observable} object to add.
     */
    public void observe(Observable o) {

        o.addObserver(this);

    }

    /**
     * This method is called if the specified {@code Observable} object's
     * {@code notifyObservers} method is called (because the {@code Observable}
     * object has been updated.
     * The {@code AdAliveService} is the {@code Observable} object.
     *
     * @param observable the {@link Observable} object, in this case {@code String} code object recognized.
     * @param data       the data passed to {@link Observable#notifyObservers(Object)}.
     */
    @Override
    public void update(Observable observable, Object data) {


        JsonObject jsonResponse;

        if (observable instanceof AdAliveWS) {

            jsonResponse = ((AdAliveWS) observable).getJsonResponse();

            if (jsonResponse != null) {

                if (!jsonResponse.has(ConstantsAdAlive.TAG_ERRORS_SERVER)) {

                    Gson gson = new Gson();
                    Action action = gson.fromJson(jsonResponse.get(ConstantsAdAlive.TAG_ACTION), Action.class);


                    if (jsonResponse.has(ConstantsAdAlive.TAG_ACTION)) {

                        JsonObject jsonBody = jsonResponse.get(ConstantsAdAlive.TAG_ACTION).getAsJsonObject();

                        if (jsonBody.get(ConstantsAdAlive.TAG_ACTION_TYPE).getAsInt() == ActionType.INFO_ACTION.getActionType() ||
                                jsonBody.get(ConstantsAdAlive.TAG_ACTION_TYPE).getAsInt() == ActionType.LINK_ACTION.getActionType()) {
                            Intent it = new Intent(this, WebviewActivity.class);
                            it.putExtra(AdaliveConstants.TAG_ACTION_URL, action.getHref());
                            startActivity(it);

                        }else if(jsonBody.get(ConstantsAdAlive.TAG_ACTION_TYPE).getAsInt() == ActionType.VIDEO_ACTION.getActionType()){
                            Intent i = new Intent(ProductActivity.this, ExoPlayerActivity.class);
                            i.putExtra("videoUrl", action.getHref());
                            //i = ExoPlayerActivity.build(this, action.getHref());
                            startActivity(i);

                        } else {

                            try {

                                mAdAliveWS.callGetSurvey(Integer.valueOf(action.getHref()));
                                Intent it = new Intent(this, SurveyActionActivity.class);
                                it.putExtra(AdaliveConstants.TAG_SURVEY_ID, Integer.valueOf(action.getHref()));
                                it.putExtra(AdaliveConstants.TAG_ACTION_ID, action.getId());

                                startActivity(it);

                            } catch (NullTargetNameException ex) {
                                Log.v(ConstantsAdAlive.ERROR, ex.getMessage());
                            }
                        }
                    } else if (jsonResponse.has(ConstantsAdAlive.TAG_PROMO_ID)) {

                        //TODO


                    }


                } else {

                    Log.e(AdaliveConstants.ERROR, "update: " + jsonResponse.toString());

                }

            }

        }


    }
    //endregion


}
