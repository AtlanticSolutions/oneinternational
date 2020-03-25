package br.com.lab360.bioprime.application;

import br.com.lab360.bioprime.BuildConfig;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */
public class AdaliveConstants {

    /**
     * API
     */
    //Prod
    public static final int ACCOUNT_ID = 1;
    public static final int APP_ID =  Integer.valueOf(BuildConfig.APP_ID);
    public static final String ADALIVE_BASE_URL = "http://master.ad-alive.com";
    public static final String AMAZON_URL = "https://s3-sa-east-1.amazonaws.com";
    public static final String SHARED_PREFS =  BuildConfig.SHARED_PREFS;
    public static final String FILE_PROVIDER_URI = BuildConfig.FILE_PROVIDER_URI;
    public static final String DEFAULT_ROLE = "";
    public static final String ADMIN_ROLE = "admin";

    //Teste
//    public static final int ACCOUNT_ID = 1;
//    public static final int APP_ID = 1;
//    public static final String ADALIVE_BASE_URL = "https://adalive-master.herokuapp.com";

    /**
     * Intent bundle tags
     */
    public static final String INTENT_TAG_AREAS = "Areas";
    public static final String INTENT_TAG_ACTIVITY_TITLE = "Title";
    public static final String INTENT_TAG_FACEBOOK_USER = "FacebookUser";
    public static final String INTENT_TAG_USER = "User";
    public static final String INTENT_TAG_FACEBOOK_TOKEN = "FacebookToken";
    public static final String INTENT_TAG_EVENT = "Event";
    public static final String INTENT_TAG_ONLY_REGISTERED = "REGISTERED";
    public static final String INTENT_TAG_PASSWORD = "password";
    public static final String INTENT_TAG_DOWNLOAD = "Download";
    public static final String INTENT_TAG_MESSAGE = "message";
    public static final String INTENT_TAG_CHAT = "CHAT";
    public static final String INTENT_TAG_GROUP = "GROUP";
    public static final String INTENT_TAG_GROUP_LIST = "groupList";
    public static final String INTENT_TAG_BLOCK_STATUS = "status";
    public static final String INTENT_TAG_TIMELINE_POST = "Post";
    public static final String INTENT_TAG_DIRECT_SURVEY = "survey";
    public static final String INTENT_TAG_PRODUCT_ID = "productID";
    public static final String INTENT_TAG_PRODUCT_SIZE = "productSize";
    public static final String INTENT_TAG_PRODUCT_SIZE_TEXT = "productSizeTxt";
    public static final String INTENT_TAG_PRODUCT_REFERENCE = "productReference";

    /**
     * Request custom header
     */
    public static final String APPLICATION_JSON = "application/json";
    public static final String ACCEPT = "Accept";
    public static final String XAPPID = "x_app_id";

    public static final String CONTENT_TYPE = "Content-Type";
    public static final String APPLICATION_JSON_CHARSET_UTF_8 = "application/json; charset=utf-8";

    /**
     * Shared prefs - user
     */

