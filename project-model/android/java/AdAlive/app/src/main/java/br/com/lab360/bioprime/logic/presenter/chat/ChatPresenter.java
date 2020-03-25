package br.com.lab360.bioprime.logic.presenter.chat;

import android.text.TextUtils;
import android.util.Log;

import com.google.gson.Gson;

import org.joda.time.DateTime;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.fcm.FireMsgService;
import br.com.lab360.bioprime.logic.interactor.ChatInteractor;
import br.com.lab360.bioprime.logic.listeners.Chat.OnChatRequestListener;
import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.EventMessage;
import br.com.lab360.bioprime.logic.model.pojo.chat.SingleChatUser;
import br.com.lab360.bioprime.logic.presenter.IBasePresenter;
import br.com.lab360.bioprime.logic.rxbus.RxQueues;
import br.com.lab360.bioprime.logic.rxbus.events.FcmMessageReceivedEvent;
import br.com.lab360.bioprime.ui.view.IBaseView;
import rx.Observer;
import rx.Subscription;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Action1;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class ChatPresenter implements IBasePresenter, OnChatRequestListener {
    private static final String BLOCKER_ERROR_MESSAGE = "SINGLE_CHAT_BLOQUED";
    private final long POOLING_DELAY_TIME_MILLI = 20000;

    private ChatInteractor mInteractor;
    private boolean notificationsEnabled;
    private IChatView mView;
    private String receivedMessageJson;
    private String status;

    private BaseObject mSelectedChat;

    private User mUser;
    private Subscription messageSubscription;
    private Subscription poolingSubscription;
    private ArrayList<EventMessage> mChatMessages;

    private boolean isGroup;
    private int mCurrentOperation;

    public ChatPresenter(IChatView view, BaseObject mSelectedChat, String receivedMessageJson, boolean notificationsEnabled, boolean isGroup, String status) {
        this.mChatMessages = new ArrayList<>();
        this.mView = view;
        this.notificationsEnabled = notificationsEnabled;
        this.mSelectedChat = mSelectedChat;
        this.receivedMessageJson = receivedMessageJson;
        this.mInteractor = new ChatInteractor(mView.getContext());
        this.isGroup = isGroup;
        this.status = status;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        AdaliveApplication.getInstance().setChatActive(true);
        mView.initToolbar(mSelectedChat.getName());
        mView.setupRecyclerView();


        if (!isUserLoggedIn()) {
            mView.navigateToLoginActivity();
            return;
        }
        mView.hideEmptyMessage();
        createBusSubscription();
        if (!notificationsEnabled) {
            createPoolingSubscription();
        }

        if (!TextUtils.isEmpty(status) && status.equals(SingleChatUser.UserStatus.BLOCKED)) {
            mView.disableEditTextField();
            mView.showUserBlockedDialog();
        }

        if (!TextUtils.isEmpty(receivedMessageJson)) {
            EventMessage receivedMessage = new Gson().fromJson(receivedMessageJson, EventMessage.class);
            mChatMessages.add(receivedMessage);
            mSelectedChat = new BaseObject();
            if (!TextUtils.isEmpty(receivedMessage.getGroupName())) {
                mSelectedChat.setId(receivedMessage.getGroupChatId());
                isGroup = true;
                mView.initToolbar(receivedMessage.getGroupName());
            } else {
                mSelectedChat.setId(receivedMessage.getSenderId());
                mSelectedChat.setName(receivedMessage.getSenderName());
                mView.initToolbar(receivedMessage.getSenderName());
            }
            addMessageToChat(receivedMessage);
        }

        findMessages();
    }

    public void attemptToSendMessage(String userMessage) {
        if (TextUtils.isEmpty(userMessage.trim())) {
            return;
        }

        mView.hideEmptyMessage();

        int userId = mUser.getId();
        String userName = mUser.getFirstName();
        String fcmToken = AdaliveApplication.getInstance().getFcmToken();

        EventMessage eventMessage = new EventMessage(userId, userMessage, userName);

        addMessageToChat(eventMessage);

        int position = mChatMessages.indexOf(eventMessage);
        eventMessage.setPosition(position);

        if (isGroup) {
            mCurrentOperation = RequestType.SEND_GROUP;
            mInteractor.sendGroupMessage(AdaliveConstants.ACCOUNT_ID, mSelectedChat.getId(), fcmToken, eventMessage, this);
        } else {
            mCurrentOperation = RequestType.SEND_SINGLE;
            mInteractor.sendSingleMessage(AdaliveConstants.ACCOUNT_ID, mSelectedChat.getId(), eventMessage, this);
        }

        mView.clearEditText();
    }

    private void addMessageToChat(EventMessage eventMessage) {
        //Before add, check if message is null, to create sections
        boolean isEmpty = mChatMessages.size() == 0;
        if (mChatMessages.size() == 0) {
            ArrayList<EventMessage> sectionList = new ArrayList<>();
            sectionList.add(eventMessage);
            mChatMessages.addAll(createSections(sectionList));
        } else {
            mChatMessages.add(eventMessage);
        }
        if (isEmpty) {
            mView.populateRecyclerView(mChatMessages);
            return;
        }
        mView.addMessageToList(eventMessage);
    }


    private boolean isUserLoggedIn() {
        mUser = AdaliveApplication.getInstance().getUser();
        if (mUser == null || mUser.getId() <= 0) {
            mView.loadUser();
            mView.setUserLoggedIn(false);
        }
        mUser = AdaliveApplication.getInstance().getUser();
        return mUser != null && mUser.getId() > 0;
    }

    private void createBusSubscription() {
        messageSubscription = FireMsgService.getBusInstance().subscribe(RxQueues.FCM_MESSAGE_RECEIVED, new Observer<FcmMessageReceivedEvent>() {
            @Override
            public void onCompleted() {

            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onNext(FcmMessageReceivedEvent fcmMessageReceivedEvent) {
                if (fcmMessageReceivedEvent.getChatMessage() != null) {
                    EventMessage receivedMessage = fcmMessageReceivedEvent.getChatMessage();
                    if (isGroup && receivedMessage.getGroupChatId() == mSelectedChat.getId()) {
                        addMessageToChat(receivedMessage);
                    } else if (receivedMessage.getSenderId() == mSelectedChat.getId()) {
                        addMessageToChat(receivedMessage);
                    }
                }
            }
        });
    }

    private void createPoolingSubscription() {
        poolingSubscription = rx.Observable.interval(0, POOLING_DELAY_TIME_MILLI, TimeUnit.MILLISECONDS)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Action1<Long>() {
                    public void call(Long aLong) {
                        if (mCurrentOperation > 0) {
                            findMessages();
                        }
                    }
                });
    }

    public void onDestroy() {
        if (messageSubscription != null && !messageSubscription.isUnsubscribed()) {
            messageSubscription.unsubscribe();
        }
        if (poolingSubscription != null && !poolingSubscription.isUnsubscribed()) {
            poolingSubscription.unsubscribe();
        }

        AdaliveApplication.getInstance().setChatActive(false);
    }

    private ArrayList<EventMessage> createSections(ArrayList<EventMessage> mItems) {
        int currentDay = new DateTime(Calendar.getInstance().getTimeInMillis()).getDayOfMonth();
        int lastSection = -1;
        ArrayList<EventMessage> sectionMessages = new ArrayList<>();
        for (int i = 0; i < mItems.size(); i++) {
            try {
                EventMessage section = new EventMessage();
                section.setSection(true);

                EventMessage item = mItems.get(i);

                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss", Locale.getDefault());
                String itemDate = item.getDate();
                if (TextUtils.isEmpty(itemDate)) {
                    itemDate = new DateTime(Calendar.getInstance().getTime()).toString("dd/MM/yyyy HH:mm:ss");
                }
                Date date = sdf.parse(itemDate);
                DateTime messageDate = new DateTime(date.getTime());

                sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());

                int messageDay = messageDate.getDayOfMonth();
                if (lastSection != messageDay) {
                    if (messageDay == currentDay) {
                        section.setMessage(mView.getResourceString(R.string.LABEL_CHAT_HEADER_TODAY));
                    } else if (messageDay == currentDay - 1) {
                        section.setMessage(mView.getResourceString(R.string.LABEL_CHAT_HEADER_YESTERDAY));
                    } else {
                        section.setMessage(sdf.format(date));
                    }
                    lastSection = messageDay;
                    sectionMessages.add(section);
                }

                sectionMessages.add(item);
            } catch (ParseException e) {
                Log.e(getClass().getSimpleName(), e.getMessage());
                continue;
            }
        }
        return sectionMessages;
    }

    //region OnChatRequestListener
    @Override
    public void onChatRequestError(String error, int requestType, int position) {
        switch (requestType) {
            case RequestType.FIND_SINGLE:
            case RequestType.FIND_GROUP:
                mView.showEmptyMessage();
                mView.hideActivityProgress();
                mView.populateRecyclerView(new ArrayList<EventMessage>());
                break;
            case RequestType.SEND_SINGLE:
            case RequestType.SEND_GROUP:
                EventMessage message = mChatMessages.get(position);
                message.setError(true);
                mChatMessages.set(position, message);
                mView.updateMessage(position, message);
                break;
        }
        mCurrentOperation = -1;
    }

    @Override
    public void onChatRequestSuccess(ChatBaseResponse response, int requestType, int position) {
        switch (requestType) {
            case RequestType.FIND_SINGLE:
            case RequestType.FIND_GROUP:
                onFindMessagesSuccess(response);
                break;
            case RequestType.SEND_SINGLE:
                onSingleMessageSent(response, position);
                break;
            case RequestType.SEND_GROUP:
                onGroupMessageSent(response, position);
                break;
        }
        mCurrentOperation = 0;
    }
    //endregion

    //region Private Methods
    private void findMessages() {
        if (isGroup) {
            mCurrentOperation = RequestType.FIND_GROUP;
            mInteractor.findGroupMessages(AdaliveConstants.ACCOUNT_ID, mSelectedChat.getId(), this);
            return;
        }
        mCurrentOperation = RequestType.FIND_SINGLE;
        mInteractor.findSingleMessages(AdaliveConstants.ACCOUNT_ID, mUser.getId(), mSelectedChat.getId(), this);
    }

    private void onFindMessagesSuccess(ChatBaseResponse response) {
        ArrayList<EventMessage> messages = response.getMessages();
        mView.hideActivityProgress();
        mView.hideEmptyMessage();
        if (messages == null || messages.size() == 0) {
            mView.showEmptyMessage();
            return;
        }
        if (!isGroup) {
            int userId = mUser.getId();
            for (EventMessage message : messages) {
                if (message.getSenderId() == userId) {
                    message.setSenderName(mUser.getFirstName());
                    continue;
                }
                message.setSenderName(mSelectedChat.getName());
            }
        }

        mChatMessages = createSections(response.getMessages());
        mView.populateRecyclerView((ArrayList<EventMessage>) mChatMessages.clone());

        if (mChatMessages.size() > 0) {
            EventMessage lastEvent = mChatMessages.get(mChatMessages.size() - 1);
            mInteractor.setReadChatMessage(AdaliveApplication.getInstance().getUser().getId(), mSelectedChat.getId(), lastEvent.getId());
        }

    }

    private void onGroupMessageSent(ChatBaseResponse response, int position) {
        if (!TextUtils.isEmpty(response.getErrorType())) {
            EventMessage message = mChatMessages.get(position);
            message.setError(true);
            mView.updateMessage(position, message);
            return;
        }
        try {
            response.getMessage().setMessage(URLDecoder.decode(response.getMessage().getMessage(), "UTF-8"));
            mChatMessages.set(position, response.getMessage());
            mView.updateMessage(position, response.getMessage());
        } catch (UnsupportedEncodingException e) {
            mChatMessages.set(position, response.getMessage());
        }
    }

    private void onSingleMessageSent(ChatBaseResponse response, int position) {
        if (!TextUtils.isEmpty(response.getErrorType())) {
            EventMessage message = mChatMessages.get(position);
            message.setError(true);
            mView.updateMessage(position, message);
            if (response.getErrorType().equals(BLOCKER_ERROR_MESSAGE)) {
                mView.disableEditTextField();
            }
            return;
        }
        try {
            response.getSingleMessage().setMessage(URLDecoder.decode(response.getSingleMessage().getMessage(), "UTF-8"));
            response.getSingleMessage().setSenderName(mUser.getFirstName());
            mChatMessages.set(position, response.getSingleMessage());
            mView.updateMessage(position, response.getSingleMessage());
        } catch (UnsupportedEncodingException e) {
            mChatMessages.set(position, response.getSingleMessage());
        }
    }
    //endregion

    public interface IChatView extends IBaseView {

        void initToolbar(String title);

        void setPresenter(ChatPresenter chatPresenter);

        void setupRecyclerView();

        void populateRecyclerView(ArrayList<EventMessage> mItems);

        void loadUser();

        void navigateToLoginActivity();

        void showEmptyMessage();

        void hideEmptyMessage();

        void hideActivityProgress();

        void addMessageToList(EventMessage eventMessage);

        void updateMessage(int position, EventMessage messageSent);

        void clearEditText();

        void disableEditTextField();

        void showUserBlockedDialog();

        void setUserLoggedIn(boolean shouldReturn);
    }
}