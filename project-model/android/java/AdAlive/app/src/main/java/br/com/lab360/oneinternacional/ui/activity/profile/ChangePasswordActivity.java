package br.com.lab360.oneinternacional.ui.activity.profile;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.presenter.profile.ChangePasswordPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class ChangePasswordActivity extends BaseActivity implements
        ChangePasswordPresenter.IChangePasswordView {

    //region Binds
    @BindView(R.id.etPassword)              protected EditText etPassword;
    @BindView(R.id.etConfirmPassword)       protected EditText etConfirmPassword;
    @BindView(R.id.content_change_password) protected LinearLayout layout;
    @BindView(R.id.btnSavePassword)         protected Button btnSavePassword;
    //endregion

    //region Vars
    private ChangePasswordPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_change_password);
        ButterKnife.bind(this);
        initToolbar(getString(R.string.SCREEN_TITLE_CHANGE_PASSWORD));
        mPresenter = new ChangePasswordPresenter(this);
        mPresenter.start();
    }

    @Override
    public void setPresenter(ChangePasswordPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }


    @Override
    public void setColorViews() {
        int color = Color.parseColor(UserUtils.getButtonColor(this));
        btnSavePassword.setBackgroundColor(color);
    }
    //region Configuration

    /*
    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        //Paulo Create a generic method - Paulo
        String topColor = UserUtils.getBackgroundColor(ChangePasswordActivity.this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }
    */

    @Override
    public void setActivityResult(String password) {
        Intent intent = new Intent();
        intent.putExtra(AdaliveConstants.INTENT_TAG_PASSWORD, password);
        setResult(RESULT_OK, intent);
        finish();
    }

    @Override
    public void showPasswordMatchError() {
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR), getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_MATCH), null);
    }

    @Override
    public void showPasswordLenghtError() {
        errorDialog(getString(R.string.DIALOG_TITLE_ERROR), getString(R.string.ERROR_ALERT_MESSAGE_PASSWORD_LENGHT), null);
    }

    @OnClick({R.id.btnSavePassword})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnSavePassword:
                //showToastMessage("Salvar");
                String password = etPassword.getText().toString();
                String confirmPassword = etConfirmPassword.getText().toString();
                mPresenter.attemptToSavePendingChanges(password,confirmPassword);
                break;
        }

    }

}
