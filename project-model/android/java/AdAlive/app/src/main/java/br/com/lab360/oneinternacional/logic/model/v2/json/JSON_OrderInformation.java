package br.com.lab360.oneinternacional.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Paulo Age on 26/10/17.
 */

public class JSON_OrderInformation {
        public int id;

        @SerializedName("id_consultor")
        public int id_consultor;

        public String status;

        List<JSON_OrderInformationItem> itens;

        public int getId() {
                return id;
        }

        public void setId(int id) {
                this.id = id;
        }

        public int getId_consultor() {
                return id_consultor;
        }

        public void setId_consultor(int id_consultor) {
                this.id_consultor = id_consultor;
        }

        public String getStatus() {
                return status;
        }

        public void setStatus(String status) {
                this.status = status;
        }

        public List<JSON_OrderInformationItem> getItens() {
                return itens;
        }

        public void setItens(List<JSON_OrderInformationItem> itens) {
                this.itens = itens;
        }
}
