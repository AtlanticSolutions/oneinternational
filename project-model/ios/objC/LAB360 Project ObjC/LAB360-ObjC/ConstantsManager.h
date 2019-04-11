//
//  ConstantsManager.h
//  DefaultModelProject
//
//  Created by Erico GT on 9/15/16.
//  Copyright © 2016 Atlantic Solutions. All rights reserved.
//

/**
 @brief     Use it to write a short description about the method, property, class, file, struct, or enum you’re documenting. No line breaks are allowed..
 @author    Author os method.
 @discussion    Use it to write a thorough description. You can add line breaks if needed.
 @param     With this you can describe a parameter of a method or function. You can have multiple such tags.
 @return    Use it to specify the return value of a method or function.
 @see   Use it to indicate other related method or functions. You can have multiple such tags.
 @code  With this tag, you can embed code snippets in the documentation. When viewing the documentation in Help Inspector, the code is represented with a different font, inside a special box.
 @endcode   Always use the @endcode tag when you finish writing code.
 @remark    Use it to highlight any special facts about the code you’re currently documenting.
 */

//=======================================================================================================
#pragma mark - • MACROS
//=======================================================================================================
//Instância da aplicação (pode ser utilizada em qualquer view da aplicação, bastando importar 'AppDelegate')
#define AppD ((AppDelegate *)[UIApplication sharedApplication].delegate)
//iPad verification
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define DEVICE_IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

//Servidor
#define MACRO_MASTER_URL(MASTER_URL) #MASTER_URL
#define VALUE_MASTER_URL(MASTER_URL) MACRO_MASTER_URL(MASTER_URL)

#define MACRO_APP_ID(APP_ID) #APP_ID
#define VALUE_APP_ID(APP_ID) MACRO_APP_ID(APP_ID)
//Conversor
#define UIColorFromHEX(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SYSTEM_VERSION_LESS_THAN_10  ([[UIDevice currentDevice].systemVersion floatValue] > 10.0)

//=======================================================================================================
#pragma mark - • DOMINIO APP (constantes de projeto)
//=======================================================================================================

#define APP_ACCOUNT_ID 1
#define MASTER_SERVER_URL @"http://master.ad-alive.com/api/v1/master_apps"
#define BASE_APP_URL @"url_adalive"
#define BASE_CHAT_URL @"url_chat"
#define VUFORIA_LICENSE_KEY @"vuforia_license_key"
#define VUFORIA_SECRET_KEY @"vuforia_secret_key"
#define VUFORIA_ACCESS_KEY @"vuforia_access_key"


//=======================================================================================================
#pragma mark - • AdAlive Keys
//=======================================================================================================

