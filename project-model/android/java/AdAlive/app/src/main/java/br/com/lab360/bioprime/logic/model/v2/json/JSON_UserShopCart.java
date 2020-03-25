package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_UserShopCart;

/**
 * Created by Paulo Age on 23/10/17.
 */

public class JSON_UserShopCart {
    @SerializedName("user_shop_id")
    public long     userID;
    public JSON_Order order;

    public JSON_UserShopCart(MA_UserShopCart data) {
        setUserID(data.getUserID());
        
        setOrder(new JSON_Order(data.getOrder()));
    }

    public long getUserID() {
        return userID;
    }

    public void setUserID(long userID) {
        this.userID = userID;
    }

    public JSON_Order getOrder() {
        return order;
    }

    public void setOrder(JSON_Order order) {
        this.order = order;
    }
}
