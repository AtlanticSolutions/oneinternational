package br.com.lab360.bioprime.ui.activity.chat;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatUser;
import br.com.lab360.bioprime.logic.model.pojo.chat.SingleChatUser;
import br.com.lab360.bioprime.logic.presenter.chat.ChatGroupListPresenter;
import br.com.lab360.bioprime.ui.activity.NavigationDrawerActivity;
import br.com.lab360.bioprime.ui.activity.timeline.TimelineActivity;
import br.com.lab360.bioprime.ui.adapters.chat.ChatGroupRecyclerAdapter;
import br.com.lab360.bioprime.ui.adapters.chat.ChatSingleRecyclerAdapter;
import br.com.lab360.bioprime.ui.adapters.chat.SpeakerSingleRecyclerAdapter;
import br.com.lab360.bioprime.utils.ScreenUtils;
import br.com.lab360.bioprime.utils.UserUtils;
import br.com.lab360.bioprime.utils.customdialog.CustomDialogBuilder;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static android.view.View.GONE;

public class ChatGroupListActivity extends NavigationDrawerActivity implements ChatGroupListPresenter.IChatGroupListPresenterView {
    //region Binds
    @BindView(R.id.rvGroupChat)
    protected RecyclerView rvGroupChat;

    @BindView(R.id.rvTalkChat)
    protected RecyclerView rvTalkChat;

    @BindView(R.id.rvSpeakerChat)
    protected RecyclerView rvSpeakerChat;

    @BindView(R.id.tvEmptyListGroup)
    protected TextView tvEmptyListGroup;

    @BindView(R.id.tvEmptyListTalk)
    protected TextView tvEmptyListTalk;

    @BindView(R.id.tvEmptyListSpeaker)
    protected TextView tvEmptyListSpeaker;

    @BindView(R.id.btnAddGroup)
    protected ImageButton btnAddGroup;

    @BindView(R.id.ivGroup)
    protected ImageView ivGroup;

    @BindView(R.id.btnAddChat)
    protected ImageButton btnAddChat;

    @BindView(R.id.ivChat)
    protected ImageView ivChat;

    @BindView(R.id.txt_groups)
    protected TextView txt_groups;

    @BindView(R.id.txt_talks)
    protected TextView txt_talks;

    @BindView(R.id.txt_speakers)
    protected TextView txt_speakers;
    //endregion

    private ChatGroupListPresenter mPresenter;
    private boolean mBlockAddGroups;

    //region Android Lifecycle
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_group_list);
        ButterKnife.bind(this);

        /* By default do not block the button event. This will be blocked only for resellers.*/
        mBlockAddGroups = false;
        new ChatGroupListPresenter(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        mPresenter.onResume();
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
        Intent intent = new Intent(this, TimelineActivity.class);
        startActivity(intent);
        finish();
    }

    //endregion

    //region IChatGroupListPresenterView
    @Override
    public void setPresenter(ChatGroupListPresenter mPresenter) {
        this.mPresenter = mPresenter;
        this.mPresenter.start();
    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        setToolbarTitle(R.string.chat_title);

        //Paulo Create a generic method - Paulo
        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);

            ScreenUtils.updateStatusBarcolor(this, topColor);

            btnAddGroup.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
            ivGroup.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
            btnAddChat.setColorFilter(Color.parseColor(topColor), PorterDuff.Mode.SRC_IN);
            ivChat.setColorFilter(Color.parseColor(topColor));

            txt_groups.setTextColor(Color.parseColor(topColor));
            txt_talks.setTextColor(Color.parseColor(topColor));
            txt_speakers.setTextColor(Color.parseColor(topColor));

            String roleProfile = UserUtils.getRoleProfile(ChatGroupListActivity.this);

            /* Disable the add button */
            if (roleProfile.equalsIgnoreCase("reseller")) {
                /* just in case, prevent the click func. of the buttons */
                mBlockAddGroups = true;
                btnAddGroup.setVisibility(GONE);
            }
        }

        //rever
        ivMenu.setVisibility(GONE);
    }

    @Override
    public void setupRecyclerView() {
        ChatGroupRecyclerAdapter chatGroup = new ChatGroupRecyclerAdapter(this);
        ChatSingleRecyclerAdapter singleChatAdapter = new ChatSingleRecyclerAdapter(this);

        SpeakerSingleRecyclerAdapter singleSpeakerAdapter = new SpeakerSingleRecyclerAdapter(this);

        rvGroupChat.setAdapter(chatGroup);
        rvGroupChat.setHasFixedSize(true);
        rvGroupChat.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));

        rvTalkChat.setAdapter(singleChatAdapter);
        rvTalkChat.setHasFixedSize(true);
        rvTalkChat.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));

        rvSpeakerChat.setAdapter(singleSpeakerAdapter);
        rvSpeakerChat.setHasFixedSize(true);
        rvSpeakerChat.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
    }

    @Override
    public void populateGroupRecyclerView(ArrayList<BaseObject> mItems) {
        ((ChatGroupRecyclerAdapter) rvGroupChat.getAdapter()).replaceAll(mItems);
    }

    @Override
    public void populateSingleRecyclerView(ArrayList<SingleChatUser> mItems) {
        ((ChatSingleRecyclerAdapter) rvTalkChat.getAdapter()).replaceAll(mItems);
    }

    @Override
    public void populateSpeakerRecyclerView(ArrayList<ChatUser> mItems) {
        ((SpeakerSingleRecyclerAdapter) rvSpeakerChat.getAdapter()).replaceAll(mItems);
    }

    @Override
    public void navigateToGroup(BaseObject selectedGroup) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, true);
        intent.putExtra(AdaliveConstants.INTENT_TAG_CHAT, selectedGroup);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    @Override
    public void navigateToTalk(SingleChatUser selectedTalk) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, false);
        intent.putExtra(AdaliveConstants.INTENT_TAG_CHAT, new BaseObject(selectedTalk.getId(), selectedTalk.getName(), selectedTalk.getEmail()));
        intent.putExtra(AdaliveConstants.INTENT_TAG_BLOCK_STATUS, selectedTalk.getStatus());
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    @Override
    public void navigateToSpeaker(ChatUser selectedSpeaker) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, false);
        intent.putExtra(AdaliveConstants.INTENT_TAG_CHAT, new BaseObject(selectedSpeaker.getId(), selectedSpeaker.getFirstName(), selectedSpeaker.getEmail()));
