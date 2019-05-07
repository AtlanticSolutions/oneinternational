package br.com.lab360.oneinternacional.ui.activity.login;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.facebook.CallbackManager;
import com.facebook.login.LoginManager;

import java.util.Arrays;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.fcm.RegistrationInstanceIDService;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.presenter.LoginPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.TimelineActivity;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import cafe.adriel.androidoauth.callback.OnLoginCallback;
import cafe.adriel.androidoauth.model.SocialUser;
import rx.android.schedulers.AndroidSchedulers;


public class LoginActivity extends BaseActivity implements LoginPresenter.ILoginView {

    @BindView(R.id.txtWelcome)
    protected TextView txtWelcome;

    /* Masked up fields */
    @BindView(R.id.etEmail)
    protected EditText etEmail;

    @BindView(R.id.etPassword)
    protected EditText etPassword;

    @BindView(R.id.etCode)
    protected EditText etCode;
    @BindView(R.id.btnForgotPwd)
    protected Button btnForgotPwd;
    @BindView(R.id.btnLogin)
    protected Button btnLogin;
    @BindView(R.id.btnback)
    protected Button btnback;
    @BindView(R.id.btnCode)
    protected Button btnCode;

    @BindView(R.id.btnRegister)
    protected Button btnRegister;

    @BindView(R.id.btnFacebook)
    protected Button btnFacebook;

    @BindView(R.id.imgback)
    protected ImageView imgback;

    @BindView(R.id.container_login)
    protected LinearLayout containerLogin;

    @BindView(R.id.container_code)
    protected LinearLayout containerCode;

    @BindView(R.id.linEmail)
    protected LinearLayout linEmail;
    @BindView(R.id.linPsw)
    protected LinearLayout linPsw;
    @BindView(R.id.linCode)
    protected LinearLayout linCode;
    @BindView(R.id.imgEmail)
    protected ImageView imgEmail;

    @BindView(R.id.imgPsw)
    protected ImageView imgPsw;

    @BindView(R.id.imgCode)
    protected ImageView imgCode;


    @BindView(R.id.btnDistributor)
    protected Button btnDistributor;

    private LoginPresenter mPresenter;

    private CallbackManager callbackManager;
    private static final int RC_SIGN_IN = 007;

