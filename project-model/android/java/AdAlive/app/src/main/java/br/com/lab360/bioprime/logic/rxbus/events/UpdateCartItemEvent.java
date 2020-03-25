package br.com.lab360.bioprime.logic.rxbus.events;

/**
 * Created by Paulo Roberto
 */
public class UpdateCartItemEvent {

    private int mAmount;
    private int mOrderItemID;
    private double mPrice;

    public UpdateCartItemEvent(int orderItemID,  int amount, double price) {
        this.mOrderItemID = orderItemID;
        this.mAmount = amount;
        this.mPrice = price;
    }

    public int getmAmount() {
        return mAmount;
    }

    public int getmOrderItemID() {
        return mOrderItemID;
    }

    public double getmPrice() {
        return mPrice;
    }
}