#define SURVEY_ID @"id"
#define SURVEY_NAME @"name"
#define SURVEY_QUESTIONS @"questions"
#define SURVEY_OPTIONS @"question_options"
//
#define QUIZ_QUESTION_KEY @"query"
#define QUIZ_ANSWER_ARRAY_KEY @"answers"
#define QUIZ_ANSWER_ITEM_KEY @"content"
//
#define LOG_TARGET_NAME_KEY @"target_name"
#define LOG_LATITUDE_KEY @"latitude"
#define LOG_LONGITUDE_KEY @"longitude"
//
#define LOG_ID_ACTION_KEY @"action_id"
#define LOG_ACTION_NAME_KEY @"action_name"
#define LOG_PRODUCT_NAME_KEY @"product_name"
#define LOG_PRODUCT_ID @"product_id"
#define LOG_SENDER_NAME @"sender_name"
#define LOG_FROM_PRODUCT_ID @"from_product_id"
#define LOG_PRODUCT_QUANTITY @"product_quantity"
#define LOG_CUSTOMER_IDENTIFICATION @"customer_identification"
//
#define LOG_SENDER_RECOMENDATION @"RECOMENDATION"
#define LOG_SENDER_IDENTIFIED @"IDENTIFIED"
#define LOG_SENDER_CATALOG @"CATALOG"
#define LOG_SENDER_FAVORITE @"FAVORITE"
//
#define LOG_DEVICE_NAME_KEY @"device_name"
#define LOG_DEVICE_SYSTEM_NAME_KEY @"device_system_name"
#define LOG_DEVICE_SYSTEM_VERSION_KEY @"device_system_version"
#define LOG_DEVICE_SYSTEM_MODEL_KEY @"device_model"
#define LOG_DEVICE_ID_VENDOR_KEY @"device_id_vendor"
#define LOG_DEVICE_VERSION_KEY @"device_version"
#define LOG_LOGGED_USER @"User Authenticated"
#define LOG_ORDER_COMPANY_TRADING @"company_trading_name"
#define LOG_ORDER_COMPANY_NAME @"company_name"
#define LOG_ORDER_DISCOUNT @"discount"
#define LOG_ORDER_BUSINESS_CONDITION @"business_condition"
#define LOG_ORDER_COLOR @"colour_code"
//
#define SERVICE_URL_LOG_TARGET @"/api/v1/logs/target"
#define SERVICE_URL_LOG_ACTION @"/api/v1/logs/action"
#define SERVICE_URL_LOG_DEVICE @"/api/v1/logs/device"
#define SERVICE_URL_LOG_PRODUCT @"/api/v1/logs/product"
#define SERVICE_URL_LOG_ORDER @"/api/v1/logs/order"
#define SERVICE_URL_COUPON @"/api/v1/coupons"
#define SERVICE_URL_VOUCHER @"/api/v1/vouchers"
#define SERVICE_URL_BANNER @"/api/v1/logs/banner"
#define SERVICE_URL_BANNER_CLICK @"/api/v1/logs/banner_click"
#define SERVICE_URL_SURVEY @"/api/v1/surveys"
#define SERVICE_URL_SURVEY_LOG @"/api/v1/logs/survey"
#define SERVICE_URL_LOG_TRACKING @"/api/v1/logs/user_tracking"
#define SERVICE_URL_BEACON_LOG @"/api/v1/logs/beacon"
#define SERVICE_URL_MASK_LOG @"/api/v1/logs/mask"
//
#define SERVICE_URL_GET_PRODUCT @"/api/v1/products/target/"
#define SERVICE_URL_GET_PRODUCT_ID @"/api/v1/products/"
#define URL_REGISTER_PAGE @"/app_users/new"
#define SERVICE_URL_GET_CATALOG @"/api/v1/products"
#define SERVICE_URL_GET_ORDERS @"/api/v1/orders"
#define SERVICE_URL_GET_CUSTOMERS @"/api/v1/app_customers"
#define SERVICE_URL_AUTHENTICATE @"/api/v1/authenticate"
#define SERVICE_URL_REGISTER @"/api/v1/app_users"
#define SERVICE_URL_FACE_AUTHENTICATE @"/api/v1/authenticate/facebook"
#define SERVICE_URL_PROFILE @"/api/v1/profile"
#define SERVICE_URL_CONFIG @"/api/v1/app_config"
#define SERVICE_URL_PROMOTION @"/api/v1/promotions"
#define SERVICE_URL_MASK_COLLECTION @"/api/v1/masks/collection"
//
#define SERVICE_URL_MA_GET_PRODUCTS @"/api/v1/ma_products?date=<date>"
#define SERVICE_URL_MA_GET_ALL_CATALOGS @"/api/v1/ma_catalogs"
#define SERVICE_URL_MA_GET_ALL_CATEGORIES @"/api/v1/ma_categories"
#define SERVICE_URL_MA_GET_PREPAYMENT_ORDER @"/api/v1/ma_pre_send_information_order"
#define SERVICE_URL_MA_GET_ORDER_ITEMS_DETAIL @"/api/v1/ma_order_information/<order_id>"
#define SERVICE_URL_MA_POST_SEND_SHOP_ORDER @"/api/v1/tab_ma_orders/order"
//
#define SERVICE_URL_SHOPPING_GET_PROMOTIONS @"/api/v1/shopping/promotions/app/<app_id>"
#define SERVICE_URL_SHOPPING_POST_REGISTER_PROMOTION @"/api/v1/shopping/promotion/register"
#define SERVICE_URL_SHOPPING_GET_MY_INVOICES @"/api/v1/shopping/nfs"
#define SERVICE_URL_SHOPPING_POST_INVOICE_PHOTO @"/api/v1/shopping/send/nf"
#define SERVICE_URL_SHOPPING_GET_STORES @"/api/v1/shopping/stores/app/<app_id>"
#define SERVICE_URL_SHOPPING_GET_COSTUMER @"/api/v1/shopping/customer"
#define SERVICE_URL_SHOPPING_GET_COSTUMER_CPF @"/api/v1/detail/customer/<cpf>"
#define SERVICE_URL_SHOPPING_GET_EXTRACT_PROMOTION @"/api/v1/customer/status/campaigns/<promotion_id>"
#define SERVICE_URL_SHOPPING_POST_EXTRACT_PROMOTION @"/api/v1/perform/exchange/campaigns/<promotion_id>/customer/<cpf>"
#define SERVICE_URL_GET_ABOUT @"/api/v1/<APPID>/account_abouts"
//
#define SERVICE_URL_PROMOTION_GETCOUPONDATA @"/api/v1/promotions/coupon"
#define SERVICE_URL_PROMOTION_CONSUMECOUPON @"/api/v1/promotions/coupon"

