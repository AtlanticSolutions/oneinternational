package br.com.lab360.oneinternacional.logic.model.pojo.sponsor;

import com.google.gson.JsonArray;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsResponse {
    private JsonArray sponsors;

    public SponsorsResponse() {
        sponsors = new JsonArray();
    }

    public JsonArray getSponsors() { return sponsors; }
}
