package br.com.lab360.bioprime.ui.activity.sponsors;

import br.com.lab360.bioprime.logic.model.pojo.sponsor.Sponsor;

/**
 * Created by Paulo santos on 04/09/2017.
 */

public class SectionOrRow {

    private Sponsor row;
    private String section;
    private boolean isRow;

    public static SectionOrRow createRow(Sponsor sponsor) {
        SectionOrRow ret = new SectionOrRow();
        ret.row = sponsor;
        ret.isRow = true;
        return ret;
    }

    public static SectionOrRow createSection(String section) {
        SectionOrRow ret = new SectionOrRow();
        ret.section = section;
        ret.isRow = false;
        return ret;
    }

    public Sponsor getRow() {
        return row;
    }

    public String getSection() {
        return section;
    }

    public boolean isRow() {
        return isRow;
    }
}