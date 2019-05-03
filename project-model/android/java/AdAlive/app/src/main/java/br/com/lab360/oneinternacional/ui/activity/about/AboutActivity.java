package br.com.lab360.oneinternacional.ui.activity.about;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import android.widget.Toast;

import com.google.common.base.Strings;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.AboutInteractor;
import br.com.lab360.oneinternacional.logic.model.pojo.about.About;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class AboutActivity extends BaseActivity implements AboutInteractor.AboutInteractorListener {

    @BindView(R.id.wvNavigation)
    WebView wvNavigation;

    @BindView(R.id.txtVersion)
    protected TextView mTxtVersion;


    private String urlWeb;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);

        ButterKnife.bind(this);

        final WebSettings settings = wvNavigation.getSettings();

        settings.setJavaScriptEnabled(true);
        settings.setAppCacheEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setLoadsImagesAutomatically(true);
        settings.setDatabaseEnabled(true);


        showProgress();

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        urlWeb = getIntent().getStringExtra(AdaliveConstants.TAG_ACTION_URL);

        wvNavigation.clearCache(true);
        wvNavigation.clearHistory();
        wvNavigation.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        wvNavigation.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        wvNavigation.addJavascriptInterface(new WebAppInterface(this), "lab360");

        if (Build.VERSION.SDK_INT >= 11) {

            wvNavigation.setLayerType(View.LAYER_TYPE_SOFTWARE, null);

        } else if (Build.VERSION.SDK_INT >= 19) {

            wvNavigation.setLayerType(View.LAYER_TYPE_HARDWARE, null);

        }

        wvNavigation.setWebViewClient(new MyWebClient());

//        wvNavigation.setWebChromeClient(new WebChromeClient() {
//
//            @Override
//            public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
//                return super.onConsoleMessage(consoleMessage);
//            }
//
//            @Override
//            public boolean onCreateWindow(WebView view, boolean isDialog, boolean isUserGesture, Message resultMsg) {
//                return super.onCreateWindow(view, isDialog, isUserGesture, resultMsg);
//            }
//        });


        //wvNavigation.loadUrl(urlWeb);

        mTxtVersion.setBackgroundColor(Color.parseColor(UserUtils.getBackgroundColor(this)));
        initToolbar();
        configStatusBarColor();
        configureData();

        getAboutData();
    }

    private void getAboutData() {
        AboutInteractor interactor = new AboutInteractor(this);
        interactor.getAbout(AdaliveConstants.APP_ID, this);
    }

    private void configureData() {
        try {
            PackageInfo pInfo = this.getPackageManager().getPackageInfo(getPackageName(), 0);
            String version = pInfo.versionName;
            mTxtVersion.setText("Versão: " + version);
        } catch (PackageManager.NameNotFoundException e) {
            Log.e("ERRO", ""+e);
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

        if (getIntent().hasExtra(AdaliveConstants.TAG_ACTION_WEBVIEW_TITLE)){
            String title = getIntent().getStringExtra(AdaliveConstants.TAG_ACTION_WEBVIEW_TITLE);
            getSupportActionBar().setTitle(title);
        }else {
            getSupportActionBar().setTitle(R.string.SCREEN_TITLE_ABOUT);
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
        String topColor = UserUtils.getBackgroundColor(AboutActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);
    }

    @Override
    public void onAboutSuccess(final About about) {
        hideProgress();
        AboutActivity.this.wvNavigation.loadUrl(about.getUrl());
        infoDialog(about.getTitle(), about.getMessage(), null);
    }

    @Override
    public void onAboutFailure() {
        hideProgress();
        errorDialog("Erro", getString(R.string.ERROR_ALERT_MESSAGE_NETWORK_REQUEST), new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AboutActivity.this.finish();
            }
        });
    }


    private class MyWebClient extends WebViewClient {


//        @Override
//        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
//
//
//            Log.v("Log", request.toString());
//
//            return super.shouldOverrideUrlLoading(view, request);
//        }

        @SuppressWarnings("deprecation")
        @Override
        public boolean shouldOverrideUrlLoading(WebView view,
                                                String urlNewString) {
            view.loadUrl(urlNewString);
            return true;

        }


        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {

            return super.shouldInterceptRequest(view, request);
        }

        @Override
        public void onPageFinished(WebView view, String url) {

            hideProgress();

        }

        @Override
        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
            super.onReceivedError(view, request, error);

            Log.e(AdaliveConstants.ERROR,
                    "****Error: " + error.toString());
            //            removeLoadingDialog();
        }

    }

    public class WebAppInterface {
        Context mContext;

        /** Instantiate the interface and set the context */
        WebAppInterface(Context c) {
            mContext = c;
        }

        /** Show a toast from the web page */
        @JavascriptInterface
        public void showLocalMessage(String toast) {
            Toast.makeText(mContext, toast, Toast.LENGTH_SHORT).show();
        }
    }
}
