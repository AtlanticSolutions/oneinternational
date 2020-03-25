package br.com.lab360.bioprime.ui.activity.survey;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import androidx.appcompat.app.ActionBar;
import androidx.appcompat.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;

import com.google.android.material.snackbar.Snackbar;
import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Observable;
import java.util.Observer;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.survey.Question;
import br.com.lab360.bioprime.logic.model.pojo.survey.Survey;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.ui.activity.product.ProductActivity;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import lib.bean.Answers;
import lib.error.NullTargetNameException;
import lib.error.NullUrlServerException;
import lib.ui.AdAliveWS;
import lib.utils.ConstantsAdAlive;


/**
 * Activity for the screen survey form.
 * Created by Victor on 16/12/2015.
 * @see {@link ProductActivity}.
 * @see {@link Survey}.
 */
public class SurveyActionActivity extends BaseActivity implements Observer {

    private int idSurvey;
    private int idAction;
    private LinearLayout llContainer;
    private LinearLayout.LayoutParams layoutParams;
    private List<QuestionComponent> componentList;
    private boolean fieldsAnswered;

    private AdAliveWS mAdAliveWS;
    private String urlServer;
    private String userEmail;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_survey_action);

        componentList = new ArrayList<>();

        urlServer = ApiManager.getInstance().getUrlAdaliveApi(this);
        userEmail = AdaliveApplication.getInstance().getUser().getEmail();

        idSurvey = getIntent().getIntExtra(AdaliveConstants.TAG_SURVEY_ID, 0);
        idAction = getIntent().getIntExtra(AdaliveConstants.TAG_ACTION_ID, 0);

        initAdAliveWS();

        try {

            mAdAliveWS.callGetSurvey(idSurvey);

        } catch (NullTargetNameException ex)
        {
            Log.v(ConstantsAdAlive.ERROR, ex.getMessage());
        }

        configStatusBarColor();
    }

    /**
     * Initialize toolbar component.
     * @param title Survey title.
     */
    public void initToolbar(String title) {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);

        setSupportActionBar(toolbar);

        ActionBar actionBar = getSupportActionBar();

        if (actionBar != null) {

            actionBar.setDisplayHomeAsUpEnabled(true);
            toolbar.setNavigationOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    onBackPressed();
                }
            });

            actionBar.setTitle(title);

            //Paulo Create a generic method - Paulo
            String topColor = UserUtils.getBackgroundColor(this);

            if (!Strings.isNullOrEmpty(topColor)) {
                ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
                getSupportActionBar().setBackgroundDrawable(cd);
            }

        }
    }



    /**
     * Set color to status bar.
     */
    private void configStatusBarColor() {
        String topColor = UserUtils.getBackgroundColor(SurveyActionActivity.this);
        ScreenUtils.updateStatusBarcolor(this, topColor);
    }

    /**
     * Configure objects in the layout.
     * @param survey Object survey.
     */
    private void configSurveyLayout(Survey survey) {

        llContainer = (LinearLayout) findViewById(R.id.llContainer);

        layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);

        //l,t,r,b
        layoutParams.setMargins(0, 10, 0, 10);

        int numberQuestion = 1;

        for (Question question : survey.getQuestions()) {

            String questionQuery = question.getQuery();

            question.setQuery(numberQuestion + ") " + questionQuery);

            addSurveyComponent(question);

            numberQuestion++;

        }

        initToolbar(survey.getName());
