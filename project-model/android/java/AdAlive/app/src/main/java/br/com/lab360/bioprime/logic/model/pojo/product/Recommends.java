package br.com.lab360.bioprime.logic.model.pojo.product;

import java.io.Serializable;

/**
 * Created by Victor on 24/08/2015.
 * Represents recommends object for the {@link Product}
 * @see {@link Product}
 * @see {@link Recommends}
 */
public class Recommends implements Serializable {

    private static final long serialVersionUID = -3253601991119229565L;

    private int id;
    private String image_url;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImageUrl() {
        return image_url;
    }

    public void setImageUrl(String image_url) {
        this.image_url = image_url;
    }
}
