package br.com.lab360.oneinternacional.logic.model.pojo;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public class StatusResponse {
    @SerializedName("success")
    private boolean success;
    @SerializedName("message")
    private String message;
    private ArrayList<BaseError> errors;

    public String getMessage() {
        return message;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public BaseError hasErrors() {
        if(errors != null && errors.size() > 0)
            return errors.get(0);
        return null;
    }

    public class BaseError{
        private int id;
        private String status;
        private String title;

        public int getId() {
            return id;
        }

        public String getStatus() {
            return status;
        }

        public String getTitle() {
            return title;
        }
    }
}