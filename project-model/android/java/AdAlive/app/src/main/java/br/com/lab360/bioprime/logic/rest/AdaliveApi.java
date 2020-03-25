package br.com.lab360.bioprime.logic.rest;


import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.BeaconResponse;
import br.com.lab360.bioprime.logic.model.pojo.AccountUserIdRequest;
import br.com.lab360.bioprime.logic.model.pojo.EventsResponse;
import br.com.lab360.bioprime.logic.model.pojo.RegisterEventResponse;
import br.com.lab360.bioprime.logic.model.pojo.RegisterUserEventRequest;
import br.com.lab360.bioprime.logic.model.pojo.Url;
import br.com.lab360.bioprime.logic.model.pojo.about.AboutResponse;
import br.com.lab360.bioprime.logic.model.pojo.account.CreateAccountRequest;
import br.com.lab360.bioprime.logic.model.pojo.account.FacebookLoginRequest;
import br.com.lab360.bioprime.logic.model.pojo.account.ForgotPasswordRequest;
import br.com.lab360.bioprime.logic.model.pojo.category.Category;
import br.com.lab360.bioprime.logic.model.pojo.category.SubCategoriesResponse;
import br.com.lab360.bioprime.logic.model.pojo.customer.Customer;
import br.com.lab360.bioprime.logic.model.pojo.customer.CustomerResponse;
import br.com.lab360.bioprime.logic.model.pojo.download.DocumentsFilesResponse;
import br.com.lab360.bioprime.logic.model.pojo.download.EventFilesResponse;
import br.com.lab360.bioprime.logic.model.pojo.layout.LayoutConfigResponse;
import br.com.lab360.bioprime.logic.model.pojo.account.LoginRequest;
import br.com.lab360.bioprime.logic.model.pojo.StatusResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.BannerResponse;
import br.com.lab360.bioprime.logic.model.pojo.user.UpdateUserRequest;
import br.com.lab360.bioprime.logic.model.pojo.user.User;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBlockStatusResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.ChatUserGroup;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetChatGroupsResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetSpeakersChatResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.GetUsersChatResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.SingleChatUsersResponse;
import br.com.lab360.bioprime.logic.model.pojo.chat.UserGroups;
import br.com.lab360.bioprime.logic.model.pojo.datasummary.DataSummaryResponse;
import br.com.lab360.bioprime.logic.model.pojo.menu.MenuResponse;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationRequest;
import br.com.lab360.bioprime.logic.model.pojo.notification.NotificationResponse;
import br.com.lab360.bioprime.logic.model.pojo.roles.RoleResponse;
import br.com.lab360.bioprime.logic.model.pojo.showcase.ShowCaseResponse;
import br.com.lab360.bioprime.logic.model.pojo.sponsor.SponsorsResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CreatePostRequest;
import br.com.lab360.bioprime.logic.model.pojo.timeline.CommentRequest;
import br.com.lab360.bioprime.logic.model.pojo.timeline.MessageResponse;
import br.com.lab360.bioprime.logic.model.pojo.timeline.Post;
import br.com.lab360.bioprime.logic.model.pojo.utils.CepResponse;
import br.com.lab360.bioprime.logic.model.pojo.videos.Videos;
import br.com.lab360.bioprime.logic.model.pojo.warningactions.WarningActionsResponse;
import br.com.lab360.bioprime.logic.model.v2.json.JSON_ResellerHolder;
import okhttp3.ResponseBody;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;
import rx.Observable;
import rx.Single;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */
public interface AdaliveApi {
    @POST("/api/v1/authenticate")
    Observable<User> postLogin(@Body LoginRequest request);

    @POST("/api/v1/authenticate/facebook")
    Observable<User> signFacebookLogin(@Body FacebookLoginRequest request);

    @POST("/api/v5/app_users/pre")
    Observable<User> postCreateAccount(@Body CreateAccountRequest request);

    @GET("/api/v1/{master_event_id}/events")
    Observable<EventsResponse> getEvents(@Path("master_event_id") int masterEventId);