//        closeDialog();
    }

    /**
     * Add component {@link SurveyNumberComponent} or {@link SurveyMultipleComponent} to the layout.
     * @param question Object question.
     */
    private void addSurveyComponent(Question question) {

        QuestionComponent questionComponent;

        if(question.isRequired() && findViewById(R.id.tvRequired).getVisibility() != View.VISIBLE) {
            findViewById(R.id.tvRequired).setVisibility(View.VISIBLE);
        }

        if (question.getType().equalsIgnoreCase(Question.NUMBER)) {

            questionComponent = new SurveyNumberComponent(this, null, question);

            llContainer.addView(questionComponent, layoutParams);

        } else {

            questionComponent = new SurveyMultipleComponent(this, null, question);

            llContainer.addView(questionComponent, layoutParams);

        }

        componentList.add(questionComponent);

    }

    /**
     * Create options menu with the data in the <code>menu_survey</code>.
     * @param menu The Menu to inflate into. The items and submenus will be
     *            added to this Menu.
     * @return boolean
     */
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        getMenuInflater().inflate(R.menu.menu_survey, menu);

        return true;
    }

    /**
     * Action select event of the item menu selected.
     * @param item Item with received action.
     * @return <code>boolean</code> If object was selected.
     */
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int id = item.getItemId();

        switch (id){

            case R.id.action_send:

                if(isFieldsAnswered()) {

                    verifyHasRequiredQuestion();

                    if(fieldsAnswered) {

                        showDialogSendSurvey();

                    }

                } else {

                    showToastMessage(getString(R.string.one_field_need_answered));

//                    UtilsAdAlive.showSnackbar(getString(R.string.one_field_need_answered), getResources().getColor(R.color.red),
//                            findViewById(R.id.svSurveyScroll));

                }

                break;

        }

        return super.onOptionsItemSelected(item);

    }

    /**
     * Verify each component has required attribute and was answered.
     * Case not answered, show information error in the {@link Snackbar}.
     */
    private void verifyHasRequiredQuestion() {
        for (final QuestionComponent questionComponent : componentList) {

            if (questionComponent.isRequired() && !questionComponent.isAnswered()) {

                new Handler().post(new Runnable() {
                    @Override
                    public void run() {

                        findViewById(R.id.svSurveyScroll).scrollTo(0, questionComponent.getTop());
//                        UtilsAdAlive.showSnackbar(getString(R.string.field_not_answered), getResources().getColor(R.color.red),
//                                findViewById(R.id.svSurveyScroll));
                        fieldsAnswered = false;

                    }
                });
                break;

            }

            if (questionComponent == componentList.get(componentList.size() - 1)) {

                fieldsAnswered = true;

            }

        }
    }

    /**
     * Show alert with information if you are really ready to send inquiry.
     */
    private void showDialogSendSurvey() {

        new AlertDialog.Builder(this)
                .setTitle(R.string.warning)
                .setMessage(getString(R.string.send_survey))
                .setCancelable(false)
                .setPositiveButton(android.R.string.ok,
                        new DialogInterface.OnClickListener() {

                            @Override
                            public void onClick(DialogInterface dialog,
                                                int which) {

                                dialog.dismiss();

                                callLogSendSurvey();

                            }
                        })
                .setNegativeButton(android.R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {

                        dialog.dismiss();

                    }
                }).create().show();
    }

    /**
     * Return if has field answered.
     * @return Return if has field answered.
     */
    private boolean isFieldsAnswered(){

        for (final QuestionComponent questionComponent : componentList) {

            if (questionComponent.isAnswered()) {
                return true;
            }
        }

        return false;
    }

    /**
     * Call send survey service log.
     */
    private void callLogSendSurvey() {

        int actionId = 0; //getIntent().getIntExtra(ConstantsAdAlive.ACTION_ID, 0);

        List<Question> questionList = new ArrayList<>();
        List<Answers> answersList = new ArrayList<>();

        for(QuestionComponent questionComponent : componentList) {

            questionList.add(questionComponent.getmQuestion());

            Question question = questionComponent.getmQuestion();

            Answers answers = new Answers(idSurvey, idAction, String.valueOf(question.getAnswer()));
            answersList.add(answers);

        }

        mAdAliveWS.execUserAnswers(idSurvey, idAction, answersList, AdaliveApplication.getInstance().getUser().getEmail());

        successDialog(getString(R.string.survey_title_success_dialog),
                getString(R.string.answered_survey),
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
                );
    }



    /**
     * Init AdAlive WS.
     */
    public void initAdAliveWS() {
        try {

            mAdAliveWS = new AdAliveWS(this, urlServer, userEmail);
            observe(mAdAliveWS);

        } catch (NullUrlServerException e) {

            Log.e(AdaliveConstants.ERROR, "initAdAliveWS: " + e.toString());

        }
    }


    //region Observer
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////// Observer ////////////////////////////
    //////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////

    /**
     * Add {@code Observable} object.
     *
     * @param o {@code Observable} object to add.
     */
    public void observe(Observable o) {

        o.addObserver(this);

    }

    /**
     * This method is called if the specified {@code Observable} object's
     * {@code notifyObservers} method is called (because the {@code Observable}
     * object has been updated.
     * The {@code AdAliveService} is the {@code Observable} object.
     *
     * @param observable the {@link Observable} object, in this case {@code String} code object recognized.
     * @param data       the data passed to {@link Observable#notifyObservers(Object)}.
     */
    @Override
    public void update(Observable observable, Object data) {

        JsonObject jsonResponse;

        if (observable instanceof AdAliveWS) {

            jsonResponse = ((AdAliveWS) observable).getJsonResponse();

            if (jsonResponse != null) {

                if (!jsonResponse.has(ConstantsAdAlive.TAG_ERRORS_SERVER)) {

                    Gson gson = new Gson();
                    Survey survey = gson.fromJson(jsonResponse, Survey.class);

                    configSurveyLayout(survey);


                    Log.v(AdaliveConstants.ERROR, survey.getName());


                } else {

                    Log.e(AdaliveConstants.ERROR, "update: " + jsonResponse.toString());

                }

            }

        }


    }
    //endregion

    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        onBackPressed();
                        break;
                }
            }
        };
    }
}
