package br.com.lab360.oneinternacional.ui.activity.survey;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;
import android.widget.TextView;

import br.com.lab360.oneinternacional.logic.model.pojo.survey.Question;



public class QuestionComponent extends LinearLayout {

    protected int id, value;
    protected TextView tvQuestionDescription;
    protected boolean required, answered;
    protected Question mQuestion;

    public QuestionComponent(Context context, AttributeSet attrs, Question mQuestion) {
        super(context, attrs);
        setmQuestion(mQuestion);
    }

    /**
     * Return component id.
     * @return id of the component
     */
    @Override
    public int getId() {

        return id;

    }

    /**
     * Set component id.
     * @param id identifier
     */
    @Override
    public void setId(int id) {

        this.id = id;

    }

    /**
     * Return value of the component, answer.
     * @return id answer
     */
    public int getValue(){

        return value;

    }

    /**
     * Set description of the question.
     * @param description question
     */
    public void setQuestionDescription(String description){

        if(tvQuestionDescription != null) {

            if(!isRequired()) {

                tvQuestionDescription.setText(description);

            } else {

                tvQuestionDescription.setText(description + " *");

            }

        }

    }

    /**
     * Return if the component answer is required.
     * @return if answer is required
     */
    public boolean isRequired() {

        return required;

    }

    /**
     * Set if the component answer is required.
     * @param required answer is required
     */
    public void setRequired(boolean required) {

        this.required = required;

    }

    /**
     * Return if question was answered.
     * @return if question was answered.
     */
    public boolean isAnswered() {

        if(!answered && isRequired()){
            tvQuestionDescription.setTextColor(getResources().getColor(android.R.color.holo_red_dark));
        }

        return answered;
    }

    /**
     * Set if question was answered.
     * @param if question was answered.
     */
    public void setAnswered(boolean answered) {
        this.answered = answered;
    }

    /**
     * Return {@link Question}.
     * @return return question object.
     */
    public Question getmQuestion() {
        return mQuestion;
    }

    /**
     * Set {@link Question}.
     * @param mQuestion add question object.
     */
    public void setmQuestion(Question mQuestion) {
        this.mQuestion = mQuestion;
    }
}