//#pragma mark - Directories
#define FAVORITE_DIRECTORY @"favoriteData"
#define FAVORITE_IMAGE_DIRECTORY @"favoriteImage"
#define PRODUCT_DIRECTORY @"productData"
#define CATALOG_DIRECTORY @"catalogData"
#define PRODUCT_IMAGE_DIRECTORY @"productImage"
#define PROFILE_DIRECTORY @"profileData"
#define PROFILE_FILE @"profileFile"
#define ORDERS_FILE @"orderFile"
#define ORDERS_DIRECTORY @"orderData"
#define BEACON_DIRECTORY @"beaconDirectory"
#define BEACON_FILE @"beaconData"
//#pragma mark - Product Dictionary
#define PRODUCT_ID_KEY @"id"
#define PRODUCT_NAME_KEY @"name"
#define PRODUCT_TITLE_KEY @"title"
#define PRODUCT_SUBTITLE_KEY @"subtitle"
#define PRODUCT_IMAGE_URL_KEY @"image_url"
#define PRODUCT_ACTIONS_KEY @"actions"
#define PRODUCT_UPDATED_AT @"updated_at"
#define PRODUCT_AUTO_LAUNCH_KEY @"auto_launch"
#define PRODUCT_PRICE_KEY @"price"
#define PRODUCT_DISCOUNT_PRICE_KEY @"discount_price"
#define PRODUCT_RECOGNIZE_DATE_KEY @"recognizeDate"
#define PRODUCT_RECOMMENDED_ITEMS @"recommendations"
#define PRODUCT_LAST_UPDATED_AT @"last_updated_at"
//
#define ACTION_ID_KEY @"id"
#define ACTION_TYPE_KEY @"type"
#define ACTION_LABEL_KEY @"label"
#define ACTION_HREF_KEY @"href"
#define ACTION_POINTS_KEY @"points"
#define ACTION_ORDER_QUANTITY @"quantidade"
#define ACTION_ORDER_COLOR_CODE @"codigo_cor"
//
#define ACTION_VIDEO @"VideoAction"
#define ACTION_VIDEO_AR @"VideoArAction"
#define ACTION_VIDEO_AR_TRANSP @"VideoArTranspAction"
#define ACTION_AUDIO @"AudioAction"
#define ACTION_SELL @"SellAction"
#define ACTION_PRICE @"PriceAction"
#define ACTION_ORDER @"OrderAction"
#define ACTION_LIKE @"LikeAction"
#define ACTION_INFO @"InfoAction"
#define ACTION_DRAW @"DrawAction"
#define ACTION_LINK @"LinkAction"
#define ACTION_PHONE @"PhoneAction"
#define ACTION_QUIZ @"QuizAction"
#define ACTION_REGISTER @"RegisterAction"
#define ACTION_RSVP @"RsvpAction"
#define ACTION_TWEET @"TweetAction"
#define ACTION_EMAIL @"EmailAction"
#define ACTION_COUPON @"CouponAction"
#define ACTION_PROMOTION @"PromotionAction"
#define ACTION_TURISTIK @"TuristikAction"
#define ACTION_SURVEY @"SurveyAction"
#define ACTION_TRACKING @"TrackingAction"
#define ACTION_MASK @"MaskAction"
#define ACTION_BANNER @"BannerAction"
#define ACTION_PANORAMA_GALLERY @"PanoramaGalleryAction"
#define ACTION_CUSTOM_SURVEY @"QuestionnaireAction"
#define ACTION_MODEL_3D @"Model3dAction"
//#pragma mark - Errors keys
#define ERROR_ARRAY_KEY @"errors"
#define ERROR_OBJECT_KEY @"error"
#define ERROR_ID_KEY @"id"
#define ERROR_STATUS_KEY @"status"
#define ERROR_TITLE_KEY @"title"
//
#define kCouponIDKey @"coupon_id"
#define kCouponCodeKey @"coupon_code"
#define kCouponDiscountTypeKey @"discount_type"
#define kCouponDiscountValueKey @"discount_value"
#define kCouponConsumerIDKey @"consumer_id"
#define kCouponConsumerNameKey @"consumer_name"
#define kCouponConsumerEmailKey @"consumer_email"
#define kCouponPromotionNameKey @"promotion_name"
#define kCouponPromotionIDKey @"promotion_id"
#define kCouponConsumeDateKey @"consume_date"
#define kCouponDiscountTypePercentage @"percentage"
#define kCouponDiscountTypeValue @"value"
#define kCouponDiscountTypeCredit @"credit"
#define kCouponDiscountTypeDiscount @"discount"
#define kSecureCouponHashValue @"56f741f91faa7ac1a2eeb17ff4919d46" //MD5 para texto "AdAliveStore"
#define kSecureCouponHashKey @"hash"
#define kCouponOriginAppID @"app_id"

