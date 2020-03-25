package br.com.lab360.bioprime.logic.rest;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.adapter.rxjava.RxJavaCallAdapterFactory;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */

public class ChatServiceFactory {
//    public static ChatApi createChatService(){
//        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
//        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
//
//        OkHttpClient client = new OkHttpClient.Builder()
//                .connectTimeout(45, TimeUnit.SECONDS)
//                .writeTimeout(60,TimeUnit.SECONDS)
//                .readTimeout(45, TimeUnit.SECONDS)
//                .addInterceptor(interceptor)
//                .build();
//
//        Gson gson = new GsonBuilder().create();
//
//        Retrofit.Builder retroBuilder = new Retrofit.Builder()
//                .addConverterFactory(GsonConverterFactory.create(gson))
//                .baseUrl(AdaliveApplication.getUrlChatAdaliveApi())
//                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
//                .client(client);
//
//        return retroBuilder.build().create(ChatApi.class);
//    }

    public static ChatApi createChatService(String url){
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(45, TimeUnit.SECONDS)
                .writeTimeout(60,TimeUnit.SECONDS)
                .readTimeout(45, TimeUnit.SECONDS)
                .addInterceptor(interceptor)
                .build();

        Gson gson = new GsonBuilder().create();

        Retrofit.Builder retroBuilder = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create(gson))
                .baseUrl(url)
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .client(client);

        return retroBuilder.build().create(ChatApi.class);
    }

}