    public static final String ID = "id";
    public static final String FIRST_NAME = "first_name";
    public static final String LAST_NAME = "last_name";
    public static final String EMAIL = "email";
    public static final String DDD_PHONE = "ddd_phone";
    public static final String PHONE = "phone";
    public static final String DDD_CELL_PHONE = "ddd_cell_phone";
    public static final String CELL_PHONE = "cell_phone";
    public static final String ROLE = "role";
    public static final String COMPANY_NAME = "company_name";
    public static final String ADDRESS = "address";
    public static final String NUMBER = "number";
    public static final String COMPLEMENT = "complement";
    public static final String DISTRICT = "district";
    public static final String ACCESS_TOKEN = "access_token";
    public static final String CITY = "city";
    public static final String ZIPCODE = "zipcode";
    public static final String STATE = "state";
    public static final String COUNTRY = "country";
    public static final String SECTOR_ID = "sector_id";
    public static final String CPF = "cpf";
    public static final String CNPJ = "cnpj";
    public static final String RG = "rg";
    public static final String BIRTHDATE = "birthdate";
    public static final String GENDER = "gender";
    public static final String BASE64_PROFILE_IMAGE = "base64_profile_image";
    public static final String BACKGROUND = "Background";
    public static final String SLIDER_BANNER = "SLIDER_BANNER";
    public static final String BANNER = "BANNER";
    public static final String BANNER_LINK = "BANNER_URL";
    public static final String TAG_APP_ID = "app_id";
    public static final String INTEREST_LIST = "interest_list";
    public static final String VUFORIA_ACCESS_KEY = "vuforia_access_key";
    public static final String VUFORIA_SECRET_KEY = "vuforia_secret_key";
    public static final String VUFORIA_LICENSE_KEY = "vuforia_license_key";
    public static final String MASTER_EVENT_ID = "MasterEventId";
    public static final String ROLES = "roles";
    public static final String ROLE_PROFILE = "roleProfile";
    public static final String CAN_POST = "canShare";
    public static final String CAN_LIKE = "canLike";
    public static final String CAN_SHARE = "canShare";
    public static final String CAN_COMMENT = "canComment";
    public static final String LAST_UPDATE = "lastUpdateDate";
    public static final String REGISTER_USER = "registerUser";
    public static final String LOGIN_ERROR_MESSAGE = "loginErrorMessage";

    public static final String NAME_APP = "nameApp";
    public static final String VERSION_APP = "versionApp";
    public static final String LOGO_URL = "logoUrl";
    public static final String TEXT_COLOR = "textcolor";
    public static final String BACKGROUND_COLOR = "backgroundcolor";
    public static final String TEXT_COLOR_FIRST = "buttonColorFirst";
    public static final String SHOW_EVENT_SCREAN = "eventScrean";

    public static final String URL_ADALIVE_API = "urlAdaliveApi";
    public static final String URL_CHAT_API = "urlChatApi";
    public static final String URL_AMAZON_API = "urlAmazonApi";
    /**
     * TAGS - DEBUG
     */
    public static final String ERROR = "-- ERROR --";
    public static final String INFO = "-- INFO --";

    /**
     * Font path
     */
    public static final String FONT_MYRIAN_BOLD = "fonts/MyriadPro-Bold.otf";
    public static final String FONT_MYRIAN_REGULAR = "fonts/MyriadPro-Regular.otf";
    public static final String FONT_MYRIAN_SEMIBOLD = "fonts/MyriadPro-Semibold.otf";

    /**
     * Rest Tags
     */
    public static final String TAG_EVENT_ID = "Id";
    public static final String TAG_EVENT_TITLE = "Titulo";
    public static final String TAG_EVENT_TYPE = "Tipo";
    public static final String TAG_EVENT_PANELIST = "Palestrante";
    public static final String TAG_EVENT_THEME = "Tema";
    public static final String TAG_EVENT_SYNOPS = "Sinopse";
    public static final String TAG_EVENT_DATA = "Data";
    public static final String TAG_EVENT_ADATA = "AData";
    public static final String TAG_EVENT_HOUR = "Hora";
    public static final String TAG_EVENT_AHOUR = "AHora";
    public static final String TAG_EVENT_LOCATION = "Local";
    public static final String TAG_EVENT_VALUE = "Valor";
    public static final String TAG_EVENT_VALUE_A = "ValorAssociado";
    public static final String TAG_EVENT_VALUE_N = "ValorNAssociado";
    public static final String TAG_EVENT_LANGUAGE = "Idioma";
    public static final String TAG_EVENT_INCRI = "Inscricoes";
    public static final String TAG_EVENT_P_EMAIL = "PorEmail";
    public static final String TAG_EVENT_P_SITE = "PorSite";
    public static final String TAG_EVENT_P_PHONE = "PorTel";
    public static final String TAG_EVENT_P_FAX = "PorFax";
    public static final String TAG_EVENT_OBS = "Obs";
    public static final String TAG_EVENT_LIMIT = "Prazo";
    public static final String TAG_EVENT_DATE_A = "DataAtiva";
    public static final String TAG_EVENT_DATE_D = "DataDesativa";
    public static final String TAG_EVENT_PATRO = "Patrocinadores";
    public static final String TAG_EVENT_EX_ASS = "ExclusivoAssociado";
    public static final String TAG_EVENT_URL = "UrlInscricao";
    public static final String PREFS_TAG_MYDOWNLOADS = "MyDownloads";
    public static final String TAG_DOWNLOAD = "Download";


