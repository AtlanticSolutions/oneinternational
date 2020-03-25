package br.com.lab360.bioprime.logic.model.pojo.survey;

import java.io.Serializable;
import java.util.Comparator;

/**
 * Question option object used in the {@link Question} list.
 * Created by Victor on 15/12/2015.
 * @see {@link Survey}
 */
public class QuestionOption implements Serializable {

    private static final long serialVersionUID = 6029994600869100589L;

    private int id, order;
    private String option;

    public static final Comparator<QuestionOption> ASCENDING_COMPARATOR = new Comparator<QuestionOption>() {
        // Overriding the compare method to sort the order
        public int compare(QuestionOption d, QuestionOption d1) {
            return d.getOrder() - d1.getOrder();
        }
    };

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public String getOption() {
        return option == null ? "" : option;
    }

    public void setOption(String option) {
        this.option = option;
    }
}
