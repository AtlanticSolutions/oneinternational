package br.com.lab360.oneinternacional.logic.model.pojo.chat;

/**
 * Created by Alessandro Valenza on 10/11/2016.
 */

public class FcmResponseObject {
    private String status;
    private String tipoErro;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTipoErro() {
        return tipoErro;
    }

    public void setTipoErro(String tipoErro) {
        this.tipoErro = tipoErro;
    }
}
