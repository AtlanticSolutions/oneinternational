package br.com.lab360.bioprime.ui.fragments.sponsors;

import android.os.Build;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.sponsor.Sponsor;
import br.com.lab360.bioprime.logic.presenter.sponsors.SponsorDetailPresenter;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorDetailFragment extends Fragment implements SponsorDetailPresenter.ISponsorDetailView {

    public static final String SPONSOR = "SPONSOR";
    @BindView(R.id.wv_sponsor)
    protected WebView wvSponsor;
    @BindView(R.id.container_loading)
    protected LinearLayout containerLoading;

    private SponsorDetailPresenter mPresenter;

    Sponsor mSponsor = null;

    public static SponsorDetailFragment newInstance(Sponsor sponsor) {

        SponsorDetailFragment sponsorDetailFragment = new SponsorDetailFragment();
        Bundle bundle = new Bundle();
        bundle.putParcelable(SPONSOR, sponsor);
        sponsorDetailFragment.setArguments(bundle);

        return sponsorDetailFragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle bundle = getArguments();

        if (bundle != null) {

            mSponsor = bundle.getParcelable(SPONSOR);
            mSponsor = mSponsor == null ? new Sponsor() : mSponsor;

        }

        mPresenter = new SponsorDetailPresenter(this, mSponsor);

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_sponsor_detail, container, false);
        ButterKnife.bind(this, view);

        if (mPresenter != null) {
            mPresenter.start();
        }

        return view;

    }

    @Override
    public void setPresenter(SponsorDetailPresenter presenter) {
        mPresenter = presenter;
    }

    @Override
    public void configWebView(String urlSponsorPage) {

        final WebSettings settings = wvSponsor.getSettings();

        settings.setJavaScriptEnabled(true);
        settings.setAppCacheEnabled(true);
        settings.setDomStorageEnabled(true);
        settings.setLoadsImagesAutomatically(true);
        settings.setDatabaseEnabled(true);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        wvSponsor.clearCache(true);
        wvSponsor.clearHistory();
        wvSponsor.loadUrl(urlSponsorPage);

        wvSponsor.getSettings().setRenderPriority(WebSettings.RenderPriority.HIGH);
        wvSponsor.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);

        wvSponsor.setWebViewClient(new MyWebClient());

        if (Build.VERSION.SDK_INT >= 11) {

            wvSponsor.setLayerType(View.LAYER_TYPE_SOFTWARE, null);

        } else if (Build.VERSION.SDK_INT >= 19) {

            wvSponsor.setLayerType(View.LAYER_TYPE_HARDWARE, null);

        }

    }

    @Override
    public void removeLoadingDialog() {

        containerLoading.setVisibility(View.GONE);
        wvSponsor.setVisibility(View.VISIBLE);

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

            removeLoadingDialog();

        }

        @Override
        public void onReceivedError(WebView view, int errorCode,
                                    String description, String failingUrl) {

            super.onReceivedError(view, errorCode, description, failingUrl);
            removeLoadingDialog();
            Log.e(AdaliveConstants.ERROR,
                    "****Error: " + description + " code: " + errorCode);

        }
    }

}
