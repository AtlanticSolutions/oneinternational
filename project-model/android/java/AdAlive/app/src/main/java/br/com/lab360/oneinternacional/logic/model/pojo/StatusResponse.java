package br.com.lab360.oneinternacional.logic.model.pojo;

import java.util.ArrayList;

/**
 * Created by Alessandro Valenza on 22/11/2016.
 */
public class StatusResponse {
    private String message;
    private ArrayList<BaseError> errors;

    public String getMessage() {
        return message;
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