package br.com.lab360.bioprime.logic.model.v2.json;

import java.util.List;

/**
 * Created by paulo on 25/10/2017.
 */

public class JSON_CatalogList {
    public List<JSON_Catalog> catalogs;

    public List<JSON_Catalog> getCatalogs() {
        return catalogs;
    }

    public void setCatalogs(List<JSON_Catalog> catalogs) {
        this.catalogs = catalogs;
    }
}
