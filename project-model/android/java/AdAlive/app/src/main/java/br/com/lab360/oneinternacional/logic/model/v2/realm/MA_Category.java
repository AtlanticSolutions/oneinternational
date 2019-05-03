package br.com.lab360.oneinternacional.logic.model.v2.realm;

import br.com.lab360.oneinternacional.logic.model.v2.json.JSON_Category;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by Paulo Age on 23/10/17.
 */
public class MA_Category extends RealmObject{
    @PrimaryKey
    public int    id;
    public int    catalogId;
    public String name;


    public MA_Category(){}

    /**
     * Translate from JSON to REALM
     *
     * @param data A valid JSON
     */
    public MA_Category(JSON_Category data) {
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