//        intent.putExtra(AdaliveConstants.INTENT_TAG_BLOCK_STATUS, selectedTalk.getStatus());
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    @Override
    public void navigateToChatSearchActivity(ArrayList<BaseObject> mListChat) {
        Intent intent = new Intent(this, ChatSearchActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, false);
        intent.putParcelableArrayListExtra(AdaliveConstants.INTENT_TAG_GROUP_LIST, mListChat);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    @Override
    public void navigateToGroupSearchActivity(ArrayList<BaseObject> mListGroup) {
        Intent intent = new Intent(this, ChatSearchActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, true);
        intent.putParcelableArrayListExtra(AdaliveConstants.INTENT_TAG_GROUP_LIST, mListGroup);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    @Override
    public void updateSingleChat(int changedPosition) {
        rvTalkChat.getAdapter().notifyItemChanged(changedPosition);
    }

    @Override
    public void showRemoveGroupDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ATENTION,
                getString(R.string.ALERT_TITLE_LEAVE_GROUP),
                getString(R.string.ALERT_MESSAGE_LEAVE_CHAT),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_OK),
                R.color.white,
                R.drawable.background_button_yellow,
                onClickDialogButton(R.id.DIALOG_BUTTON_1)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CLOSE),
                R.color.white,
                R.drawable.gray_button_background,
                null
        );

        showCustomDialog();
    }

    @Override
    public void showBlockUserDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ATENTION,
                getString(R.string.ALERT_TITLE_BLOCK_USER),
                getString(R.string.ALERT_MESSAGE_CHAT_BLOCK),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_OK),
                R.color.white,
                R.drawable.background_button_yellow,
                onClickDialogButton(R.id.DIALOG_BUTTON_2)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CLOSE),
                R.color.white,
                R.drawable.gray_button_background,
                null
        );

        showCustomDialog();
    }

    @Override
    public void showUnblockUserDialog() {
        customDialog(
                CustomDialogBuilder.DIALOG_TYPE.ATENTION,
                getString(R.string.ALERT_TITLE_UNBLOCK_USER),
                getString(R.string.ALERT_MESSAGE_CHAT_UNBLOCK),
                0
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_OK),
                R.color.white,
                R.drawable.background_button_yellow,
                onClickDialogButton(R.id.DIALOG_BUTTON_3)
        );

        customDialogButton(
                getString(R.string.DIALOG_BUTTON_CLOSE),
                R.color.white,
                R.drawable.gray_button_background,
                null
        );

        showCustomDialog();
    }

    @Override
    public View.OnClickListener onClickDialogButton(final int id) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismissCustomDialog();
                switch (id) {
                    case R.id.DIALOG_BUTTON_1:
                        mPresenter.attemptToRemoveGroup();
                        break;
                    case R.id.DIALOG_BUTTON_2:
                        mPresenter.attemptToBlockUnblockUser();
                        break;
                    case R.id.DIALOG_BUTTON_3:
                        mPresenter.attemptToBlockUnblockUser();
                        break;
                }
            }
        };
    }

    @Override
    public void showUserUnblockErrorMessage() {
        showToastMessage(getString(R.string.ALERT_MESSAGE_BLOCK_UNBLOCK_USER_ERROR));
    }

    @Override
    public void showUserBlockErrorMessage() {
        showToastMessage(getString(R.string.ALERT_MESSAGE_BLOCK_UNBLOCK_USER_ERROR));
    }

    @Override
    public void showRemoveChatErrorMessage() {
        showToastMessage(getString(R.string.ALERT_MESSAGE_LEAVE_CHAT_ERROR));
    }

    @Override
    public void showGroupEmptyListText() {
        tvEmptyListGroup.setVisibility(View.VISIBLE);
    }

    @Override
    public void hideGroupEmptyListText() {
        tvEmptyListGroup.setVisibility(GONE);
    }

    @Override
    public void showSingleChatEmptyListText() {
        tvEmptyListTalk.setVisibility(View.VISIBLE);
    }

    @Override
    public void showSpeakerChatEmptyListText() {
//        tvEmptyListSpeaker.setVisibility(View.VISIBLE);

    }


    @Override
    public void hideSingleChatEmptyListText() {
        tvEmptyListTalk.setVisibility(GONE);
    }

    @Override
    public void hideSpeakerChatEmptyListText() {
        tvEmptyListSpeaker.setVisibility(GONE);

    }
    //endregion

    //region Button Actions
    @OnClick({R.id.btnAddChat, R.id.btnAddGroup})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btnAddChat:
                mPresenter.onBtnAddChatTouched();
                break;
            case R.id.btnAddGroup:
                /* This event will be blocked by resellers */
                if (mBlockAddGroups)
                    mPresenter.onBtnAddGroupTouched();
                break;
        }
    }
    //endregion
}
