package br.com.lab360.bioprime.logic.model.v2.realm;

import br.com.lab360.bioprime.logic.model.v2.json.JSON_Order;
import io.realm.RealmList;
import io.realm.RealmObject;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class   MA_Order extends RealmObject{


    public long      orderID;            /* Atualmente o ID do pedido é o do banco MaisAmigas e não o do AdAlive. */
    public long      digitedOrderID;
    public long      loteID;
    public boolean   change;
    public String    orderDate;          /* In case of error try to use String */
    public double    orderValue;
    public String    status;
    public String    statusDate;
    public long      couponID;
    public String    couponDescription;
    public String    rewardProductReference;
    public RealmList<MA_OrderItem> items;

    public MA_Order(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_Order(JSON_Order data) {
        setOrderID(data.getOrderID());
        setDigitedOrderID(data.getDigitedOrderID());
        setLoteID(data.getLoteID());
        setOrderDate(data.getOrderDate());
        setOrderValue(data.getOrderValue());
        setStatus(data.getStatus());
        setStatusDate(data.getStatusDate());
        setCouponID(data.getCouponID());
        setCouponDescription(data.getCouponDescription());
        setRewardProductReference(data.getRewardProductReference());
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

    public RealmList<MA_OrderItem> getItems() {
        return items;
    }

    public void setItems(RealmList<MA_OrderItem> items) {
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
