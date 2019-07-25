package br.com.lab360.oneinternacional.logic.presenter.chat;

import androidx.annotation.NonNull;
import android.view.View;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.ChatInteractor;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnGetChatSpeakersListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnGetSingleChatUsersListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnRemoveChatUserListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnUserBlockedListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnUserGroupLoadedListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnUserUnblockedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatUser;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.SingleChatUser;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.ChatEnterEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.ChatExitEvent;
import br.com.lab360.oneinternacional.logic.rxbus.events.SingleChatBlockEvent;
import br.com.lab360.oneinternacional.ui.view.IBaseView;
import rx.Observer;
import rx.Subscription;

import static com.google.common.base.Preconditions.checkNotNull;

/**
 * Created by Thiago Faria on 05/12/2016.
 */
public class ChatGroupListPresenter implements IBasePresenter,
        OnUserGroupLoadedListener,
        OnRemoveChatUserListener,
        OnGetSingleChatUsersListener,
        OnGetChatSpeakersListener,
        OnUserUnblockedListener,
        OnUserBlockedListener {

    private IChatGroupListPresenterView mView;

    private final ChatInteractor mInteractor;
    private ArrayList<BaseObject> mListGroup;
    private ArrayList<SingleChatUser> mListSingle;
    private ArrayList<ChatUser> mListSpeaker;

    private Subscription chatEnterEventSubscription, chatExitEventSubscription, singleChatBlockEventSubscription;
    private int removedPosition, blockedPosition;

    public ChatGroupListPresenter(@NonNull IChatGroupListPresenterView view) {
        this.mView = checkNotNull(view, "View cannot be null");
        this.mInteractor = new ChatInteractor(mView.getContext());
        this.mView.setPresenter(this);
    }

    //region Public methods
    @Override
    public void start() {
        mView.initToolbar();
        mView.setupRecyclerView();
        createSubscriptions();
        callGetGroups();
        callGetSingleChats();
        callGetSpeakerChats();
    }

    public void onResume() {
        callGetGroups();
        callGetSingleChats();
    }

    public void onDestroy(){
        if(!singleChatBlockEventSubscription.isUnsubscribed()){
            singleChatBlockEventSubscription.unsubscribe();
        }
        if(!chatExitEventSubscription.isUnsubscribed()){
            chatExitEventSubscription.unsubscribe();
        }
        if(!chatEnterEventSubscription.isUnsubscribed()){
            chatEnterEventSubscription.unsubscribe();
        }
    }
    // endregion

    //region Private Methods
    private void callGetGroups() {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
        mView.showProgress();
        User mUser = AdaliveApplication.getInstance().getUser();
        mInteractor.getUserGroups(AdaliveConstants.ACCOUNT_ID, mUser.getId(), this);
    }

    private void callGetSingleChats() {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
        mView.showProgress();
        User mUser = AdaliveApplication.getInstance().getUser();
        mInteractor.getSingleChatUsers(AdaliveConstants.ACCOUNT_ID, mUser.getId(), this);
    }

    private void callGetSpeakerChats() {
        if (!mView.isOnline()) {
            mView.showNoConnectionSnackMessage();
            return;
        }
        mView.showProgress();
        User mUser = AdaliveApplication.getInstance().getUser();
        mInteractor.getSpeakerUsers(AdaliveConstants.ACCOUNT_ID, mUser.getId(), this);
    }

    private void createSubscriptions() {
        chatEnterEventSubscription = AdaliveApplication.getBus().subscribe(RxQueues.CHAT_ENTER_BTN_EVENT, new Observer<ChatEnterEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(ChatEnterEvent chatEnterEvent) {

                if (chatEnterEvent.isGroup()) {
                    BaseObject selectedGroup = mListGroup.get(chatEnterEvent.getPosition());
                    mView.navigateToGroup(selectedGroup);
                    return;
                } else if (chatEnterEvent.isSpeaker()){
                    ChatUser selectedSpeaker = mListSpeaker.get(chatEnterEvent.getPosition());
                    mView.navigateToSpeaker(selectedSpeaker);
                    return;
                }


                SingleChatUser selectedGroup = mListSingle.get(chatEnterEvent.getPosition());
//                mInteractor.setReadChatMessage(AdaliveApplication.getInstance().getUser().getId(),
//                        selectedGroup.getId(), );

                mView.navigateToTalk(selectedGroup);
            }
        });

        chatExitEventSubscription = AdaliveApplication.getBus().subscribe(RxQueues.CHAT_EXIT_BTN_EVENT, new Observer<ChatExitEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(ChatExitEvent chatExitEvent) {
                removedPosition = chatExitEvent.getPosition();
                mView.showRemoveGroupDialog();
            }
        });

        singleChatBlockEventSubscription = AdaliveApplication.getBus().subscribe(RxQueues.SINGLE_CHAT_BLOCK_BTN_EVENT, new Observer<SingleChatBlockEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(SingleChatBlockEvent singleChatBlockEvent) {
                blockedPosition = singleChatBlockEvent.getPosition();

                SingleChatUser selectedChat = mListSingle.get(blockedPosition);
                if(selectedChat.getStatus().equals(SingleChatUser.UserStatus.ACTIVE)) {
                    mView.showBlockUserDialog();
                    return;
                }
                mView.showUnblockUserDialog();
            }
        });
    }

    public void attemptToRemoveGroup(){
        BaseObject selectedGroup = mListGroup.get(removedPosition);
        User user = AdaliveApplication.getInstance().getUser();
        mInteractor.removeChatUser(user.getId(), selectedGroup.getId(), this);
    }

    public void attemptToBlockUnblockUser(){
        User mUser = AdaliveApplication.getInstance().getUser();
        SingleChatUser selectedChat = mListSingle.get(blockedPosition);
        mView.showProgress();
        if(selectedChat.getStatus().equals(SingleChatUser.UserStatus.ACTIVE)){
            mInteractor.blockChatUser(AdaliveConstants.ACCOUNT_ID,mUser.getId(),selectedChat.getId(),ChatGroupListPresenter.this);
            return;
        }
        mInteractor.unblockChatUser(AdaliveConstants.ACCOUNT_ID,mUser.getId(),selectedChat.getId(),ChatGroupListPresenter.this);
    }

    //endregion

    //region Button Events
    public void onBtnAddChatTouched() {
        ArrayList<BaseObject> mListSingleBaseObject = new ArrayList<>();
        for(SingleChatUser user : mListSingle){
            mListSingleBaseObject.add( new BaseObject(user.getId(), user.getName(), user.getEmail() ));
        }
        mView.navigateToChatSearchActivity(mListSingleBaseObject);
    }

    public void onBtnAddGroupTouched() {
        mView.navigateToGroupSearchActivity(mListGroup);
    }
    //endregion

    //region OnRemoveChatUserListener
    @Override
    public void onRemoveChatUserSuccess(ArrayList<Integer> groups) {
        mView.hideProgress();
        mListGroup.remove(removedPosition);
        mView.populateGroupRecyclerView(mListGroup);
        removedPosition = -1;
        if (groups.size() == 0)
            mView.showGroupEmptyListText();
    }

    @Override
    public void onRemoveChatUserError(String message) {
        mView.hideProgress();
        mView.showRemoveChatErrorMessage();
    }
    //endregion

    //region OnUserGroupLoadedListener
    @Override
    public void onUserGropsLoadSuccess(ArrayList<BaseObject> groups) {
        mListGroup = groups;
        mView.hideProgress();
        mView.populateGroupRecyclerView(groups);

        if (groups.size() == 0) {
            mView.showGroupEmptyListText();
            return;
        }
        mView.hideGroupEmptyListText();
    }

    @Override
    public void onUserGroupsLoadError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }

    //endregion

    //region OnGetSingleChatUsersListener
    @Override
    public void onGetSingleChatUsersSuccess(ArrayList<SingleChatUser> chats) {
        mListSingle = chats;
        mView.hideProgress();
        mView.populateSingleRecyclerView(chats);

        if (chats.size() == 0) {
            mView.showSingleChatEmptyListText();
            return;
        }
        mView.hideSingleChatEmptyListText();
    }


    @Override
    public void onGetSingleChatUsersError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }
    //endregion

    //region OnUserUnblockedListener
    @Override
    public void onUserUnblockedError(String message) {
        mView.hideProgress();
        mView.showUserUnblockErrorMessage();
    }

    @Override
    public void onUserUnblockedSuccess() {
        mView.hideProgress();
        mListSingle.get(blockedPosition).changeStatus();
        mView.updateSingleChat(blockedPosition);
    }
    //endregion

    //region OnUserBlockedListener
    @Override
    public void onUserBlockedSuccess() {
        mView.hideProgress();
        mListSingle.get(blockedPosition).changeStatus();
        mView.updateSingleChat(blockedPosition);
    }

    @Override
    public void onUserBlockedError(String message) {
        mView.hideProgress();
        mView.showUserBlockErrorMessage();
    }

    @Override
    public void onGetChatSpeakerError(String message) {
        mView.hideProgress();
        mView.showUserBlockErrorMessage();
    }

    @Override
    public void onGetChatSpeakerSuccess(ArrayList<ChatUser> chatUsers) {

        mListSpeaker = chatUsers;
        mView.hideProgress();
        mView.populateSpeakerRecyclerView(chatUsers);

        if (chatUsers.size() == 0) {
            mView.showSpeakerChatEmptyListText();
            return;
        }
        mView.hideSpeakerChatEmptyListText();

    }


    public interface IChatGroupListPresenterView extends IBaseView {

        void setPresenter(ChatGroupListPresenter chatGroupListPresenter);

        void initToolbar();

        void setupRecyclerView();

        void populateGroupRecyclerView(ArrayList<BaseObject> mItems);

        void populateSingleRecyclerView(ArrayList<SingleChatUser> mItems);

        void populateSpeakerRecyclerView(ArrayList<ChatUser> mItems);

        void hideSingleChatEmptyListText();

        void hideSpeakerChatEmptyListText();

        void hideGroupEmptyListText();

        void showGroupEmptyListText();

        void showSingleChatEmptyListText();

        void showSpeakerChatEmptyListText();

        void navigateToGroup(BaseObject selectedGroup);

        void navigateToTalk(SingleChatUser selectedGroup);

        void navigateToSpeaker(ChatUser selectedSpeaker);

        void navigateToChatSearchActivity(ArrayList<BaseObject> mListGroup);

        void navigateToGroupSearchActivity(ArrayList<BaseObject> mListGroup);

        void updateSingleChat(int changedPosition);

        void showRemoveGroupDialog();

        void showBlockUserDialog();

        void showUnblockUserDialog();

        void showUserUnblockErrorMessage();

        void showUserBlockErrorMessage();

        void showRemoveChatErrorMessage();

        View.OnClickListener onClickDialogButton(int id);
    }
}