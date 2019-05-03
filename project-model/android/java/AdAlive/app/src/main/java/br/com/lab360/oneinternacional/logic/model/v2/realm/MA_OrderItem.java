package br.com.lab360.oneinternacional.logic.model.v2.realm;

import br.com.lab360.oneinternacional.logic.model.v2.json.JSON_OrderItem;
import io.realm.RealmObject;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_OrderItem extends RealmObject{


    public long   product_id;
    public long   product_reference_id;
    public long   quantity;
    public String size;
    public String name;
    public double price;
    public long   points;
    public String status;

    public MA_OrderItem(long codigoSize, long produtoId, long amount){
        this.product_reference_id = codigoSize;
        this.product_id = produtoId;
        this.quantity = amount;


    }


    public MA_OrderItem(){


    }

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_OrderItem(JSON_OrderItem data) {
        setProductID(data.getProductID());
        setProductReferenceID(data.getProductReferenceID());
        setAmount(data.getAmount());
        setSize(data.getSize());
        setName(data.getName());
        setPrice(data.getPrice());
        setPoints(data.getPoints());
        setStatus(data.getStatus());
    }

    public long getProductID() {
        return product_id;
    }

    public long getProductReferenceID() {
        return product_reference_id;
    }

    public long getAmount() {
        return quantity;
    }

    public String getSize() {
        return size;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public long getPoints() {
        return points;
    }

    public String getStatus() {
        return status;
    }

    public void setProductID(long productID) {
        this.product_id = productID;
    }

    public void setProductReferenceID(long productReferenceID) {
        this.product_reference_id = productReferenceID;
    }

    public void setAmount(long amount) {
        this.quantity = amount;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public void setPoints(long points) {
        this.points = points;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
