package br.com.lab360.bioprime.ui.activity.events;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.appcompat.widget.Toolbar;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import com.bumptech.glide.Glide;
import com.google.common.base.Strings;
import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.user.Event;
import br.com.lab360.bioprime.logic.presenter.events.EventDetailPresenter;
import br.com.lab360.bioprime.ui.activity.BaseActivity;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class EventDetailActivity extends BaseActivity implements EventDetailPresenter.IEventDetailView {

    @BindView(R.id.tvTitle)
    protected TextView tvTitle;

    @BindView(R.id.tvDescription)
    protected TextView tvDescription;

    @BindView(R.id.tvDate)
    protected TextView tvDate;

    @BindView(R.id.tvPlace)
    protected TextView tvPlace;

    @BindView(R.id.toolbar)
    protected Toolbar toolbar;

    @BindView(R.id.btnSubscribe)
    protected Button btnSubscribe;

    @BindView(R.id.btnUnsubscribe)
    protected Button btnUnsubscribe;

    @BindView(R.id.ivSpeaker)
    protected ImageView ivSpeaker;

    @BindView(R.id.textEventDetails)
    protected TextView textEventDetails;

    @BindView(R.id.textSpeakerName)
    protected TextView textSpeakerName;

    private EventDetailPresenter mPresenter;
    private boolean showOnlyRegistered;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_event_detail);

        ButterKnife.bind(this);

        Bundle extras = getIntent().getExtras();
        Event event = extras.getParcelable(AdaliveConstants.INTENT_TAG_EVENT);
        showOnlyRegistered = extras.getBoolean(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED);
        new EventDetailPresenter(this, event, showOnlyRegistered);
    }
    //endregion

    //region IEventDetailView
    @Override
    public void setPresenter(EventDetailPresenter presenter) {
        this.mPresenter = presenter;
        mPresenter.start();
    }

    @Override
    public void initToolbar(String title) {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(true);
        getSupportActionBar().setTitle(title);

        String topColor = UserUtils.getBackgroundColor(EventDetailActivity.this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }

    @Override
    public void populateFields(String name, String description, String schedule, String local, String speakerDetails, String eventImage, String speakerName) {
        tvTitle.setText(name);
        tvDescription.setText(description);
        tvDate.setText(schedule);
        tvPlace.setText(local);
        textEventDetails.setText(speakerDetails);
        textSpeakerName.setText(speakerName);

        Glide.with(this).load(eventImage).into(ivSpeaker);
    }

    @Override
    public void showUnregisterButton() {
        btnUnsubscribe.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideUnregisterButton() {
        btnUnsubscribe.setVisibility(View.GONE);
    }

    @Override
    public void showRegisterButton() {
        btnSubscribe.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideRegisterButton() {
        btnSubscribe.setVisibility(View.GONE);
    }

    @Override
    public void showRegisterSuccessDialog(String eventTitle) {
        successDialog(eventTitle,getString(R.string.ALERT_MESSAGE_SUBSCRIBE_SUCCESS), null);
    }

    @Override
    public void showUnregisterSuccessDialog(String eventTitle) {
        successDialog(getString(R.string.DIALOG_TITLE_SUCCESS_UNREGISTER), getString(R.string.ALERT_MESSAGE_DELETE_EVENT_SUCCESS), null);
    }

    @Override
    public void navigateToEventDowloadListActivity(Event event) {
        Intent intent = new Intent(this, EventDownloadsActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_EVENT, event);
        startActivity(intent);
    }

    @Override
    public void setImageSpeaker(Bitmap image) {

        ivSpeaker.setImageBitmap(image);
    }

    @Override
    public void setEventDetails(String details) {

        textEventDetails.setText(details);
    }

    //endregion

    //region button actions
    @OnClick({R.id.btnSubscribe, R.id.btnUnsubscribe, R.id.btnDownload})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnSubscribe:
                mPresenter.onBtnSubscribeTouched();
                break;
            case R.id.btnUnsubscribe:
                mPresenter.onBtnUnsubscribeTouched();
                break;
            case R.id.btnDownload:
                mPresenter.onBtnDownloadTouched();
                break;
        }
    }
    //endregion
}
