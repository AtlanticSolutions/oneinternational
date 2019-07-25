package br.com.lab360.oneinternacional.logic.model.v2.realm;

import br.com.lab360.oneinternacional.logic.model.v2.json.JSON_UserShopCart;
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_UserShopCart extends RealmObject{

    @PrimaryKey
    public long     userID;
    public RealmList<MA_Order> order;

    public MA_UserShopCart(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_UserShopCart(JSON_UserShopCart data) {
        setUserID(data.getUserID());
    }

    public long getUserID() {
        return userID;
    }

    public void setUserID(long userID) {
        this.userID = userID;
    }

    public MA_Order getOrder() {
        if (this.order != null) {
            /* Prevent -1 request */
            if (this.order.size() == 0)
                return this.order.get(0);
            else
                return this.order.get(this.order.size() - 1);
        }

        return null;
    }

    public void setOrder(MA_Order data) {
        if (this.order != null) {
            this.order.add(data);
        } else {
            this.order = new RealmList<>();
            this.order.add(data);
        }
    }
}
