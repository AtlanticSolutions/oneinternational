package br.com.lab360.bioprime.logic.model.pojo.survey;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Question object used in the {@link Survey} list.
 * Created by Victor on 15/12/2015.
 */
public class Question implements Serializable {

    private static final long serialVersionUID = -2615494018876879495L;

    public static final String NUMBER = "number";
    public static final String MULTIPLE = "multiple";

    private int id, answer, initial_value;
    private String query, type;
    private boolean required;
    private List<QuestionOption> question_options;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getQuery() {
        return query == null ? "" : query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public List<QuestionOption> getQuestion_options() {
        return question_options == null ? new ArrayList<QuestionOption>() : question_options;
    }

    public void setQuestion_options(List<QuestionOption> question_options) {
        this.question_options = question_options;
    }

    public boolean isRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }

    public String getType() {
        return type == null ? "" : type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getAnswer() {
        return answer;
    }

    public void setAnswer(int answer) {
        this.answer = answer;
    }

    public int getInitial_value() {
        return initial_value;
    }

    public void setInitial_value(int initial_value) {
        this.initial_value = initial_value;
    }
}
