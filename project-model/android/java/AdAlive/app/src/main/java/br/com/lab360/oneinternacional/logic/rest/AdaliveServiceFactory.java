package br.com.lab360.oneinternacional.logic.rest;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.concurrent.TimeUnit;

import br.com.lab360.oneinternacional.application.AdaliveConstants;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava.RxJavaCallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */

public class AdaliveServiceFactory {

    public static AdaliveApi createAdaliveService(String URL){
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);


        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(45, TimeUnit.SECONDS)
                .writeTimeout(60,TimeUnit.SECONDS)
                .readTimeout(45, TimeUnit.SECONDS)
                .addInterceptor(new HeaderInterceptor())
                .addInterceptor(interceptor)
                .build();


        Gson gson = new GsonBuilder().create();

        Retrofit.Builder retroBuilder = new Retrofit.Builder()
                .baseUrl(URL)
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client);

        return retroBuilder.build().create(AdaliveApi.class);
    }


    public static AdaliveApi createAdaliveService(){
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(45, TimeUnit.SECONDS)
                .writeTimeout(60,TimeUnit.SECONDS)
                .readTimeout(45, TimeUnit.SECONDS)
                .addInterceptor(interceptor)
                .addInterceptor(new HeaderInterceptor())
                .build();


        Gson gson = new GsonBuilder().create();

        Retrofit.Builder retroBuilder = new Retrofit.Builder()
                .baseUrl("http://viacep.com.br/")
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client);

        return retroBuilder.build().create(AdaliveApi.class);
    }


    public static AdaliveMasterServer getInitialService(){
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(45, TimeUnit.SECONDS)
                .writeTimeout(60,   TimeUnit.SECONDS)
                .readTimeout(45,    TimeUnit.SECONDS)
                .addInterceptor(interceptor)
                .addInterceptor(interceptor)
                .addInterceptor(new HeaderInterceptor())
                .build();

        Gson gson = new GsonBuilder().create();

        Retrofit.Builder retroBuilder = new Retrofit.Builder()
                .baseUrl(AdaliveConstants.ADALIVE_BASE_URL)
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client);

        return retroBuilder.build().create(AdaliveMasterServer.class);
    }
}
