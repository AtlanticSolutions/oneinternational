package br.com.lab360.oneinternacional.utils;

/**
 * Created by virginia on 23/10/2017.
 */

public enum  EnumPaymentType {

    BOLETO(0),CARTAO_CONSULTORA(1),CARTAO_CREDITO(2);

    private int type;

    EnumPaymentType(int type){
        this.type = type;
    }

    public int getType(){
        return type;
    }
}
