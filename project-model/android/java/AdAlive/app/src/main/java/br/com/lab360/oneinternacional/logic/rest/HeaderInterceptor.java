package br.com.lab360.oneinternacional.logic.rest;

import android.util.Log;

import java.io.IOException;

import br.com.lab360.oneinternacional.BuildConfig;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public class HeaderInterceptor implements Interceptor {
    @Override
    public Response intercept(Chain chain) {

        Request original = chain.request();

        // Request customization: add request headers
        Request.Builder requestBuilder = original.newBuilder()
                .addHeader(AdaliveConstants.ACCEPT, AdaliveConstants.APPLICATION_JSON)
                .addHeader(AdaliveConstants.XAPPID, BuildConfig.APP_ID)
                .addHeader(AdaliveConstants.CONTENT_TYPE, AdaliveConstants.APPLICATION_JSON_CHARSET_UTF_8);


        Request request = requestBuilder.build();
        try {
            return chain.proceed(request);
        } catch (IOException e) {
            Log.d("TIMEOUT====>", "Time out here !!! " + e.toString());
            e.printStackTrace();
            return null;
        }
    }
}
