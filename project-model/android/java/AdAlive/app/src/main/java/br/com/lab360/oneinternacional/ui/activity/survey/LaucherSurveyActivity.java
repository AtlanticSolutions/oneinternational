package br.com.lab360.oneinternacional.ui.activity.survey;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.Observable;
import java.util.Observer;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.product.ProductLocal;
import br.com.lab360.oneinternacional.logic.rest.ApiManager;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.activity.product.ProductActivity;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import lib.error.NullTargetNameException;
import lib.error.NullUrlServerException;
import lib.ui.AdAliveWS;
import lib.utils.ConstantsAdAlive;


public class LaucherSurveyActivity  extends BaseActivity implements Observer {

    private AdAliveWS mAdAliveWS;

    private String urlServer;
    private String userEmail;
    private String targetName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_laucher_survey);

        urlServer = ApiManager.getInstance().getUrlAdaliveApi(this);
        userEmail = AdaliveApplication.getInstance().getUser().getEmail();

        targetName = getIntent().getStringExtra(AdaliveConstants.INTENT_TAG_DIRECT_SURVEY);

        configStatusBarColor();

        initAdAliveWS();

    }

    /**
     * Init AdAlive WS.
     */
    public void initAdAliveWS() {
        try {

            if (this.isOnline()) {

                mAdAliveWS = new AdAliveWS(this, urlServer, userEmail);

                observe(mAdAliveWS);

                if (!Strings.isNullOrEmpty(targetName)) {

                    try {
                        mAdAliveWS.callFindProductByTargetName(String.valueOf(AdaliveConstants.APP_ID), targetName);
                    } catch (NullTargetNameException e) {
                        Log.e(AdaliveConstants.ERROR, "update: " + e);
                    }

                } else {

                    errorDialog(getString(R.string.DIALOG_TITLE_ERROR), "Não há pesquisas cadastradas", null);
                }

            } else {

                new androidx.appcompat.app.AlertDialog.Builder(LaucherSurveyActivity.this)
                        .setTitle(getString(R.string.DIALOG_INTERNET_TITLE))
                        .setMessage(getString(R.string.DIALOG_INTERNET_MESSAGE))
                        .setPositiveButton(getString(R.string.DIALOG_INTERNET_POSITIVE_BUTTON), new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialogInterface, int i) {
                                finish();
                            }
                        })
                        .create()
                        .show();
            }

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

        if  (observable instanceof AdAliveWS) {

            jsonResponse = ((AdAliveWS) observable).getJsonResponse();

            if (jsonResponse != null) {

                if (!jsonResponse.has(ConstantsAdAlive.TAG_ERRORS_SERVER)) {

                    if (jsonResponse.has(ConstantsAdAlive.TAG_ACTION)) {
                        //procJsonActionsV2(jsonResponse);
                    } else {
                        procJsonProductV2(jsonResponse);
                    }

                } else {

                    Log.e(AdaliveConstants.ERROR, "update: " + jsonResponse.toString());

                }

            }

        }

    }
    //endregion

    /**
     * Sample how mapping and identification products.
     *
     * @param jsonResponse server json response.
     */
    private void procJsonProductV2(JsonObject jsonResponse) {

        Gson gson = new Gson();
        ProductLocal product = gson.fromJson(jsonResponse.get(ConstantsAdAlive.TAG_PRODUCT), ProductLocal.class);

        if (product != null) {

            Intent it = new Intent(this, ProductActivity.class);

            AdaliveApplication.getInstance().setProduct(product);
            it.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            startActivity(it);

            finish();

        }
    }

    /**
     * Set color to status bar.
     */
    private void configStatusBarColor() {

        String topColor = UserUtils.getBackgroundColor(LaucherSurveyActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);

    }
}
