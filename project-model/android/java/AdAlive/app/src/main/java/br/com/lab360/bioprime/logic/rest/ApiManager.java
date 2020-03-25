package br.com.lab360.bioprime.logic.rest;

import android.content.Context;

import com.google.common.base.Strings;

import br.com.lab360.bioprime.utils.MasterServerUtils;

public class ApiManager {
    private static final ApiManager ourInstance = new ApiManager();

    public static ApiManager getInstance() {
        return ourInstance;
    }

    private ApiManager() {
    }

    public AdaliveApi getAdaliveApiInstance(Context context) {
        return AdaliveServiceFactory.createAdaliveService(getUrlAdaliveApi(context));
    }

    public AmazonApi getAmazonApiInstance(Context context) {
        return AmazonServiceFactory.createAmazonService(getUrlAmazonApi(context));
    }

    public ChatApi getChatApiInstance(Context context) {
        return ChatServiceFactory.createChatService(getUrlAdaliveChatApi(context));
    }

    public void setAdaliveApi(String url, Context context) {
        if (!Strings.isNullOrEmpty(url)) {
            MasterServerUtils.saveUrlAdaliveApi(context, url);
            getAdaliveApiInstance(context);
        }
    }

    public void setAmazonApi(String url, Context context) {
        if (!Strings.isNullOrEmpty(url)) {
            MasterServerUtils.saveUrlAmazonApi(context, url);
            getAmazonApiInstance(context);
        }
    }

    public void setAdaliveChatApi(String url, Context context) {
        if (!Strings.isNullOrEmpty(url)) {
            MasterServerUtils.saveUrlChatApi(context, url);
            getChatApiInstance(context);
        }
    }

    public String getUrlAdaliveApi(Context context){
        return  MasterServerUtils.getUrlAdaliveApi(context);
    }

    public String getUrlAmazonApi(Context context){
        return  MasterServerUtils.getUrlAmazonApi(context);
    }

    public String getUrlAdaliveChatApi(Context context){
        return  MasterServerUtils.getUrlChatApi(context);
    }
}