    @POST("/api/v1/{master_event_id}/events/app_user/append")
    Observable<RegisterEventResponse> postRegisterUserToEvent(@Path("master_event_id") int masterEventId, @Body RegisterUserEventRequest request);

    @POST("/api/v1/{master_event_id}/events/app_user/remove")
    Observable<RegisterEventResponse> postUnregisterUserToEvent(@Path("master_event_id") int masterEventId, @Body RegisterUserEventRequest registerUserEventRequest);

    @GET("/api/v1/{master_event_id}/events/app_user/{id}")
    Observable<RegisterEventResponse> getUserRegisteredEvents(@Path("master_event_id") int masterEventId, @Path("id") int userId);

    @GET("/api/v1/{master_event_id}/events/{eventId}/files")
    Observable<EventFilesResponse> getEventFiles(@Path("master_event_id") int masterEventId, @Path("eventId") int eventId);

    @POST("/api/v1/app_users/change_password")
    Observable<StatusResponse> postForgotPassword(@Body ForgotPasswordRequest request);

    @PUT("/api/v5/app_users/update")
    Observable<UpdateUserRequest> updateUser(@Header("Authorization") String token, @Body UpdateUserRequest updateUserRequest);

    @GET("/api/v1/app_config_event")
    Observable<LayoutConfigResponse> getLayoutParams(@Query("app_id") int appId);


    @GET("/api/v1/sponsor_plans/{app_id}")
    Observable<ResponseBody> getSponsorsPlans(@Path("app_id") int appId);

    /**
     * Trazer Todos os usuários do chat
     */
    @GET("api/v1/app_users/{accountid}/app_users_devices/{userid}")
    Observable<GetUsersChatResponse> getChatUsers(@Path("accountid") int accountId, @Path("userid") int userId);

    /**
     * Trazer Todos os speakers do chat
     */
    @GET("api/v1/app_users/{accountid}/app_users_speaker/{userid}")
    Observable<GetSpeakersChatResponse> getSpeakerUsers(@Path("accountid") int accountId, @Path("userid") int userId);

    /**
     * Trazer os Usuários associados com o grupo
     */
    @GET("/api/v1/group_chats/app_users/{group_chat_id}/{accountid}")
    Observable<GetUsersChatResponse> getChatGroupUsers(@Path("group_chat_id") int id, @Path("accountid") int accountId);

    /**
     * Trazer os Grupos
     */
    @GET("/api/v1/group_chats/{account_id}")
    Observable<GetChatGroupsResponse> getChatGroups(@Path("account_id") int accountId);

    /**
     * Trazer os Grupos associados com os usuários
     */
    @GET("/api/v1/group_chats/groups/{app_user_id}/{account_id}")
    Observable<GetChatGroupsResponse> getChatUserGroups(@Path("app_user_id") int appUserId, @Path("account_id") int account_id);

    /**
     * Remover app_user ao group_chat
     * params: app_user_id, group_chat_id
     */
    @POST("/api/v1/group_chats/app_user/remove")
    Observable<UserGroups> removeChatUser(@Body ChatUserGroup request);

    /**
     * Adicionar app_user ao group_chat
     * params: app_user_id, group_chat_id
     */
    @POST("/api/v1/group_chats/app_user/append")
    Observable<UserGroups> addChatUser(@Body ChatUserGroup request);

    /**
     * Traz conversas ativas entre usuarios
     */
    @GET("/api/v1/single_chat_users/list/{id}")
    Observable<SingleChatUsersResponse> getSingleChatUsers(@Path("id") int userId, @Query("account_id") int accountId);

    /**
     * Desbloqueia usuário
     */
    @POST("/api/v1/single_chat_users/unblock/{id}")
    Observable<ChatBlockStatusResponse> postUnblockUser(@Path("id") int requesterId, @Body AccountUserIdRequest request);


    /**
     * Block User
     */
    @POST("/api/v1/single_chat_users/block/{id}")
    Observable<ChatBlockStatusResponse> postBlockUser(@Path("id") int requesterId, @Body AccountUserIdRequest request);


