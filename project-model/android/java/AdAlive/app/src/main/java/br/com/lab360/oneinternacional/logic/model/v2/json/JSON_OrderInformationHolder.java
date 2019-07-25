package br.com.lab360.oneinternacional.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Paulo Age on 26/10/17.
 */
public class JSON_OrderInformationHolder {
        @SerializedName("order_information")
        public JSON_OrderInformation orderInformation;

        public JSON_OrderInformation getOrderInformation() {
                return orderInformation;
        }

        public void setOrderInformation(JSON_OrderInformation orderInformation) {
                this.orderInformation = orderInformation;
        }
}
