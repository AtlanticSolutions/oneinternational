package br.com.lab360.oneinternacional.logic.presenter;

import android.content.Context;
import androidx.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.ChatInteractor;
import br.com.lab360.oneinternacional.logic.interactor.LayoutInteractor;
import br.com.lab360.oneinternacional.logic.interactor.LoginInteractor;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnChatRequestListener;
import br.com.lab360.oneinternacional.logic.listeners.OnCodeListener;
import br.com.lab360.oneinternacional.logic.listeners.Account.OnForgotPasswordListener;
import br.com.lab360.oneinternacional.logic.listeners.OnLayoutLoadedListener;
import br.com.lab360.oneinternacional.logic.listeners.Account.OnLoginFinishedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.CodeParam;
import br.com.lab360.oneinternacional.logic.model.pojo.CodeRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.account.FacebookLoginRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.account.ForgotPasswordRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.user.LayoutParam;
import br.com.lab360.oneinternacional.logic.model.pojo.account.LoginRequest;
import br.com.lab360.oneinternacional.logic.model.pojo.StatusResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatBaseResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.roles.RoleProfileObject;
import br.com.lab360.oneinternacional.ui.view.IBaseView;
import br.com.lab360.oneinternacional.utils.EnumLoginTypeCategory;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import cafe.adriel.androidoauth.callback.OnLoginCallback;
import cafe.adriel.androidoauth.model.SocialUser;

import static com.google.common.base.Preconditions.checkNotNull;


/**
 * Created by Alessandro Valenza on 31/10/2016.
 */

public class LoginPresenter implements IBasePresenter, OnLoginFinishedListener, OnLayoutLoadedListener, OnLoginCallback, OnForgotPasswordListener, OnChatRequestListener, OnCodeListener {
    private final AdaliveApplication mApplication;
    private final ILoginView mView;
    private final LoginInteractor mInteractor;
    private final LayoutInteractor mLayoutInteractor;
    private final ChatInteractor mChatInteractor;
    private boolean isFacebookLogin;
    private SocialUser mFacebookUser;
    private String mFacebookToken;

    private String mRole;                               /* Keep track of the user role */

    public LoginPresenter(@NonNull ILoginView view) {
        this.mView = checkNotNull(view, "View cannot be null");
        this.mApplication = AdaliveApplication.getInstance();
        this.mInteractor = new LoginInteractor(mView.getContext());
        this.mChatInteractor = new ChatInteractor(mView.getContext());
        this.mLayoutInteractor = new LayoutInteractor(mView.getContext());
        this.mView.setPresenter(this);
    }

    //region Public methods
    @Override
    public void start() {

        mView.initToolbar();
        mView.setColorViews();
        mView.hideLogin();
        mView.verifyUserLogged();
        this.checkRegisterPermission();
    }

    public void attemptToLogin(String email, String password, String facebookToken, String role) {
        mRole = role;

        if(!mView.isOnline()){
            mView.showNoConnectionSnackMessage();
            return;
        }

        ArrayList<Integer> validation = null;
        FacebookLoginRequest facebookRequest = null;
        LoginRequest request = null;

        if(!TextUtils.isEmpty(facebookToken)){

            if (mFacebookUser.getEmail() != null){
                facebookRequest = new FacebookLoginRequest(mApplication.getCodeParams().getMasterEventId(),facebookToken, mFacebookUser.getId(), mFacebookUser.getName(), mFacebookUser.getEmail());
            }else{
                mView.navigateToSignUpActivity(mFacebookUser, facebookToken);
            }
        }else {
            request = new LoginRequest(email, password, role, mApplication.getCodeParams().getMasterEventId());
            validation = request.validate();
        }

        if (!performValidation(validation)) {
            return;
        }

        mView.showProgress();

        if(facebookRequest != null) {
            mInteractor.signFacebookLogin(facebookRequest, this);
            return;
        }

        mInteractor.postLogin(request, this, role);

    }