    /**
     * Video
     */
    public static final String VIDEO = "video";
    public static final String YOUTUBE_API_KEY = "AIzaSyCgNJQkjZK6loliIbhIfz4-LsxBdb8BE0w";

    public static final int REQUEST_SIGNUP_USER = 0x23;

    /**
     * Notification
     */
    public static final String NOTIFICATION_MESSAGE = "notification_message";
    public static final String NOTIFICATION_ID = "notification_id";

    /**
     * Timeline
     */
    public static final String LOAD_POSTS = "load_posts";

    /**
     * Plataform registration fcm id;
     */
    public static final String PLATFORM = "ANDROID";

    /**
     * Timeline first registes
     */
    public static final int FIRST_REGISTERS = 10;

    /**
     * Beacon
     */
    public static final String IBEACON_LAYOUT = "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24";

    //Survey and Actions
    public static final String IDENTIFY_PRODUCT = "IDENTIFY_PRODUCT";
    public static final String TITLE_PRODUCT = "TITLE_PRODUCT";
    public static final String TAG_SURVEY_ID = "SurveyID";
    public static final String TAG_ACTION_ID = "actionID";
    public static final String TAG_ACTION_URL = "actionUrl";
    public static final String TAG_ACTION_WEBVIEW_TITLE = "webviewTitle";

    //Value Categories
    public static final int CATEGORY_DOCUMENT = 0;
    public static final int CATEGORY_PRODUCT = 1;
    public static final int CATEGORY_VIDEO = 2;

    public static final String TAG_SUB_CATEGORY = "TAG_SUB_CATEGORY";
    public static final String TAG_SUB_CATEGORIES = "TAG_SUB_CATEGORIES";
    public static final String TAG_CATEGORY = "TAG_CATEGORY";
    public static final String TAG_CATEGORIES = "TAG_CATEGORIES";

    //Types app menu

    public static final String TYPE_MENU = "TYPE_MENU_ITEM";
    public static final String TYPE_SUB_MENU = "TYPE_SUB_MENU";

    public static final String TYPE_HOME = "home";
    public static final String TYPE_PROFILE = "profile";
    public static final String TYPE_EVENTS = "events";
    public static final String TYPE_AGENDA = "agenda";
    public static final String TYPE_DOCUMENTS = "documents";
    public static final String TYPE_SPONSOR = "sponsor";
    public static final String TYPE_VIDEOS = "videos";
    public static final String TYPE_SCANNER = "scanner";
    public static final String TYPE_GIFTCARD = "giftcard";
    public static final String TYPE_VIRTUAL_SHOWCASE = "virtualshowcase";
    public static final String TYPE_SHOWCASE_360 = "showcase360";
    public static final String TYPE_EXIT = "exit";
    public static final String TYPE_WEBPAGE = "webpage";
    public static final String TYPE_ABOUT = "about";
    public static final String TYPE_CHAT = "chat";
    public static final String TYPE_PROMOTIONALCARD = "promotionalcard";
    public static final String TYPE_MANAGER = "mock_manager";
    public static final String TYPE_GEOFENCE = "mock_geofence";

}
