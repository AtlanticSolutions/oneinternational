package br.com.lab360.bioprime.logic.model.pojo.managerApplication;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

/**
 * Created by Edson on 28/06/2018.
 */
@Root(name="application")
public class ManagerApplication {

    @Element(name = "id")
    protected String id;
    @Element(name = "nameApp")
    private String nameApp;
    @Element(name = "versionApp")
    private String versionApp;
    @Element(name = "urlApp")
    private String urlApp;
    @Element(name = "buildApp")
    private String buildApp;
    @Element(name = "urlIconApp")
    private String urlIconApp;
    @Element(name = "descriptionApp")
    private String descriptionApp;

    public String getId () {
        return id;
    }

    public void setId (String id) {
        this.id = id;
    }

    public String getNameApp () {
        return nameApp;
    }

    public void setNameApp (String nameApp) {
        this.nameApp = nameApp;
    }

    public String getVersionApp () {
        return versionApp;
    }

    public void setVersionApp (String versionApp) {
        this.versionApp = versionApp;
    }

    public String getUrlApp () {
        return urlApp;
    }

    public void setUrlApp (String urlApp) {
        this.urlApp = urlApp;
    }

    public String getBuildApp () {
        return buildApp;
    }

    public void setBuildApp (String buildApp) {
        this.buildApp = buildApp;
    }

    public String getUrlIconApp () {
        return urlIconApp;
    }

    public void setUrlIconApp (String urlIconApp) {
        this.urlIconApp = urlIconApp;
    }

    public String getDescriptionApp () {
        return descriptionApp;
    }

    public void setDescriptionApp (String descriptionApp) {
        this.descriptionApp = descriptionApp;
    }
}
