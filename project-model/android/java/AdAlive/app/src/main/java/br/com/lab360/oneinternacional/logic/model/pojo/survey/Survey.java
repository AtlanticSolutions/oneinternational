package br.com.lab360.oneinternacional.logic.model.pojo.survey;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Class represents Survey object in the app, used in the product actions.
 * Created by Victor on 15/12/2015.
 * @see {@link Product}
 * @see {@link br.com.lab360.adalive.view.activity.ProductActivity}
 */
public class Survey implements Serializable {

    private static final long serialVersionUID = -1859314644260104087L;

    private int id;
    private String name;
    private List<Question> questions;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name == null ? "" : name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Question> getQuestions() {
        return questions == null ? new ArrayList<Question>() : questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }
}