    //region TimeLine

    @GET("/api/v1/banners/timeline")
    Observable<BannerResponse> getBanners();

    /**
     * Post into timeline
     */
    @POST("/api/v1/posts")
    Observable<Post> createTimelinePost(@Body CreatePostRequest request);

    /**
     * List Post
     */
    @GET("/api/v1/{master_event_id}/posts")
    Observable<ArrayList<Post>> listTimelinePostsAll(@Path("master_event_id") int appId);

    @GET("/api/v1/{master_event_id}/posts")
    Observable<ArrayList<Post>> listTimelinePosts(@Path("master_event_id") int appId);

    @GET("/api/v1/{master_event_id}/posts")
    Observable<ArrayList<Post>> listTimelinePostsLimit(@Path("master_event_id") int appId, @Query("limit") int limit);

    /**
     * List Roles
     */

    @GET("/api/v1/job_roles/")
    Observable<RoleResponse> getJobsRoles(@Query("app_id") int appId);

    /**
     * Remove timeline post
     */
    @POST("/api/v1/{master_event_id}/{app_user_id}/posts/{post_id}/destroy")
    Observable<MessageResponse> removeTimelinePost(@Path("master_event_id") int appId, @Path("app_user_id") int userId, @Path("post_id") int postId);

    /**
     * Add like
     */
    @POST("/api/v1/posts/{post_id}/add_like/{app_user_id}")
    Observable<Post> likeTimelinePost(@Path("post_id") int postId, @Path("app_user_id") int userId);

    /**
     * Remove like
     */
    @POST("/api/v1/posts/{post_id}/remove_like/{app_user_id}")
    Observable<Post> unlikeTimelinePost(@Path("post_id") int postId, @Path("app_user_id") int userId);

    /**
     * Add Comment
     */
    @POST("/api/v1/posts/{post_id}/add_comment/{app_user_id}")
    Observable<Post> commentTimelinePost(@Path("post_id") int postId, @Path("app_user_id") int userId, @Body CommentRequest request);

    /**
     * Update Comment
     */
    @POST("/api/v1/posts/{post_id}/update_comment/{app_user_id}/{comment_post_id}")
    Observable<Post> updateTimelineComment(@Path("post_id") int postId, @Path("app_user_id") int userId, @Path("comment_post_id") int commentPostId, @Body CommentRequest request);

    /**
     * Remove Comment
     */
    @POST("/api/v1/{app_user_id}/posts/{post_id}/remove_comment/{comment_post_id}")
    Observable<Post> removeTimelineComment(@Path("post_id") int postId, @Path("app_user_id") int userId, @Path("comment_post_id") int commentPostId);
    //endregion

    /**
     * Send information about the action notification user was active.
     */
    @POST("/api/v1/notification/confirm")
    Observable<StatusResponse> postNotificationAction(@Body NotificationRequest request);

    /**
     * Trazer total de notifications
     */
    @GET("api/v1/data_in_app")
    Observable<DataSummaryResponse> getSummaryData(@Query("app_user_id") int appUserID);

    /**
     * Trazer notifications
     */
    @GET("api/v1/notifications_received/{app_user_id}")
    Observable<NotificationResponse> getNotifications(@Path("app_user_id") int appUserID);

    /**
     * Marca mensagens como lidas
     * /single_chats/:id/:app_user_id?sent_user_id=#
     * id = last message id
     * app_user_id = user
     * sent_user_id = sender
     */
    @POST("/api/v1/single_chats/{id}/{app_user_id}")
    Observable<ResponseBody> postReadMessage(@Path("id") int lastMessageID, @Path("app_user_id") int appUserID, @Query("sent_user_id") int userSender);

    /**
     * Trazer Todos os docuemntos do evento
     */
    @GET("api/v1/documents")
    Observable<DocumentsFilesResponse> getAllDocuments(@Query("master_event_id") int masterEvent, @Query("app_id") int appId);


