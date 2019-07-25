package br.com.lab360.oneinternacional.ui.activity.survey;

import android.content.Context;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import java.util.Collections;
import java.util.List;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.survey.Question;
import br.com.lab360.oneinternacional.logic.model.pojo.survey.QuestionOption;


public class SurveyMultipleComponent extends QuestionComponent {

    private Context context;
    private RadioGroup.LayoutParams layoutParams;
    private RadioGroup rgContainer;

    public SurveyMultipleComponent(final Context context, AttributeSet attrs, Question question) {
        super(context, attrs, question);

        this.context = context;

        final LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View inflate = inflater.inflate(R.layout.layout_survey_multiple, this, true);

        layoutParams = new RadioGroup.LayoutParams(RadioGroup.LayoutParams.MATCH_PARENT,
                RadioGroup.LayoutParams.WRAP_CONTENT);

        //l,t,r,b
        layoutParams.setMargins(0, 10, 0, 10);

        tvQuestionDescription = (TextView) inflate.findViewById(R.id.tvDescMultiple);

        rgContainer = (RadioGroup) inflate.findViewById(R.id.rgContainer);
        rgContainer.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {

                value = checkedId;
                answered = true;
                tvQuestionDescription.setTextColor(getResources().getColor(R.color.black));
                getmQuestion().setAnswer(value);

            }

        });


        initQuestionOptions(question.getQuestion_options());

        setId(question.getId());
        setRequired(question.isRequired());
        setQuestionDescription(question.getQuery());
    }

    /**
     * Initialize {@link RadioButton} for each {@link QuestionOption}.
     * @param questionOptionList List of the {@link QuestionOption}.
     */
    private void initQuestionOptions(List<QuestionOption> questionOptionList) {

        Collections.sort(questionOptionList, QuestionOption.ASCENDING_COMPARATOR);

        for (QuestionOption questionOption : questionOptionList) {

            RadioButton radioButton = new RadioButton(context);
            radioButton.setId(questionOption.getId());
            radioButton.setText(questionOption.getOption());
            radioButton.setTypeface(null, Typeface.BOLD);

            rgContainer.addView(radioButton, layoutParams);

        }

    }

}
