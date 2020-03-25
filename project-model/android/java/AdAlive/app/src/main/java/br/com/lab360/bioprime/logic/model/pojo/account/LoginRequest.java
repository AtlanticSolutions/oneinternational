package br.com.lab360.bioprime.logic.model.pojo.account;

import androidx.annotation.IntDef;
import android.text.TextUtils;

import com.google.gson.annotations.SerializedName;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */
public class LoginRequest {

    @SerializedName("email")
    private String email;
    private String password;
    private String role;


    @SerializedName("master_event_id")
    private int masterEventId;

    public LoginRequest(String email, String password, String role, int masterEventId) {
        this.email = email;
        this.password = password;
        this.masterEventId = masterEventId;
        this.role = role;
    }




    public ArrayList<Integer> validate() {
        ArrayList<Integer> wrongFields = new ArrayList<>();

        if(TextUtils.isEmpty(email)){
            wrongFields.add(FieldType.EMAIL);
        }
        if(TextUtils.isEmpty(password)){
            wrongFields.add(FieldType.PASSWORD);
        }

        return wrongFields.size() > 0 ? wrongFields : null;
    }

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({FieldType.EMAIL, FieldType.PASSWORD})
    public @interface FieldType{
        int EMAIL = 1;
        int PASSWORD = 2;
    }
}
