package br.com.lab360.bioprime.logic.model.pojo.managerApplication;

import org.simpleframework.xml.ElementList;

import java.util.List;

/**
 * Created by Edson on 28/06/2018.
 */
public class ManagerApplicationResponse {

    @ElementList(entry = "application", inline = true)
    List<ManagerApplication> managerApplications;

    public List<ManagerApplication> getManagerApplications() {
        return managerApplications;
    }

    public void setManagerApplications(List<ManagerApplication> managerApplications) {
        this.managerApplications = managerApplications;
    }

}
