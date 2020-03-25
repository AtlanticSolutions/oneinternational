package br.com.lab360.bioprime.logic.adalive;

import com.google.gson.annotations.SerializedName;
import java.util.ArrayList;
import java.util.List;

public class Metadata {
    @SerializedName("buttons")
    private List<ButtonAR> buttons = new ArrayList();

    public Metadata() {
    }

    public List<ButtonAR> getButtons() {
        return (List)(this.buttons == null ? new ArrayList() : this.buttons);
    }

    public void setButtons(List<ButtonAR> buttons) {
        this.buttons = buttons;
    }
}
