package br.com.lab360.oneinternacional.ui.activity.chat;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.core.app.NotificationManagerCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.EventMessage;
import br.com.lab360.oneinternacional.logic.presenter.chat.ChatPresenter;
import br.com.lab360.oneinternacional.ui.activity.NavigationDrawerActivity;
import br.com.lab360.oneinternacional.ui.activity.login.LoginActivity;
import br.com.lab360.oneinternacional.ui.adapters.chat.ChatMessagesRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class ChatActivity extends NavigationDrawerActivity implements ChatPresenter.IChatView {
    //region Binds
    @BindView(R.id.btnSendMessage)
    protected ImageButton btnSendMessage;
    @BindView(R.id.rvChat)
    protected RecyclerView rvChat;
    @BindView(R.id.etMessage)
    protected EditText etMessage;
    @BindView(R.id.tvEmptyList)
    protected TextView tvEmptyList;
    @BindView(R.id.progressBar)
    protected ProgressBar progressBar;
    //endregion

    private ChatPresenter mPresenter;
    private boolean isUserValid = true, mFromNotification;
    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);
        ButterKnife.bind(this);

        BaseObject selectedChat = new BaseObject();
        String receivedMessageJSON = "";
        String status = "";
        boolean notificationsEnabled = true;
        boolean isGroup = false;

        progressBar.getIndeterminateDrawable().setColorFilter(Color.parseColor(UserUtils.getBackgroundColor(this)), android.graphics.PorterDuff.Mode.MULTIPLY);

        Bundle extras = getIntent().getExtras();

        if (extras.containsKey(AdaliveConstants.INTENT_TAG_CHAT)) {
            selectedChat = (BaseObject) extras.get(AdaliveConstants.INTENT_TAG_CHAT);
        }
        if (extras.containsKey(AdaliveConstants.INTENT_TAG_GROUP)) {
            isGroup = extras.getBoolean(AdaliveConstants.INTENT_TAG_GROUP, false);
        }
        if (extras.containsKey(AdaliveConstants.INTENT_TAG_BLOCK_STATUS)) {
            status = extras.getString(AdaliveConstants.INTENT_TAG_BLOCK_STATUS);
        }
        if (NotificationManagerCompat.from(this).areNotificationsEnabled()) {
            notificationsEnabled = false;
        }



        //se veio da notificacao e o app nao ta carregado tem que carregar os dados
        if (extras.containsKey(AdaliveConstants.INTENT_TAG_MESSAGE)) {
            mFromNotification = true;
            receivedMessageJSON = extras.getString(AdaliveConstants.INTENT_TAG_MESSAGE);

//            new ChatPresenter(this, selectedChat, receivedMessageJSON, notificationsEnabled, isGroup, status);
//
//            if (AdaliveApplication.getInstance().getUrlChatAdaliveApi() == null) {
//
//                MasterServerInteractor masterServerInteractor = new MasterServerInteractor();
//
//                masterServerInteractor.getMasterServerData(AdaliveConstants.APP_ID, Build.DEVICE,
//                        "0", "0", "Android", this.getDeviceId(), Build.VERSION.BASE_OS, Build.MODEL, Build.PRODUCT, new OnMasterServerDataLoadedListener() {
//                            @Override
//                            public void onMasterServerDataLoadSuccess(MasterServerResponse params) {
//                                String urlAdalive = params.getUrlAdalive();
//                                AdaliveApplication.getInstance().setAdaliveApi(urlAdalive);
//
//                                String udlAdaliveChat = params.getUrlChat();
//                                AdaliveApplication.getInstance().getInstance().setAdaliveChatApi(udlAdaliveChat);
//
//                                mPresenter.start();
//
////                                LayoutInteractor layoutInteractor = new LayoutInteractor();
////                                layoutInteractor.getLayoutParams(AdaliveConstants.APP_ID, new OnLayoutLoadedListener() {
////                                    @Override
////                                    public void onLayoutLoadSuccess(GsemdLayoutParam params) {
////                                        //Save layout configurations
////                                        AdaliveApplication.getInstance().setLayoutParam(params);
////
////                                        mPresenter.start();
////                                    }
////                                });
//                            }
//                        });
//            } else {
//
//                mPresenter.start();
            }
//        } else {
//
//                }

            new ChatPresenter(this, selectedChat, receivedMessageJSON, notificationsEnabled, isGroup, status);
            mPresenter.start();
    }


    @Override
    protected void onDestroy() {
        mPresenter.onDestroy();
        super.onDestroy();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                break;
        }
        return true;
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, ChatGroupListActivity.class);
        startActivity(intent);
        finish();
    }

    //endregion

    //region IChatView
    @Override
    public void initToolbar(String title) {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        setToolbarTitle(title);


        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);
        }
    }



    @Override
    public void setPresenter(ChatPresenter chatPresenter) {
        this.mPresenter = chatPresenter;

    }


    @Override
    public void setupRecyclerView() {
        final ChatMessagesRecyclerAdapter adapter = new ChatMessagesRecyclerAdapter(this);
        rvChat.setAdapter(adapter);
        rvChat.setHasFixedSize(true);
        rvChat.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        ((LinearLayoutManager) rvChat.getLayoutManager()).setStackFromEnd(true);
        rvChat.addOnItemTouchListener(new RecyclerItemClickListener(this, rvChat, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                if (adapter.itemHasError(position)) {
                    etMessage.setText(adapter.getItemMessage(position));
                    etMessage.setSelection(etMessage.getText().length());
                    return;
                }
            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));

    }

    @Override
    public void populateRecyclerView(ArrayList<EventMessage> mItems) {
        ((ChatMessagesRecyclerAdapter) rvChat.getAdapter()).replaceAll(mItems);
    }

    @Override
    public void loadUser() {
        User user = UserUtils.loadUser(this);
        AdaliveApplication.getInstance().setUser(user);
    }

    @Override
    public void showEmptyMessage() {
        tvEmptyList.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideEmptyMessage() {
        tvEmptyList.setVisibility(View.GONE);
    }

    @Override
    public void hideActivityProgress() {
        progressBar.setVisibility(View.GONE);
    }

    @Override
    public void addMessageToList(EventMessage eventMessage) {
        ((ChatMessagesRecyclerAdapter) rvChat.getAdapter()).add(eventMessage);
        int lastMessageIndex = rvChat.getAdapter().getItemCount() - 1;
        rvChat.smoothScrollToPosition(lastMessageIndex);
    }

    @Override
    public void updateMessage(int position, EventMessage messageSent) {
        ((ChatMessagesRecyclerAdapter) rvChat.getAdapter()).updateMessage(position, messageSent);
    }

    @Override
    public void clearEditText() {
        etMessage.setText("");
    }

    @Override
    public void disableEditTextField() {
        etMessage.setEnabled(false);
        btnSendMessage.setEnabled(false);
    }

    @Override
    public void showUserBlockedDialog() {
        atentionDialog(getString(R.string.ALERT_TITLE_CHAT_BLOCKED_USER), getString(R.string.ALERT_MESSAGE_CHAT_BLOCKED_USER), null);
    }

    @Override
    public void setUserLoggedIn(boolean shouldReturn) {
        isUserValid = shouldReturn;
    }

    @Override
    public void navigateToLoginActivity() {
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
        finish();
    }
    //endregion


    //region Action Button
    @OnClick(R.id.btnSendMessage)
    public void onClick() {
        String userMessage = etMessage.getText().toString();
        mPresenter.attemptToSendMessage(userMessage);
    }
    //endregion
}
