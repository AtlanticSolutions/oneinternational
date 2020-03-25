package br.com.lab360.bioprime.logic.model.v2.json;

import com.google.gson.annotations.SerializedName;

import br.com.lab360.bioprime.logic.model.v2.realm.MA_Category;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class JSON_Category {
    @SerializedName("id")
    public int    id;

    @SerializedName("catalog_id")
    public int    catalogId;

    @SerializedName("name")
    public String name;

    /**
     * Translate from REALM to JSON
     *
     * @param data A valid REALM
     */
    public JSON_Category(MA_Category data){
        setId(data.getId());
        setCatalogId(data.getCatalogId());
        setName(data.getName());
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCatalogId() {
        return catalogId;
    }

    public void setCatalogId(int catalogId) {
        this.catalogId = catalogId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