//=======================================================================================================
#pragma mark - • APP OPTIONS (menu de configurações do aplicativo)
//=======================================================================================================
//NOTE: ericogt >> Itens que terminam com underline (_) terão o ID do usuário concatenado (são keys particulares)
#define APP_OPTION_KEY_SOUNDEFFECTS_STATUS @"app_options_key_soundeffects_status_"
#define APP_OPTION_KEY_TIMELINE_AUTO_PLAYVIDEOS @"app_options_key_timeline_auto_playvideos_"
#define APP_OPTION_KEY_TIMELINE_START_VIDEO_MUTED @"app_options_key_timeline_start_video_muted_"
#define APP_OPTION_KEY_TIMELINE_AUTO_EXPANDPOSTS @"app_options_key_timeline_auto_expandposts_"
#define APP_OPTION_KEY_TIMELINE_USE_VIDEO_CACHE @"app_options_key_timeline_use_video_cache_"
//
#define APP_OPTION_KEY_SHOWCASE_TIP_MASKUSER @"app_options_key_showcase_tip_mask_user_"
#define APP_OPTION_KEY_3DVIEWER_TIP_AR @"app_options_key_3dviewer_tip_ar_"
#define APP_OPTION_KEY_3DVIEWER_TIP_PLACEABLEAR @"app_options_key_3dviewer_tip_placeablear_"
#define APP_OPTION_KEY_3DVIEWER_TIP_SCENE @"app_options_key_3dviewer_tip_scene_"
#define APP_OPTION_KEY_3DVIEWER_TIP_IMAGETARGET @"app_options_key_3dviewer_tip_imagetarget_"

//=======================================================================================================
#pragma mark - • CHAVES PLIST (User Defaults)
//=======================================================================================================
#define PLISTKEY_USER_ID @"gsmd_user_id"
#define PLISTKEY_SERVER_PREFERENCES @"gsmd_server_preference"
#define PLISTKEY_SERVER_AHK_PREFERENCES @"gsmd_server_gsmd_preference"
#define PLISTKEY_ACCESS_TOKEN @"gsmd_access_token"
#define PLISTKEY_PUSH_NOTIFICATION_TOKEN  @"gsmd_push_notifications_original_token"
#define PLISTKEY_PUSH_NOTIFICATION_FIREBASE_TOKEN  @"gsmd_push_notifications_firebase_token"
#define PLISTKEY_PUSH_NOTIFICATION_DICTIONARY_DATA  @"gsmd_push_notifications_dictionary_data"
#define PLISTKEY_SERVER_CHAT_PREFERENCES @"gsmd_server_chat_preference"
#define PLISTKEY_LOGIN_STATE @"gsmd_login_state"
#define PLISTKEY_SHOW_CODE @"show_code"
#define PLISTKEY_SHOW_REGISTER_BUTTON @"register_user"
#define PLISTKEY_LOGIN_ERROR_MESSAGE @"login_error_message"
#define PLISTKEY_SURVEY_GENERAL @"survey_geral"
#define PLISTKEY_MASTER_EVENT_ID @"gsmd_master_event_id"
#define PLISTKEY_APP_NAME @"gsmd_app_name"
#define PLISTKEY_APP_START_COUNT @"gsmd_start_count"

//=======================================================================================================
#pragma mark - • SYSTEM NOTIFICATIONS (para observers)
//=======================================================================================================
#define SYSNOT_UPDATE_MAIN_MENU @"sysnot_update_main_menu"
#define SYSNOT_TABLE_PICKER_OPTION_SELECTED @"sysnot_table_picker_option_selected"
#define SYSNOT_NEWS_IMAGE_DOWNLOADED @"sysnot_news_image_downloaded"
#define SYSNOT_NEWS_PHOTO_INFO_FINISH_SEARCH @"sysnot_news_photo_finish_search"
#define SYSNOT_NEWS_AUTHOR_INFO_FINISH_SEARCH @"sysnot_news_author_finish_search"
#define SYSNOT_CHAT_NEW_MESSAGE @"sysnot_chat_new_message"
#define SYSNOT_LAYOUT_PROFILE_PIC_USER_UPDATED @"sysnot_layout_profile_pic_user_updated"
#define SYSNOT_PUSH_NOTIFICATION_INTERACTIVE @"sysnot_push_notification_interactive"
#define SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BACKGROUND @"sysnot_base_layout_download_image_background"
#define SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_LOGO @"sysnot_base_layout_download_image_logo"
#define SYSNOT_BASE_LAYOUT_DOWNLOAD_IMAGE_BANNER @"sysnot_base_layout_download_image_banner"
#define SYSNOT_MA_SHOP_CART_UPDATED @"sysnot_ma_shop_cart_updated"
#define SYSNOT_USER_AUTHENTICATION_TOKEN_INVALID_ALERT @"sysnot_user_authentication_token_invalid_alert"
#define SYSNOT_TIMELINE_VIDEO_PLAYER_START_RUNNING @"sysnot_timeline_video_player_start_running"
#define SYSNOT_NEW_URL_ADALIVE_OPENFILE @"sysnot_new_url_adalive_openfile"

