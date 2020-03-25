package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_Order;
import br.com.lab360.bioprime.logic.model.v2.realm.MA_OrderItem;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class JSON_Order {
    @SerializedName("id")
    public long      orderID;            /* Atualmente o ID do pedido é o do banco MaisAmigas e não o do AdAlive. */

    @SerializedName("idPedidoDigitado")
    public long      digitedOrderID;

    @SerializedName("idLote")
    public long      loteID;

    @SerializedName("alterar")
    public boolean   change;

    @SerializedName("dataPedido")
    public String    orderDate;          /* In case of error try to use String */

    @SerializedName("valor")
    public double    orderValue;

    @SerializedName("status")
    public String    status;

    @SerializedName("dataStatus")
    public String    statusDate;

    @SerializedName("coupon_id")
    public long      couponID;

    @SerializedName("coupon_description")
    public String    couponDescription;

    @SerializedName("product_reference")
    public String    rewardProductReference;

    @SerializedName("items")
    public List<JSON_OrderItem> items;

    /**
     * Translate from REALM to JSON
     *
     * @param data A valid REALM
     */
    public JSON_Order(MA_Order data) {
        items = new ArrayList<JSON_OrderItem>();

        setOrderID(data.getOrderID());
        setDigitedOrderID(data.getDigitedOrderID());
        setLoteID(data.getLoteID());
        setChange(data.isChange());
        setOrderDate(data.getOrderDate());
        setOrderValue(data.getOrderValue());
        setStatus(data.getStatus());
        setOrderDate(data.getStatusDate());
        setCouponID(data.getCouponID());
        setCouponDescription(data.getCouponDescription());
        setRewardProductReference(data.getRewardProductReference());

        if (data.getItems() != null) {
            for (MA_OrderItem i : data.getItems()) {
                items.add(new JSON_OrderItem(i));
            }
        }
    }

    public long getOrderID() {
        return orderID;
    }

    public void setOrderID(long orderID) {
        this.orderID = orderID;
    }

    public long getDigitedOrderID() {
        return digitedOrderID;
    }

    public void setDigitedOrderID(long digitedOrderID) {
        this.digitedOrderID = digitedOrderID;
    }

    public long getLoteID() {
        return loteID;
    }

    public void setLoteID(long loteID) {
        this.loteID = loteID;
    }

    public boolean isChange() {
        return change;
    }

    public void setChange(boolean change) {
        this.change = change;
    }

    public double getOrderValue() {
        return orderValue;
    }

    public void setOrderValue(double orderValue) {
        this.orderValue = orderValue;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getCouponID() {
        return couponID;
    }

    public void setCouponID(long couponID) {
        this.couponID = couponID;
    }

    public String getCouponDescription() {
        return couponDescription;
    }

    public void setCouponDescription(String couponDescription) {
        this.couponDescription = couponDescription;
    }

    public String getRewardProductReference() {
        return rewardProductReference;
    }

    public void setRewardProductReference(String rewardProductReference) {
        this.rewardProductReference = rewardProductReference;
    }

    public List<JSON_OrderItem> getItems() {
        return items;
    }

    public void setItems(List<JSON_OrderItem> items) {
        this.items = items;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatusDate() {
        return statusDate;
    }

    public void setStatusDate(String statusDate) {
        this.statusDate = statusDate;
    }
}
