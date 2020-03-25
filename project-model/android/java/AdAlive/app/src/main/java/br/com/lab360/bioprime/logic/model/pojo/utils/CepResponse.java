package br.com.lab360.bioprime.logic.model.pojo.utils;

/**
 * Created by virginia on 10/11/2017.
 */

public class CepResponse {

    private String cep, logradouro, complemento, bairro, localidade, uf, unidade, ibge, gia;

    private boolean erro;

    public String getCep() {
        return cep;
    }

    public String getLogradouro() {
        return logradouro;
    }

    public String getComplemento() {
        return complemento;
    }

    public String getBairro() {
        return bairro;
    }

    public String getLocalidade() {
        return localidade;
    }

    public String getUf() {
        return uf;
    }

    public String getUnidade() {
        return unidade;
    }

    public String getIbge() {
        return ibge;
    }

    public String getGia() {
        return gia;
    }

    public boolean isErro() {
        return erro;
    }
}