//=======================================================================================================
#pragma mark - • PUSH NOTIFICATIONS
//=======================================================================================================
#define PUSHNOT_CATEGORY_MESSAGE @"br.com.atlantic.MESSAGE"
#define PUSHNOT_CATEGORY_INTERACTIVE @"br.com.atlantic.INTERACTIVE"
#define PUSHNOT_CATEGORY_SECTOR @"br.com.atlantic.SECTOR"
#define PUSHNOT_CATEGORY_LOCAL @"br.com.lab360.LOCAL"


//=======================================================================================================
#pragma mark - • CHAVES DICIONARIOS (body, response e afins)
//=======================================================================================================
#define AUTHENTICATE_HTTP_HEADER_FIELD @"Authorization"
#define AUTHENTICATE_ACCESS_TOKEN @"access_token"
#define AUTHENTICATE_EMAIL_KEY @"email"
#define AUTHENTICATE_LOGIN_KEY @"login"
#define AUTHENTICATE_PASSWORD_KEY @"password"
#define AUTHENTICATE_CODE_KEY @"code"
#define AUTHENTICATE_MASTER_EVENT_ID @"master_event_id"
#define AUTHENTICATE_APP_ID @"app_id"
#define AUTHENTICATE_AHK_SUBSCRIPTION_KEY @"Ocp-Apim-Subscription-Key"
#define AUTHENTICATE_AHK_SUBSCRIPTION_VALUE @"7b88d4c4cab74fe986efa889fe746e4c"
#define CONFIG_KEY_FLAG_POST @"flg_post"
#define CONFIG_KEY_FLAG_LIKE @"flg_like"
#define CONFIG_KEY_FLAG_SHARE @"flg_share"
#define CONFIG_KEY_FLAG_COMMENT @"flg_comment"