    /**
     * Retrieve all user's orders
     */
    @GET("api/v1/info_profile")
    Observable<JSON_ResellerHolder> getMyProfile(@Header("Authorization") String userkey);

    /**
     * Get all videos to list video app.
     */
    @GET("/api/v1/videos")
    Observable<Videos> getVideos(@Query("master_event_id") int accountId);

    /**
     * Get sponsors.
     */
    @GET("/api/v1/{master_event_id}/sponsors")
    Observable<SponsorsResponse> getSponsors(@Path("master_event_id") int masterEventId);

    /**
     * Retrieve the customer data
     *
     * @param userkey The user key
     * @return
     */
    @GET("api/v1/shopping/customer")
    Observable<Customer> getCustomerData(@Header("Authorization") String userkey);

    /**
     * Retrieve the customer data using the cpf as reference
     *
     * @param userkey The user key
     * @param cpf     A CPF number (without punctuation)
     * @return
     */
    @GET("/api/v1/detail/customer/{cpf}")
    Observable<CustomerResponse> getCustomerByCPF(@Header("Authorization") String userkey, @Path("cpf") String cpf);

    /**
     * Get the cep directly from CEP
     *
     * @param
     * @return
     */
    @GET("/ws/{cepAdress}/json/")
    Observable<CepResponse> getAdress(@Path("cepAdress") String cepAdress);

    @GET("api/v1/categories")
    Observable<ArrayList<Category>> searchCategories(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("type_category") int typeCategory);

    @GET("api/v1/subcategories")
    Observable<SubCategoriesResponse> searchSubCategories(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("type_subcategory") int typeCategory, @Query("category_id") int categoryId, @Query("subcategory_id") int subCategoryId);

    @GET("api/v1/documents/search")
    Observable<DocumentsFilesResponse> searchDocumentsBySubCategory(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("subcategory_id") int subCategoryId);

    @GET("api/v1/documents/search")
    Single<DocumentsFilesResponse> searchDocumentsByCategoryAndSubCategory(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("category_id") int categoryId, @Query("subcategory_id") int subCategoryId);

    @GET("api/v1/documents/search")
    Observable<DocumentsFilesResponse> searchDocumentsByTag(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("tag") String tag);

    @GET("api/v1/videos/search")
    Observable<Videos> searchVideosBySubCategory(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("subcategory_id") int subCategoryId);

    @GET("api/v1/videos/search")
    Single<Videos> searchVideosByCategoryAndSubCategory(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("category_id") Integer categoryId, @Query("subcategory_id") Integer subCategoryId);

    @GET("api/v1/videos/search")
    Observable<Videos> searchVideosByTag(@Header("Authorization") String token, @Query("limit") String limit, @Query("offset") String offset, @Query("tag") String tag);


    /**
     * Used to have all rest api about warnings and stuff like that
     */

    @GET("/api/v1/config/alerts")
    Observable<WarningActionsResponse> getWarningActions(@Query("app_version") String appVersin, @Query("app_id") String appId);

    @GET("/api/v1/app_menus")
    Observable<MenuResponse> getMenu(@Query("app_id") int appId);
    /******************************************************/
    /******************* -- Beacons -- ********************/
    /******************************************************/

    @GET("/api/v2/beacons")
    Observable<BeaconResponse> getBeaconsMessageList(@Query("app_id") int appId);

    //******************************************************/
    //****************** -- Showcase -- ********************/
    //******************************************************/

    @GET("/api/v1/virtual_showcases")
    Single<ShowCaseResponse> getShowcaseItems();

    // ABOUT
    @GET("/api/v1/{app_id}/account_abouts")
    Observable<AboutResponse> getAccountAbouts(@Path("app_id") int appId);


    /******************************************************/
    /**************** -- Api Magento -- *******************/
    /******************************************************/
    @GET("/api/v1/magento/menu/{menu_id}")
    Observable<Url> getUrlMagento(@Header("Authorization") String token, @Path("menu_id") String id);
}

