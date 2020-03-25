package br.com.lab360.bioprime.logic.model.pojo.account;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public class ForgotPasswordRequest {
    private String email;

    public ForgotPasswordRequest(String email) {
        this.email = email;
    }

    public boolean validate(){
        //TODO:
        return false;
    }
}