//=======================================================================================================
#pragma mark - • ENDPOINTS SERVICOS WEB
//=======================================================================================================
#define SERVICE_URL_APP_CONFIG @"/api/v1/app_config_event?app_id=<app_id>"
#define SERVICE_URL_AUTHENTICATE_STORE @"/api/v1/authenticate"
#define SERVICE_URL_RESET_PASSWORD @"/api/v1/app_users/change_password"
#define SERVICE_URL_CREATE_USER @"/api/v1/app_users"
#define SERVICE_URL_EVENTS_DOWNLOADS @"/api/v1/<master_event_id>/events/<event_id>/files"
#define SERVICE_URL_MASTER_EVENTS_DOWNLOADS @"/api/v1/documents?master_event_id=<master_event_id>&app_id=<app_id>"
#define SERVICE_URL_POST_SUBSCRIBED_EVENT @"/api/v1/<master_event_id>/events/app_user/append"
#define SERVICE_URL_DELETE_SUBSCRIBED_EVENT @"/api/v1/<master_event_id>/events/app_user/remove"
#define SERVICE_URL_GET_SUBSCRIBED_EVENT @"/api/v1/<master_event_id>/events/app_user/<app_user_id>"
#define SERVICE_URL_GET_CONTACT_LIST @"/api/v1/departments"
#define SERVICE_URL_GET_TIMELINE_LIST @"/api/v1/timelines"
#define SERVICE_URL_POST_PHOTO_100 @"/api/v1/ftp/upload"
#define SERVICR_URL_POST_LOGIN_FACEBOOK @"/api/v1/authenticate/facebook"
#define SERVICE_URL_GET_SECTOR_LIST @"/api/v1/sectors"
#define SERVICE_URL_GET_JOB_ROLES @"/api/v1/job_roles?app_id=<app_id>"
#define SERVICE_URL_GET_CATEGORY_LIST @"/api/v1/interest_areas"
#define SERVICE_URL_GET_ALL_EVENTS @"/api/v1/<master_events_id>/events"
#define SERVICE_URL_GET_LAYOUT_DEFINITIONS @"/api/v2/app_layout?master_event_id=<master_event_id>&app_id=<app_id>"
#define SERVICE_URL_GET_SPONSOR_LIST @"/api/v1/<master_events_id>/sponsors"
#define SERVICE_URL_GET_SPONSORS_PLANS @"/api/v1/sponsor_plans/<app_id>"
#define SERVICE_URL_GET_ABOUT_MESSAGE @"/api/v1/<account_id>/find_by_language/<language>"
#define SERVICE_URL_GET_GROUP_LIST_FOR_USER @"/api/v1/group_chats/groups"
#define SERVICE_URL_GET_PERSONAL_LIST_FOR_USER @"/api/v1/single_chat_users/list/<app_user_id>?account_id=<account_id>"
#define SERVICE_URL_GET_SPEAKER_LIST @"/api/v1/app_users/<account_id>/app_users_speaker/<app_user_id>"
#define SERVICE_URL_GET_ALL_GROUPS @"/api/v1/group_chats"
#define SERVICE_URL_GET_ALL_USERS @"/api/v1/app_users/<account_id>/app_users_devices/<app_user_id>"
#define SERVICE_URL_ADD_USER_TO_GROUP @"/api/v1/group_chats/app_user/append"
#define SERVICE_URL_REMOVE_USER_TO_GROUP @"/api/v1/group_chats/app_user/remove"
#define SERVICE_URL_GET_FEED_VIDEOS @"/api/v1/videos?master_event_id=<master_event_id>"
#define SERVICE_URL_GET_PARTICIPANTS @"/api/v1/master_event/<master_event_id>/participants"
#define SERVICE_URL_GET_NOTIFICATIONS @"/api/v1/notifications_received/<app_user_id>"
#define SERVICE_URL_GET_DATA_FOR_USER @"/api/v1/data_in_app?app_user_id=<user_id>"
#define SERVICE_URL_GET_POINTS_STATEMENT @"/api/v1/points?app_user_id=<user_id>&app_id=<app_id>"
#define SERVICE_URL_VALIDATE_CODE @"/api/v1/<app_id>/validate_code/<code>"
#define SERVICE_URL_GET_ADDRESS_BY_CEP @"/api/v1/ma_cep/<cep>"
#define SERVICE_URL_GET_AVAILABLE_QUESTIONNAIRES @"/api/v1/questionnaires"
#define SERVICE_URL_POST_USER_QUESTIONNAIRE @"/api/v1/questionnaires/answer"
//
#define SERVICE_URL_BLOCK_USER_CHAT @"/api/v1/single_chat_users/block/<requester_id>"
#define SERVICE_URL_UNBLOCK_USER_CHAT @"/api/v1/single_chat_users/unblock/<requester_id>"
//
#define SERVICE_URL_REGISTER_APS_TOKEN @"/webservice/client?parametros=<dic_parameters>"
#define SERVICE_URL_REMOVE_APS_TOKEN @"/webservice/client?parametros=<dic_parameters>"
#define SERVICE_URL_GET_MESSAGES_CHAT @"/webservice/client?parametros=<dic_parameters>"
#define SERVICE_URL_POST_MESSAGE_CHAT @"/webservice/client?parametros=<dic_parameters>"
//
#define SERVICE_URL_AHK_SEARCH_EVENTS @"/eventos/?q="
#define SERVICE_URL_AHK_GET_EVENT_DETAIL @"/eventos/|id|"
#define SERVICE_URL_AHK_POST_EVENT_SUBSCRIBE @"/Eventos"
#define SERVICE_URL_AHK_GET_HIVE_OF_ACTIVITIES @"/ramoatividades"
#define SERVICE_URL_AHK_ASSOCIATES_SEARCH @"/empresas/?nome=<nome>&produto=<produto>&ramo=<ramo>&pais=<pais>&cidade=<cidade>&lang=<lang>"
#define SERVICE_URL_AHK_PORTAL_NEWS_CATEGORIES @"/portalnoticias/categories/?per_page=100"
#define SERVICE_URL_AHK_PORTAL_NEWS @"/news"
//
#define SERVICE_URL_POST_CREATE_POST @"/api/v1/posts"
#define SERVICE_URL_GET_POSTS @"/api/v1/<master_event_id>/posts?post_id=<post_id>&type=<type>"
#define SERVICE_URL_GET_FIRST_POSTS @"/api/v1/<master_event_id>/posts?limit=<limit>"
#define SERVICE_URL_POST_REMOVE_POST @"/api/v1/<master_event_id>/<app_user_id>/posts/<post_id>/destroy"
#define SERVICE_URL_POST_ADD_LIKE @"/api/v1/posts/<post_id>/add_like/<app_user_id>"
#define SERVICE_URL_POST_REMOVE_LIKE @"/api/v1/posts/<post_id>/remove_like/<app_user_id>"
#define SERVICE_URL_POST_READ_CHAT @"/api/v1/single_chats/<chat_id>/<user_id>?sent_user_id=<sent_user_id>"
#define SERVICE_URL_POST_ADD_COMMENT @"/api/v1/posts/<post_id>/add_comment/<app_user_id>"
#define SERVICE_URL_POST_UPDATE_COMMENT @"/api/v1/posts/<post_id>/update_comment/<app_user_id>/<comment_post_id>"
#define SERVICE_URL_POST_REMOVE_COMMENT @"/api/v1/<app_user_id>/posts/<post_id>/remove_comment/<comment_post_id>"
#define SERVICE_URL_POST_NOTIFICATION_CONFIRM @"/api/v1/notification/confirm"
#define SERVICE_URL_GET_ORDERS_LIST @"/api/v1/ma_list_order"
#define SERVICE_URL_POST_DISTRIBUTOR_SIGNUP @"/api/v1/user_candidates/create"
#define SERVICE_URL_GET_ORDER_HISTORY @"/api/v1/ma_order_status/"
#define SERVICE_URL_GET_CATALOGS_LIST @"/api/v1/ma_catalogs"
#define SERVICE_URL_GET_MA_POINTS_STATEMENT @"/api/v1/ma_extract_score"
#define SERVICE_URL_GET_CATEGORIES_LIST @"/api/v1/ma_categories"
#define SERVICE_URL_GET_PROFILE_INFOS @"/api/v1/info_profile"
//
#define SERVICE_URL_GET_SIDEMENU_CONFIG @"/api/v1/app_menus?app_id=<APPID>"
#define SERVICE_URL_GET_ALLIMAGETARGETS @"/api/v1/targets"
//
#define SERVICE_URL_GET_SHOWROOMS @"/api/v1/showrooms"
#define SERVICE_URL_GET_SHELFS @"/api/v1/shelves/showroom/<SHOWROOMID>"
#define SERVICE_URL_GET_BEACONS_SHOWROOM_SHELF @"/api/v1/beacons/shelf/<SHELFID>/showroom/<SHOWROOMID>"
#define SERVICE_URL_GET_PRODUCTINFO_SKU @"/api/v1/products/find_by_sku?sku=<PRODUCTSKU>"
//
#define SERVICE_URL_GET_VIRTUAL_SHOWCASE @"/api/v1/virtual_showcases/"
#define SERVICE_URL_GET_CATEGORIES @"/api/v1/categories?limit=<limit>&offset=<offset>&type_category=<type>&category_id=<id>"
#define SERVICE_URL_GET_VIDEOS @"/api/v1/videos/search?limit=<limit>&offset=<offset>&id=<id>&category_id=<cat>&subcategory_id=<subcat>&tag=<tag>"
#define SERVICE_URL_GET_DOCUMENTS @"/api/v1/documents/search?limit=<limit>&offset=<offset>&id=<id>&category_id=<cat>&subcategory_id=<subcat>&tag=<tag>"
//
#define SERVICE_URL_GET_BANNERS_GEOFENCE_TIMELINE @"/api/v1/banners/timeline"

