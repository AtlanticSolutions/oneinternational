package br.com.lab360.oneinternacional.logic.model.pojo.sponsor;

import com.google.gson.JsonObject;

/**
 * Created by Victor Santiago on 30/11/2016.
 */

public class SponsorsPlanResponse {

    private JsonObject sponsors;

    public SponsorsPlanResponse() {
        sponsors = new JsonObject();
    }

    public JsonObject getSponsors() { return sponsors; }
}
