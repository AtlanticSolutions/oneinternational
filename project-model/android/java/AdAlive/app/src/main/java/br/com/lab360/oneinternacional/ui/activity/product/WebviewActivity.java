package br.com.lab360.oneinternacional.ui.activity.product;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;

import com.google.common.base.Strings;
import com.google.gson.Gson;

import androidx.drawerlayout.widget.DrawerLayout;
import androidx.recyclerview.widget.RecyclerView;
import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.ui.activity.NavigationDrawerActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class WebviewActivity extends NavigationDrawerActivity{

    @BindView(R.id.wvNavigation)
    WebView wvNavigation;

    @BindView(R.id.container_loading)
    protected LinearLayout mContainerLoading;

    @BindView(R.id.rvMenu)
    protected RecyclerView rvMenu;
    //region Bind - Layouts
    @BindView(R.id.drawer_layout)
    protected DrawerLayout drawer;


    private String urlWeb;


    private static Gson gson;
    private static SharedPrefsHelper sharedPrefsHelper;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview_home);

        ButterKnife.bind(this);


        gson = new Gson();
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();

        final WebSettings settings = wvNavigation.getSettings();

        settings.setJavaScriptEnabled(true);
        settings.setAppCacheEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setLoadsImagesAutomatically(true);
        settings.setDatabaseEnabled(true);


        mContainerLoading.setVisibility(View.VISIBLE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        urlWeb = getIntent().getStringExtra(AdaliveConstants.TAG_ACTION_URL);

        wvNavigation.clearCache(true);
        wvNavigation.clearHistory();
        wvNavigation.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        wvNavigation.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);


        if (Build.VERSION.SDK_INT >= 11) {

            wvNavigation.setLayerType(View.LAYER_TYPE_SOFTWARE, null);

        } else if (Build.VERSION.SDK_INT >= 19) {

            wvNavigation.setLayerType(View.LAYER_TYPE_HARDWARE, null);

        }


        wvNavigation.loadUrl(urlWeb);
        wvNavigation.setWebViewClient(new MyWebClient());
        
        initToolbar();
        configStatusBarColor();
    }


    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        //getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        /*toolbar.setNavigationOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                onBackPressed();
            }

        });*/

        if (getIntent().hasExtra(AdaliveConstants.TAG_ACTION_WEBVIEW_TITLE)){
            String title = getIntent().getStringExtra(AdaliveConstants.TAG_ACTION_WEBVIEW_TITLE);
            getSupportActionBar().setTitle(title);
        }

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    /**
     * Set color to status bar.
     */
    private void configStatusBarColor() {
        String topColor = UserUtils.getBackgroundColor(WebviewActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);
    }

    final class MyWebChromeClient extends WebChromeClient {
        @Override
        public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
            Log.d("LogTag", message);
            result.confirm();
            return true;
        }
    }


    private class MyWebClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view,
                                                String urlNewString) {
            view.loadUrl(urlNewString);
            return true;

        }

        @Override
        public void onPageFinished(WebView view, String url) {

            mContainerLoading.setVisibility(View.GONE);

        }

        @Override
        public void onReceivedError(WebView view, int errorCode,
                                    String description, String failingUrl) {

            super.onReceivedError(view, errorCode, description, failingUrl);
//            removeLoadingDialog();
            Log.e(AdaliveConstants.ERROR,
                    "****Error: " + description + " code: " + errorCode);

        }


    }


}
