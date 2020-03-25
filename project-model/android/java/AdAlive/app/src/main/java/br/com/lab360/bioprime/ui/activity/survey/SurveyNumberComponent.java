package br.com.lab360.bioprime.ui.activity.survey;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.SeekBar;
import android.widget.TextView;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.survey.Question;


public class SurveyNumberComponent extends QuestionComponent {

    @SuppressLint("StringFormatMatches")
    public SurveyNumberComponent(final Context context, AttributeSet attrs, Question question) {
        super(context, attrs, question);

        final LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        final View inflate = inflater.inflate(R.layout.layout_survey_number, this, true);

        tvQuestionDescription = (TextView) inflate.findViewById(R.id.tvDescNumber);

        SeekBar sbProgressNumber = (SeekBar) inflate.findViewById(R.id.sbProgressNumber);
        sbProgressNumber.setProgress(question.getInitial_value());

        ((TextView) inflate.findViewById(R.id.tvValueNumber))
                .setText(context.getString(R.string.value_number, sbProgressNumber.getProgress()));

        sbProgressNumber.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

                ((TextView) inflate.findViewById(R.id.tvValueNumber))
                        .setText(context.getString(R.string.value_number, progress));

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

                value = seekBar.getProgress();
                answered = true;
                tvQuestionDescription.setTextColor(getResources().getColor(R.color.black));
                getmQuestion().setAnswer(value);

            }
        });

        setId(question.getId());
        setRequired(question.isRequired());
        setQuestionDescription(question.getQuery());

    }

}
