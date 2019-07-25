package br.com.lab360.oneinternacional.utils;

/**
 * Created by Eu on 20/10/2017.
 */

public enum EnumPreferencesCategory {

    LOGIN_CATEGORY("LOGIN_CATEGORY");

    private String categoryType;

    EnumPreferencesCategory(String categoryType){
        this.categoryType = categoryType;
    }

    public String getCategoryType(){
        return categoryType;
    }

}
