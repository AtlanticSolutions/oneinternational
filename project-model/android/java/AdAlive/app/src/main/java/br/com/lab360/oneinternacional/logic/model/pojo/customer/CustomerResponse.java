package br.com.lab360.oneinternacional.logic.model.pojo.customer;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.Erro;

/**
 * Created by virginia on 16/11/2017.
 */

public class CustomerResponse {

    @SerializedName("customer")
    @Expose
    private CustomerResponseDetail customer;

    @SerializedName("email_conflict")
    @Expose
    private ArrayList<String> emailConflicts;

    private String status;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Erro getError() {
        return error;
    }

    public void setError(Erro error) {
        this.error = error;
    }

    private Erro error;

    public CustomerResponseDetail getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerResponseDetail customer) {
        this.customer = customer;
    }

    public ArrayList<String> getEmailConflicts() {
        return emailConflicts;
    }

    public void setEmailConflicts(ArrayList<String> emailConflicts) {
        this.emailConflicts = emailConflicts;
    }
}
