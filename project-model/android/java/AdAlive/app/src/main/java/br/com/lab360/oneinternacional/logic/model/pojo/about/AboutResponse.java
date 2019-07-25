package br.com.lab360.oneinternacional.logic.model.pojo.about;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class AboutResponse {

    @SerializedName("abouts")
    @Expose
    private List<About> abouts = null;

    public List<About> getAbouts() {
        return abouts;
    }

    public void setAbouts(List<About> abouts) {
        this.abouts = abouts;
    }
}