//=======================================================================================================
#pragma mark - • DIRETORIOS E ARQUIVOS:\
//=======================================================================================================
//#define BEACON_DIRECTORY @"BeaconDirectory"
//#define BEACON_FILE @"BeaconFile"
//#define PROFILE_DIRECTORY @"AHK_ProfileData"
//#define PROFILE_FILE @"AHK_ProfileFile"
#define SCANNERHISTORY_DIRECTORY @"ScannerHistoryData"
#define SCANNERHISTORY_FILEDATA @"ScannerHistoryFile"
#define DOWNLOAD_DIRECTORY @"AHK_DownloadsData"
#define DOWNLOAD_FILE_DATA @"AHK_DownloadsFile"
//
#define LAYOUT_DIRECTORY @"GSMD_LayoutData"
#define LAYOUT_FILE @"GSMD_LayoutFile"
#define LAYOUT_IMAGE_BACKGROUND @"GSMD_ImageBackground.jpg"
#define LAYOUT_IMAGE_LOGO @"GSMD_ImageLogo.png"
#define LAYOUT_IMAGE_BANNER @"GSMD_ImageBanner.png"

//=======================================================================================================
#pragma mark - • CONSTANTS / TIME:\
//=======================================================================================================
//Tempos de animação
#define ANIMA_TIME_SUPER_FAST 0.1
#define ANIMA_TIME_FAST 0.2
#define ANIMA_TIME_NORMAL 0.3
#define ANIMA_TIME_SLOW 0.5
#define ANIMA_TIME_SLOOOW 1.0
//Fontes
#define FONT_DEFAULT_REGULAR @"SFUIDisplay-Regular"
#define FONT_DEFAULT_SEMIBOLD @"SFUIDisplay-Semibold"
#define FONT_DEFAULT_BOLD @"SFUIDisplay-Bold"
#define FONT_DEFAULT_ITALIC @"SFUIDisplay-Thin"
//
#define FONT_MYRIAD_PRO_REGULAR @"MyriadPro-Regular"
#define FONT_MYRIAD_PRO_SEMIBOLD @"MyriadPro-Semibold"
#define FONT_MYRIAD_PRO_BOLD @"MyriadPro-Bold"
#define FONT_MYRIAD_PRO_ITALIC @"MyriadPro-It"
//
#define FONT_SIGNPAINTER @"SignPainterHouseScript"
#define FONT_FAKE_RECEIPT @"FakeReceipt-Regular"
//
#define FONT_SAN_FRANCISCO_BLACK @"SFUIDisplay-Black"
#define FONT_SAN_FRANCISCO_BOLD @"SFUIDisplay-Bold"
#define FONT_SAN_FRANCISCO_HEAVY @"SFUIDisplay-Heavy"
#define FONT_SAN_FRANCISCO_LIGHT @"SFUIDisplay-Light"
#define FONT_SAN_FRANCISCO_MEDIUM @"SFUIDisplay-Medium"
#define FONT_SAN_FRANCISCO_REGULAR @"SFUIDisplay-Regular"
#define FONT_SAN_FRANCISCO_SEMIBOLD @"SFUIDisplay-Semibold"
#define FONT_SAN_FRANCISCO_THIN @"SFUIDisplay-Thin"
#define FONT_SAN_FRANCISCO_ULTRALIGHT @"SFUIDisplay-Ultralight"

