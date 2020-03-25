package br.com.lab360.bioprime.logic.interactor;

import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.listeners.Chat.OnAddChatUserListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnChatRequestListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnGetChatSpeakersListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnGetChatUsersListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnGetSingleChatUsersListener;
import br.com.lab360.bioprime.logic.listeners.OnGroupLoadedListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnRemoveChatUserListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnUserBlockedListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnUserGroupLoadedListener;
import br.com.lab360.bioprime.logic.listeners.Chat.OnUserUnblockedListener;
import br.com.lab360.bioprime.logic.model.pojo.AccountUserIdRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBlockStatusResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatUserGroup;
import br.com.lab360.bioprime.logic.model.pojo.chat.EventMessage;
import br.com.lab360.bioprime.logic.model.pojo.chat.FindGroupMessagesRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.FindSingleMessagesRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetChatGroupsResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetSpeakersChatResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetUsersChatResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.OnGetChatUsersGroupListener;
import br.com.lab360.bioprime.logic.model.pojo.chat.RegisterDeviceRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.SendGroupMessageRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.SendSingleMessageRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.SingleChatUsersResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.UnregisterDeviceRequest;
import br.com.lab360.bioprime.logic.model.pojo.chat.UserGroups;
import br.com.lab360.bioprime.logic.rest.AdaliveApi;
import br.com.lab360.bioprime.logic.rest.ApiManager;
import br.com.lab360.bioprime.logic.rest.ChatApi;
import okhttp3.ResponseBody;
import rx.Subscriber;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class ChatInteractor extends BaseInteractor {

    public ChatInteractor(Context context) {
        super(context);
    }

    /**
     * Trazer os Grupos associados com o usuário
     */
    public void getUserGroups(int accountId, int userId, final OnUserGroupLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getChatUserGroups(userId, accountId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<GetChatGroupsResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUserGroupsLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(GetChatGroupsResponse response) {
                        listener.onUserGropsLoadSuccess(response.getGroups());

                    }
                });
    }

    /**
     * Trazer os Grupos
     */
    public void getChatGroups(int accountId, final OnGroupLoadedListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getChatGroups(accountId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<GetChatGroupsResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onActiveGroupsLoadError(e.getMessage());
                    }

                    @Override
                    public void onNext(GetChatGroupsResponse response) {
                        listener.onActiveGroupsLoadSuccess(response.getGroups());
                    }
                });
    }

    /**
     * Trazer Todos os usuários do chat
     */
    public void getChatUsers(int accountId, int userId, final OnGetChatUsersListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getChatUsers(accountId, userId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<GetUsersChatResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetChatUsersError(e.getMessage());
                    }

                    @Override
                    public void onNext(GetUsersChatResponse response) {
                        listener.onGetChatUsersSuccess(response.getChatUsers());
                    }
                });
    }

    /**
     * Trazer Todos os usuários do chat
     */
    public void getSpeakerUsers(int accountId, int userId, final OnGetChatSpeakersListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getSpeakerUsers(accountId, userId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<GetSpeakersChatResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetChatSpeakerError(e.getMessage());
                    }

                    @Override
                    public void onNext(GetSpeakersChatResponse response) {
                        listener.onGetChatSpeakerSuccess(response.getChatSpeakers());
                    }
                });
    }


    /**
     * Trazer os Usuários associados com o grupo
     */
    public void getChatGroupUsers(int userId, int accountId, final OnGetChatUsersGroupListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getChatGroupUsers(userId, accountId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<GetUsersChatResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetChatGroupUsersError(e.getMessage());
                    }

                    @Override
                    public void onNext(GetUsersChatResponse response) {
                        listener.onGetChatGroupUsersSuccess(response.getChatUsers());
                    }
                });
    }

    /**
     * Remover app_user ao group_chat
     * params: app_user_id, group_chat_id
     */
    public void removeChatUser(int userId, int groupId, final OnRemoveChatUserListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);
        adaliveApi.removeChatUser(new ChatUserGroup(userId,groupId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<UserGroups>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onRemoveChatUserError(e.getMessage());
                    }

                    @Override
                    public void onNext(UserGroups response) {
                        listener.onRemoveChatUserSuccess(response.getGroups());
                    }
                });
    }

    /**
     * Adicionar app_user ao group_chat
     * params: app_user_id, group_chat_id
     */
    public void addChatUser(int userId, int groupId, final OnAddChatUserListener listener) {
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.addChatUser(new ChatUserGroup(userId,groupId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<UserGroups>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onAddChatUserError(e.getMessage());
                    }

                    @Override
                    public void onNext(UserGroups response) {
                        listener.onAddChatUserSuccess(response.getGroups());
                    }
                });
    }

    /**
     * Traz conversas ativas entre usuarios
     */
    public void getSingleChatUsers(int accountId, int userId, final OnGetSingleChatUsersListener listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.getSingleChatUsers(userId,accountId)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<SingleChatUsersResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onGetSingleChatUsersError(e.getMessage());
                    }

                    @Override
                    public void onNext(SingleChatUsersResponse response) {
                        listener.onGetSingleChatUsersSuccess(response.getSingleChatUsers());
                    }
                });
    }
    /**
     * Bloqueia usuário
     */
    public void blockChatUser(int accountId, int userId, int blockedUserId, final OnUserBlockedListener listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postBlockUser(userId, new AccountUserIdRequest(accountId,blockedUserId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ChatBlockStatusResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUserBlockedError(e.getMessage());
                    }

                    @Override
                    public void onNext(ChatBlockStatusResponse response) {
                        listener.onUserBlockedSuccess();
                    }
                });
    }
    /**
     * Desbloqueia usuário
     */
    public void unblockChatUser(int accountId, int userId, int blockedUserId, final OnUserUnblockedListener listener){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postUnblockUser(userId, new AccountUserIdRequest(accountId,blockedUserId))
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ChatBlockStatusResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        listener.onUserUnblockedError(e.getMessage());
                    }

                    @Override
                    public void onNext(ChatBlockStatusResponse response) {
                        listener.onUserUnblockedSuccess();
                    }
                });
    }


    public void registerDeviceId(int accountId, int userId, String deviceId, OnChatRequestListener listener) {
        RegisterDeviceRequest request = new RegisterDeviceRequest(accountId, userId, deviceId);

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.REGISTER, -1);
    }

    public void unregisterDeviceId(int accountId, int userId, String deviceId, OnChatRequestListener listener) {
        UnregisterDeviceRequest request = new UnregisterDeviceRequest(accountId, userId, deviceId);

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.UNREGISTER, -1);
    }

    public void sendGroupMessage(int accountId, int groupId, String deviceId, EventMessage message, OnChatRequestListener listener) {
        SendGroupMessageRequest request = null;
        try {
            request = new SendGroupMessageRequest(accountId, message.getId(), groupId, deviceId, URLEncoder.encode(message.getMessage(), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            request = new SendGroupMessageRequest(accountId, message.getId(), groupId, deviceId, message.getMessage());
        }

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.SEND_GROUP, message.getPosition());
    }

    public void findGroupMessages(int accountId, int groupId, OnChatRequestListener listener) {
        FindGroupMessagesRequest request = new FindGroupMessagesRequest(accountId, groupId, 0);

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.FIND_GROUP, -1);
    }

    public void sendSingleMessage(int accountId, int receiveId, EventMessage message, OnChatRequestListener listener) {
        SendSingleMessageRequest request = null;
        try {
            request = new SendSingleMessageRequest(accountId, message.getId(), receiveId, URLEncoder.encode(message.getMessage(), "UTF-8"));
        } catch (UnsupportedEncodingException e) {
            request = new SendSingleMessageRequest(accountId, message.getId(), receiveId, message.getMessage());
        }

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.SEND_SINGLE, message.getPosition());
    }

    public void findSingleMessages(int accountId, int userId1, int userId2, OnChatRequestListener listener) {
        FindSingleMessagesRequest request = new FindSingleMessagesRequest(accountId, userId1, userId2, 0);

        Gson gson = new Gson();
        String jsonRequest = gson.toJson(request);
        postChatAction(jsonRequest, listener, OnChatRequestListener.RequestType.FIND_SINGLE, -1);
    }

    private void postChatAction(String jsonRequest, final OnChatRequestListener listener, final int requestType, final int position) {

        ChatApi chatApi = ApiManager.getInstance().getChatApiInstance(context);

        if (chatApi != null) {

            chatApi.postChatAction(jsonRequest)
                    .subscribeOn(Schedulers.newThread())
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(new Subscriber<ChatBaseResponse>() {
                        @Override
                        public void onCompleted() {

                        }

                        @Override
                        public void onError(Throwable e) {
                            listener.onChatRequestError(AdaliveApplication.getInstance().getString(R.string.ERROR_ALERT_MESSAGE_AUTHENTICATION), requestType, position);
                        }

                        @Override
                        public void onNext(ChatBaseResponse response) {
                            listener.onChatRequestSuccess(response, requestType, position);
                        }
                    });
        } else {
            Log.v(AdaliveConstants.ERROR, "*** CHAT URL is null ***");
        }
    }


    public void setReadChatMessage(int userID, int senderID, int lastMessageID){
        AdaliveApi adaliveApi = ApiManager.getInstance().getAdaliveApiInstance(context);

        adaliveApi.postReadMessage(lastMessageID, userID, senderID)
                .subscribeOn(Schedulers.newThread())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<ResponseBody>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.v(AdaliveConstants.ERROR, e.getMessage());
                    }

                    @Override
                    public void onNext(ResponseBody response) {

                        Log.v("Success", response.toString());

                    }
                });
    }
}