    public void attemptToCode(String code) {

        if(!mView.isOnline()){
            mView.showNoConnectionSnackMessage();
            return;
        }

        ArrayList<Integer> validation = null;
        CodeRequest coderequest = null;

        coderequest = new CodeRequest(code);
        validation = coderequest.validate();

        if (!performValidation(validation)) {
            return;
        }

        mView.showProgress();
    }

    public void attemptMasterEvent() {

        mView.hideCode();
        mView.hideProgress();
        mView.showLoginScreen();

    }
    
    private boolean performValidation(ArrayList<Integer> validation) {
        if (validation != null) {
            for (int fieldName : validation) {
                switch (fieldName) {
                    case LoginRequest.FieldType.EMAIL:
                        mView.showEmailFieldError();
                        break;
                    case LoginRequest.FieldType.PASSWORD:
                        mView.showPasswordFieldError();
                        break;
                    case CodeRequest.FieldType.CODE:
                        mView.showCodeFieldError();
                        break;
                }
            }
            return false;
        }
        return true;
    }

    private void loadLayout() {
        AdaliveApplication application = AdaliveApplication.getInstance();
        if (UserUtils.getLayoutParam(mView.getContext()) == null) {
            mView.loadCachedBackground();
            int masterEventId = application.getCodeParams().getMasterEventId();
            mLayoutInteractor.getLayoutParams(AdaliveConstants.APP_ID, this);

        } else {
            mView.loadApplicationBackground();
        }
    }

    public void attemptToFacebookLogin(Context context) {
        String facebookAppId =  context.getString(R.string.fb_app_id);
        String facebookAppSecret = context.getString(R.string.fb_app_secret);
        String facebookScope = "public_profile email";
        String redirectUrl = "http://www.oticasdiniz.com.br/";
        mView.showFacebookLogin(facebookAppId, facebookAppSecret, facebookScope, redirectUrl, this);
    }

    public void onButtonSignupTouched(){
         mView.navigateToSignUpActivity();
    }

    public void onButtonDistributorTouched(){
        // mView.navigateToDistributeActivity();
    }

    public void onButtonForgotPwdTouched() {
        mView.showForgotPasswordDialog();
    }

    public void attemptToResetPassword(String email) {
        ForgotPasswordRequest request = new ForgotPasswordRequest(email);

        mView.showProgress();
        mInteractor.postForgotPassword(request,this);
    }

    public void onSharedRegister(User user){
        mApplication.setUser(user);
        loadLayout();
        mView.navigateToTimelineActivity();
        mChatInteractor.registerDeviceId(AdaliveConstants.ACCOUNT_ID, user.getId(), AdaliveApplication.getInstance().getFcmToken(),this);
    }

    //endregion

    //region OnLoginFinishedListener
    @Override
    public void onLoginSuccess(User response) {
        mView.hideProgress();
        mApplication.setUser(response);
        mApplication.setResultSignup(false);
        mView.navigateToTimelineActivity();

        mView.saveUserIntoSharedPreferences(response);

        SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
        if(sharedPrefsHelper != null){
            sharedPrefsHelper.put(EnumLoginTypeCategory.USER_TOKEN.getUserToken,response.getAccessToken());
        }

        if (!response.getRole().equals(AdaliveConstants.DEFAULT_ROLE)){

            for (RoleProfileObject roleProfile: UserUtils.getLayoutParam(mView.getContext()).getRoles()) {

                if (roleProfile.getRole().equals(response.getRole())) {

                    UserUtils.setConfigurationsByRole(roleProfile, mView.getContext());
                    break;
                }
            }
        }

        mChatInteractor.registerDeviceId(AdaliveConstants.ACCOUNT_ID, response.getId(), AdaliveApplication.getInstance().getFcmToken(),this);
    }