    public EditText email;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        setTheme(R.style.SplashScreen);

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_login);
        ButterKnife.bind(this);

        Intent intent = new Intent(this, RegistrationInstanceIDService.class);
        startService(intent);

        new LoginPresenter(this);

        this.hideKeyboard();

        etEmail.setBackground(null);
        etEmail.setPadding(0, 20, 0, 0);

        etPassword.setBackground(null);
        etPassword.setPadding(0, 20, 0, 0);

        callbackManager = CallbackManager.Factory.create();

        /*
        LoginManager.getInstance().registerCallback(callbackManager,
                new FacebookCallback<LoginResult>() {
                    @Override
                    public void onSuccess(LoginResult loginResult) {

                        GraphRequest request = GraphRequest.newMeRequest(
                                loginResult.getAccessToken(),
                                new GraphRequest.GraphJSONObjectCallback() {
                                    @Override
                                    public void onCompleted(JSONObject object, GraphResponse response) {
                                        String facebookToken = response.getRequest().getAccessToken().getToken();
                                        try {
                                            String email = object.getString("email");
                                            String userID = object.getString("id");

                                            SocialUser socialUser = new SocialUser();
                                            socialUser.setEmail(email);
                                            socialUser.setId(userID);

                                            mPresenter.onSuccess(facebookToken, socialUser);

//                                            finish();

                                        } catch (JSONException ex) {
                                            Log.v(AdaliveConstants.ERROR, ex.getMessage());
                                        }

                                    }
                                });
                        Bundle parameters = new Bundle();
                        parameters.putString("fields", "id,name,login,gender,birthday");
                        request.setParameters(parameters);
                        request.executeAsync();
//

                    }

                    @Override
                    public void onCancel() {

                    }

                    @Override
                    public void onError(FacebookException error) {

                        Log.v(AdaliveConstants.ERROR, error.getMessage());
                    }
                });

        */
    }

    @Override
    protected void onActivityResult(final int requestCode, final int resultCode, final Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (AdaliveApplication.getInstance().isResultSignup()) {
            User user = AdaliveApplication.getInstance().getUser();
            mPresenter.attemptToLogin(user.getEmail(), user.getPassword(),
                    user.getAccessToken(), AdaliveConstants.DEFAULT_ROLE);
        }
    }

    @Override
    public void onBackPressed() {

//        if (etEmail.getVisibility() == View.VISIBLE) {
//            etCode.setText("");
//            hideLogin();
//            returnShowButtonContainer();
//            cleanCodePrefs();
//        } else {
//            super.onBackPressed();
//        }
        super.onBackPressed();
    }
    //endregion

    //region ILoginView
    public void setPresenter(LoginPresenter mPresenter) {
        this.mPresenter = mPresenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
    }

    @Override
    public void navigateToTimelineActivity() {
        Intent intent = new Intent(this, TimelineActivity.class);
        startActivity(intent);
        finish();
    }

    @Override
    public void setColorViews() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        btnLogin.setBackgroundColor(color);
        btnRegister.setTextColor(color);
    }

    @Override
    public void verifyUserLogged() {
        User user = UserUtils.loadUser(this);

        if (!TextUtils.isEmpty(user.getEmail())) {
            mPresenter.onSharedRegister(user);
        } else {

            if (!UserUtils.getShowCode(this)) {
                //Previews set
                mPresenter.attemptMasterEvent();
                codeBackground(UserUtils.getBackgroundUrl(this));

                String colorButton = UserUtils.getButtonColor(this);

                /* deprecated due to a client request
                if (!Strings.isNullOrEmpty(colorButton)) {
                    ColorDrawable cd = new ColorDrawable(Color.parseColor(colorButton));
                    btnRegister.setBackground(cd);
                }
                */

                btnRegister.setBackgroundColor(Color.parseColor("white"));
            }

        }
    }

    private void cleanCodePrefs() {
        //Paulo rever
//        UserUtils.clearSharedPrefs(this);
        CoordinatorLayout layout = (CoordinatorLayout) findViewById(R.id.coordinator_layout);
        layout.setBackgroundColor(ContextCompat.getColor(this, R.color.color_bg));
    }

    @Override
    public void hideLogin() {

        txtWelcome.setVisibility(View.GONE);

        etEmail.setVisibility(View.GONE);

        etPassword.setVisibility(View.GONE);

        btnLogin.setVisibility(View.GONE);

        linEmail.setVisibility(View.GONE);

        linPsw.setVisibility(View.GONE);

        imgEmail.setVisibility(View.GONE);

        imgPsw.setVisibility(View.GONE);

        btnRegister.setVisibility(View.GONE);

        btnFacebook.setVisibility(View.GONE);

        btnForgotPwd.setVisibility(View.GONE);

        btnback.setVisibility(View.GONE);

//        imgback.setVisibility(View.GONE);

    }

    @Override
    public void hideCode() {

        linCode.setVisibility(View.GONE);

        imgCode.setVisibility(View.GONE);

        btnCode.setVisibility(View.GONE);

    }

    @Override
    public void codeBackground(final String backgroundUrl) {
        RequestOptions options = new RequestOptions();
        options.fitCenter();
        options.diskCacheStrategy(DiskCacheStrategy.RESOURCE);

        Glide.with(this)
                .load(backgroundUrl)
                .listener(new RequestListener<Drawable>() {
                    @Override
                    public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Drawable> target, boolean isFirstResource) {
                        return false;
                    }

                    @Override
                    public boolean onResourceReady(Drawable resource, Object model, Target<Drawable> target, DataSource dataSource, boolean isFirstResource) {
                        CoordinatorLayout layout = findViewById(R.id.coordinator_layout);
                        layout.setBackground(resource);
                        return false;
                    }
                }).preload();
    }

    @Override
    public void showLoginScreen() {

//        Transition slideTransition = new Slide(Gravity.RIGHT);
//        slideTransition.setDuration(500);
//        slideTransition.setStartDelay(200);
//
//        Transition changeBounds = new ChangeBounds();
//        changeBounds.setDuration(300);
//        changeBounds.setInterpolator(new LinearInterpolator());
//
//        TransitionManager.beginDelayedTransition(containerLogin, new TransitionSet()
//                .addTransition(changeBounds)
//                .addTransition(slideTransition)
//        );

        txtWelcome.setVisibility(View.GONE);

        etEmail.setVisibility(View.VISIBLE);

        etPassword.setVisibility(View.VISIBLE);

        btnLogin.setVisibility(View.VISIBLE);

        btnRegister.setVisibility(View.VISIBLE);

        //Por enquanto
        btnFacebook.setVisibility(View.GONE);
        btnForgotPwd.setVisibility(View.VISIBLE);

        //Only show flag true
        if (UserUtils.getShowCode(this)) {
            btnback.setVisibility(View.VISIBLE);
        }

        linEmail.setVisibility(View.VISIBLE);

        linPsw.setVisibility(View.VISIBLE);

        imgEmail.setVisibility(View.VISIBLE);

        imgPsw.setVisibility(View.VISIBLE);


    }

    @Override
    public void saveAppId(int appId) {
        UserUtils.saveAppId(this, appId);
    }

    @Override
    public void hideRegisterButton() {

        btnRegister.setVisibility(View.GONE);
        btnFacebook.setVisibility(View.GONE);

    }

    @Override
    public void showEmailFieldError() {
        etEmail.setError(getString(R.string.ERROR_ALERT_MESSAGE_EMAIL_INVALID));
    }

    @Override
    public void showCodeFieldError() {

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setTitle(getString(R.string.SCREEN_TITLE_ERRO_CODE))
                .setMessage(getString(R.string.ALERT_MESSAGE_ERRO_CODE))
                .setNegativeButton(getString(R.string.ALERT_OPTION_OK), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        dialog.dismiss();
                    }
                }).create();
        dialog.show();

    }

    @Override
    public void showPasswordFieldError() {
        etPassword.setError(getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_INVALID));
    }

    @Override
    public void showErrorMessage(String message) {
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR),message, null);
    }

    @Override
    public void showFacebookErrorMessage() {
        showToastMessage(getString(R.string.ERROR_ALERT_MESSAGE_FACEBOOK));
    }

    @Override
    public void showFacebookLogin(String facebookAppId, String facebookAppSecret, String facebookScope, String redirectUrl, OnLoginCallback callback) {

        LoginManager.getInstance().logInWithReadPermissions(LoginActivity.this, Arrays.asList("public_profile", "email"));

//        FacebookOAuth.login(this)
//                .setClientId(facebookAppId)
//                .setClientSecret(facebookAppSecret)
//                .setAdditionalScopes(facebookScope)
//                .setRedirectUri(redirectUrl)
//                .setCallback(callback)
//                .init();


    }

    @Override
    public void navigateToSignUpActivity() {
        Intent intent = new Intent(this, SignupActivity.class);
        startActivity(intent);
    }


    @Override
    public void navigateToSignUpActivity(SocialUser mFacebookUser, String mFacebookToken) {
        /*
        Intent intent = new Intent(this, SignupActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_FACEBOOK_USER, mFacebookUser);
        intent.putExtra(AdaliveConstants.INTENT_TAG_FACEBOOK_TOKEN, mFacebookToken);
        startActivity(intent);
        */
    }

    @Override
    public void showForgotPasswordDialog() {
        final View view = getLayoutInflater().inflate(R.layout.dialog_reset_password, null);
        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .setCancelable(false)
                .setTitle(getString(R.string.SCREEN_TITLE_RESET_PASSWORD))
                .setMessage(getString(R.string.ALERT_MESSAGE_FORGOT_PASSWORD))
                .setPositiveButton(getString(R.string.ALERT_OPTION_RESET_PWD), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        email = ((EditText) view.findViewById(R.id.etEmail));
                        if(isValidEmail(email.getText().toString())) {
                            mPresenter.attemptToResetPassword(email.getText().toString());
                            dialog.dismiss();
                        }else{
                            showErrorMessage("Digite um e-mail válido");
                        }
                    }
                })
                .setNegativeButton(getString(R.string.ALERT_OPTION_CANCEL), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int i) {
                        dialog.dismiss();
                    }
                }).show();

    }

    public final static boolean isValidEmail(CharSequence target) {
        return !TextUtils.isEmpty(target) && android.util.Patterns.EMAIL_ADDRESS.matcher(target).matches();
    }

    @Override
    public void showForgotPasswordSuccessMessage() {
        showToastMessage(getString(R.string.ALERT_MESSAGE_PASSWORD_RESETED));
    }
    //endregion

    //region Button Actions
    @OnClick({R.id.btnForgotPwd, R.id.btnLogin, R.id.btnFacebook, R.id.btnCode, R.id.btnRegister, R.id.btnback, R.id.btnDistributor})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnForgotPwd:
                mPresenter.onButtonForgotPwdTouched();
                break;
            case R.id.btnLogin:
                /*
                String email = etEmail.getUnMaskedText();
                String password = etPassword.getUnMaskedText();
                */

                String email = etEmail.getText().toString();
                String password = etPassword.getText().toString();

                mPresenter.attemptToLogin(email, password, null, AdaliveConstants.DEFAULT_ROLE);

                break;
            case R.id.btnCode:
                this.hideKeyboard();
                String code = etCode.getText().toString();
                mPresenter.attemptToCode(code);
                break;
            case R.id.btnFacebook:
                mPresenter.attemptToFacebookLogin(this);
                break;
            case R.id.btnRegister:
                mPresenter.onButtonSignupTouched();
                break;
            case R.id.btnDistributor:
                mPresenter.onButtonDistributorTouched();
                break;
            case R.id.btnback:
                onBackPressed();
                break;
        }
    }
    //endregion

}