//Tamanho de Fontes
#define FONT_SIZE_TEXT_FIELDS 15.0
#define FONT_SIZE_BUTTON_NO_BORDERS 16.0
#define FONT_SIZE_BUTTON_MENU_OPTION 17.0
#define FONT_SIZE_TITLE_NAVBAR 18.0
#define FONT_SIZE_BUTTON_BOTTOM 15.0
#define FONT_SIZE_LABEL_MICRO 11.0
#define FONT_SIZE_LABEL_SMALL 13.0
#define FONT_SIZE_LABEL_NOTE 14.0
#define FONT_SIZE_LABEL_NORMAL 16.0
#define FONT_SIZE_LABEL_LARGE 28.0
#define FONT_SIZE_LABEL_GIANT 32.0
//Tamanho máximo de imagem (maior lado)
#define IMAGE_MAXIMUM_SIZE_SIDE 1280

//===================================================================================================
#pragma mark - • COLORS
//===================================================================================================

#define COLOR_MA_RED [UIColor colorWithRed:188.0/255.0 green:15.0/255.0 blue:24.0/255.0 alpha:1]
#define COLOR_MA_GREEN [UIColor colorWithRed:34.0/255.0 green:162.0/255.0 blue:120.0/255.0 alpha:1]
#define COLOR_MA_BLUE [UIColor colorWithRed:25.0/255.0 green:96.0/255.0 blue:161.0/255.0 alpha:1]
#define COLOR_MA_YELLOW [UIColor colorWithRed:247.0/255.0 green:202.0/255.0 blue:46.0/255.0 alpha:1]
#define COLOR_MA_ORANGE [UIColor colorWithRed:253.0/255.0 green:133.0/255.0 blue:50.0/255.0 alpha:1]
#define COLOR_MA_GRAY [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1]
#define COLOR_MA_DARKGRAY [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1]
#define COLOR_MA_PURPLE [UIColor colorWithRed:124.0/255.0 green:11.0/255.0 blue:117.0/255.0 alpha:1]
#define COLOR_MA_WHITE [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]
#define COLOR_MA_LIGHTYELLOW [UIColor colorWithRed:250.0/255.0 green:254.0/255.0 blue:192.0/255.0 alpha:1.0]
#define COLOR_MA_LIGHTOLIVE [UIColor colorWithRed:236.0/255.0 green:241.0/255.0 blue:236.0/255.0 alpha:1.0]
#define COLOR_MA_OLIVE [UIColor colorWithRed:175.0/255.0 green:194.0/255.0 blue:175.0/255.0 alpha:1.0]
#define COLOR_MA_LIGHTSALMON [UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:214.0/255.0 alpha:1.0]
#define COLOR_MA_SALMON [UIColor colorWithRed:225.0/255.0 green:94.0/255.0 blue:91.0/255.0 alpha:1.0]