    @Override
    public void onLoginError(String error) {

        mView.hideProgress();

        if (!Strings.isNullOrEmpty(UserUtils.getLayoutParam(mView.getContext()).getLoginErrorMessage())){

            mView.showErrorMessage(UserUtils.getLayoutParam(mView.getContext()).getLoginErrorMessage());
        } else {
            mView.showErrorMessage(error);
        }

        if(isFacebookLogin){
            mView.navigateToSignUpActivity(mFacebookUser,mFacebookToken);
        }
    }
    //endregion

    //region OnLoginCallback (FacebookLogin)
    @Override
    public void onSuccess(String token, SocialUser user) {
        Log.d("Facebook Token", token);
        Log.d("Facebook User", user.toString());
        mFacebookUser = user;
        mFacebookToken = token;
        isFacebookLogin = true;
        attemptToLogin(user.getEmail(), user.getId(), mFacebookToken, AdaliveConstants.DEFAULT_ROLE);
    }

    @Override
    public void onError(Exception e) {
        Log.e("Facebook Error", e.getMessage());
        mView.showFacebookErrorMessage();
    }
    //endregion

    //region OnForgotPasswordListener
    @Override
    public void onForgotPassError(String error) {
        mView.hideProgress();
        mView.showToastMessage(error);
    }

    @Override
    public void onForgotPasswordSuccess(StatusResponse response) {
        mView.hideProgress();
        mView.showForgotPasswordSuccessMessage();
    }

    @Override
    public void onChatRequestError(String error, int requestType, int position) {
        //Token not registered
    }

    @Override
    public void onChatRequestSuccess(ChatBaseResponse response, int requestType, int position) {
        //Token registered
    }
    //endregion

    //region OnCodeListener
    @Override
    public void onCodeError() {
        mView.hideProgress();
        mView.showCodeFieldError();
    }

    @Override
    public void onCodeSuccess(CodeParam code) {
        mView.hideCode();
        mView.hideProgress();
        mApplication.setCodparametro(code);

        //rever urgentemente  - Paulo
//        mApplication.setLayoutParam(new LayoutParam(code.getBackgroundimage(),code.getHeaderImageUrl(),
//                code.getHomepageurl(), code.getVuforiaAccessKey(), code.getVuforiaSecretKey(),
//                code.getVuforiaLicenseKey()) );
        mView.saveAppId(code.getId());
        mView.codeBackground(code.getBackgroundimage());
        mView.showLoginScreen();
    }

    @Override
    public void onLayoutLoadError() {
        Log.d(getClass().getCanonicalName(), "TIMEOUT ERROR HERE! 12345");
    }

    @Override
    public void onLayoutLoadSuccess(LayoutParam params) {
        UserUtils.setLayoutParam(params, mView.getContext());
        mView.loadApplicationBackground();
    }
    //endregion


    private void checkRegisterPermission(){

        if (UserUtils.getLayoutParam(mView.getContext()) != null && !UserUtils.getLayoutParam(mView.getContext()).getRegisterUser()){
            mView.hideRegisterButton();
        }
    }

    public interface ILoginView extends IBaseView {
        void setPresenter(LoginPresenter mPresenter);

        void initToolbar();

        void setColorViews();

        void navigateToTimelineActivity();

        void showEmailFieldError();

        void showCodeFieldError();

        void showPasswordFieldError();

        void showErrorMessage(String message);

        void showFacebookErrorMessage();

        void showFacebookLogin(String facebookAppId, String facebookAppSecret, String facebookScope, String redirectUrl,  OnLoginCallback loginPresenter);

        void navigateToSignUpActivity();

        void navigateToSignUpActivity(SocialUser mFacebookUser, String mFacebookToken);

        void showForgotPasswordDialog();

        void showForgotPasswordSuccessMessage();

        void verifyUserLogged();

        void hideLogin();

        void hideCode();

        void codeBackground(final String backgroundUrl);

        void showLoginScreen();

        void saveAppId(int appId);

        void hideRegisterButton();

    //    void navigateToDistributeActivity();

    }
}
