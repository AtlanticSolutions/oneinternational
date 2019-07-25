package br.com.lab360.oneinternacional.ui.activity;

import android.Manifest;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import androidx.annotation.Nullable;
import androidx.browser.customtabs.CustomTabsIntent;
import androidx.core.app.ActivityCompat;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.webkit.WebChromeClient;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.google.common.base.Strings;
import com.google.gson.Gson;
import com.jakewharton.processphoenix.ProcessPhoenix;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import br.com.lab360.oneinternacional.BuildConfig;
import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.ChatInteractor;
import br.com.lab360.oneinternacional.logic.interactor.MenuInteractor;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnChatRequestListener;
import br.com.lab360.oneinternacional.logic.listeners.OnUrlLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.Url;
import br.com.lab360.oneinternacional.logic.model.pojo.menu.AppMenu;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatBaseResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.menu.MenuItem;
import br.com.lab360.oneinternacional.logic.model.pojo.menu.MenuResponse;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.ProfileChanged;
import br.com.lab360.oneinternacional.ui.activity.about.AboutActivity;
import br.com.lab360.oneinternacional.ui.activity.chat.ChatActivity;
import br.com.lab360.oneinternacional.ui.activity.chat.ChatGroupListActivity;
import br.com.lab360.oneinternacional.ui.activity.events.EventsTabActivity;
import br.com.lab360.oneinternacional.ui.activity.geofence.GeofenceActivity;
import br.com.lab360.oneinternacional.ui.activity.managerapplication.ManagerApplicationActivity;
import br.com.lab360.oneinternacional.ui.activity.newdocument.DocumentCategoryActivity;
import br.com.lab360.oneinternacional.ui.activity.newvideo.VideoCategoryActivity;
import br.com.lab360.oneinternacional.ui.activity.notifications.NotificationActivity;
import br.com.lab360.oneinternacional.ui.activity.profile.EditProfileActivity;
import br.com.lab360.oneinternacional.ui.activity.promotionalcard.PrePromotionalCardActivity;
import br.com.lab360.oneinternacional.ui.activity.scanner.ScannerActivity;
import br.com.lab360.oneinternacional.ui.activity.showcase.ShowCase360Activity;
import br.com.lab360.oneinternacional.ui.activity.showcase.ShowCaseActivity;
import br.com.lab360.oneinternacional.ui.activity.sponsors.SponsorsActivity;
import br.com.lab360.oneinternacional.ui.activity.timeline.TimelineActivity;
import br.com.lab360.oneinternacional.ui.activity.webview.WebviewActivity;
import br.com.lab360.oneinternacional.ui.adapters.menu.ParentMenuRecyclerAdapter;
import br.com.lab360.oneinternacional.ui.adapters.menu.ChildMenuRecyclerAdapter;
import br.com.lab360.oneinternacional.ui.view.INavigationDrawerView;
import br.com.lab360.oneinternacional.utils.SharedPrefsHelper;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.OnClick;
import de.hdodenhof.circleimageview.CircleImageView;
import me.anshulagarwal.simplifypermissions.Permission;
import rx.Observer;
import rx.Subscription;


/**
 * Created by Alessandro Valenza on 24/11/2016.
 *
 * Refactored by Paulo Age
 */
public class NavigationDrawerActivity extends BaseActivity implements INavigationDrawerView,
        OnChatRequestListener,
        ParentMenuRecyclerAdapter.OnParentMenuClicked,
        ChildMenuRecyclerAdapter.OnChildMenuClicked,
        OnUrlLoadedListener {

    /* Permissions */
    private String[] SCANNER_PERMISSIONS = {
            Manifest.permission.CAMERA,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_PHONE_STATE};

    private static final int SCANNER_PERMISSION_REQUESTED = 9875;

    //region Bind - TextView
    @BindView(R.id.txt_atlantic)
    protected TextView txtVersion;
    @BindView(R.id.tvAppVersion)
    protected TextView tvAppVersion;
    @BindView(R.id.title)
    protected TextView tvTitle;
    @BindView(R.id.tvProfileEmail)
    protected TextView tvProfileEmail;
    @BindView(R.id.tvProfileName)
    protected TextView tvProfileName;
    //endregion

    //region Bind - Images
    @BindView(R.id.ivProfilePhoto)
    protected CircleImageView ivProfilePhoto;
    @BindView(R.id.btnDrawer)
    protected CircleImageView btnDrawer;
    @BindView(R.id.ivMenu)
    protected ImageView ivMenu;
    @BindView(R.id.ivChat)
    protected ImageView ivChat;
    @BindView(R.id.ivNotification)
    protected ImageView ivNotification;
    @BindView(R.id.ivGallery)
    protected ImageView ivGallery;
    @BindView(R.id.ivSearch)
    protected ImageView ivSearch;
    @BindView(R.id.ivDownload)
    protected ImageView ivDownload;
    @BindView(R.id.ivCart)
    protected ImageView ivCart;
    @BindView(R.id.txtEdit)
    protected TextView txtEdit;
    @BindView(R.id.rvMenu)
    protected RecyclerView rvMenu;

    protected RecyclerView rvChildMenu;
    protected ImageView ivArrowMenu;

    //region Bind - Layouts
    @BindView(R.id.drawer_layout)
    protected DrawerLayout drawer;
    @BindView(R.id.container_profile)
    protected RelativeLayout container_profile;
    //endregion

    /* Vars */
    private Subscription   profileChangeSubscription;
    private ChatInteractor mInteractor;
    private MenuInteractor menuInteractor;

    private static Gson gson;
    private static SharedPrefsHelper sharedPrefsHelper;

    private boolean isReadMockedMenu;

    public String title;
    public String urlCarrinho, menuName;

    //region Lifecycle
    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        createSubscription();

        gson = new Gson();
        sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();

        menuInteractor = new MenuInteractor(this);

        User user = AdaliveApplication.getInstance().getUser();
        setUserPhoto(user.getProfileImageURL());
        tvProfileName.setText(user.getFirstName());
        tvProfileEmail.setText(user.getEmail());

        String versionName = getString(R.string.VERSION) + " " + BuildConfig.VERSION_NAME;
        txtVersion.setText(versionName);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            container_profile.setBackground(cd);
            tvAppVersion.setTextColor(Color.parseColor(topColor));
            txtVersion.setTextColor(Color.parseColor(topColor));
        }

        configRecyclerView();
    }

    @Override
    public void onBackPressed() {
        if (drawer.isDrawerOpen(GravityCompat.END)) {
            drawer.closeDrawer(GravityCompat.END, true);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        if (profileChangeSubscription != null && !profileChangeSubscription.isUnsubscribed()) {
            profileChangeSubscription.unsubscribe();
        }

        super.onDestroy();
    }
    //endregion

    //region Configuration

    /**
     * Configure the menu.
     */

    @Override
    public void configRecyclerView() {
        rvMenu.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvMenu.setHasFixedSize(true);
        final ParentMenuRecyclerAdapter adapter = new ParentMenuRecyclerAdapter(loadMenuItems(), this , this);
        rvMenu.setAdapter(adapter);
        //tvAppVersion.setText(getString(R.string.VERSION) + " " + BuildConfig.VERSION_NAME);
    }

    @Override
    public List<MenuItem> loadMenuItems() {
        List<MenuItem> menuItems = new ArrayList<>();
        String jsonMenuResponse = sharedPrefsHelper.get(SplashScreenActivity.MENU_OBJECTS,"") ;

        if (!Strings.isNullOrEmpty(jsonMenuResponse)) {
            MenuResponse appMenu = gson.fromJson(jsonMenuResponse, MenuResponse.class);

            if (appMenu != null && appMenu.getAppMenu() != null && appMenu.getAppMenu().getMenuItems() != null){
                menuItems = sortMenuItems(appMenu.getAppMenu().getMenuItems());
            }

            if(BuildConfig.APP_ID.equals("1000012")){
                menuItems.addAll(createMockManagerApplicationItem());
            }

            for(MenuItem menuItem : appMenu.getAppMenu().getMenuItems()) {
                if(menuItem.getName().equals("Carrinho")){
                    urlCarrinho = menuItem.getUrl();
                    menuName = menuItem.getName();
                }
            }

        }

        return menuItems;
    }

    @Override
    public List<MenuItem> sortMenuItems(List<MenuItem> menuItems) {
        Collections.sort(menuItems, new Comparator<MenuItem>() {
            @Override
            public int compare(MenuItem o1, MenuItem o2) {
                return  o1.getOrder() - o2.getOrder();
            }
        });

        return menuItems;
    }

    public List<MenuItem> createMockManagerApplicationItem(){
        List<MenuItem> items = new ArrayList<>();
        MenuItem menuItem1 = new  MenuItem();
        menuItem1.setIdentifier("mock_manager");
        menuItem1.setName("Gerenciador de Apps");
        menuItem1.setFeaturedMessage("Apps Lab360");
        menuItem1.setOrder(1000000);
        items.add(menuItem1);

        /*
        MenuItem menuItem2 = new  MenuItem();
        menuItem2.setIdentifier("mock_geofence");
        menuItem2.setName("Geofence");
        menuItem2.setFeaturedMessage("Apps Lab360");
        menuItem2.setOrder(1000001);
        items.add(menuItem2);
        */
        return items;
    }

    @Override
    public void onParentMenuClick(final MenuItem menu, RecyclerView rvChild, ImageView ivArrow) {
        if (menu.getMenuItems() != null && menu.getMenuItems().size() != 0) {
            rvChild.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvChild.setHasFixedSize(true);
            ChildMenuRecyclerAdapter adapter = new ChildMenuRecyclerAdapter(menu.getMenuItems(), this, this);
            rvChild.setAdapter(adapter);
            rvChildMenu = rvChild;
            ivArrowMenu = ivArrow;
        } else {
            chooseTypeToIntent(menu);
        }
    }

    @Override
    public void onChildMenuClick(final MenuItem menu, RecyclerView rvChild, ImageView ivArrow) {
        if (menu.getMenuItems() != null && menu.getMenuItems().size() != 0) {
            rvChild.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvChild.setHasFixedSize(true);
            ChildMenuRecyclerAdapter adapter = new ChildMenuRecyclerAdapter(menu.getMenuItems(), this, this);
            rvChild.setAdapter(adapter);
        } else {
            ivArrowMenu.setImageDrawable(getResources().getDrawable(R.drawable.ic_arrow_down));
            rvChildMenu.setVisibility(View.GONE);
            chooseTypeToIntent(menu);
        }
    }

    @Override
    public void onChildofChildMenuClick(final MenuItem menu, RecyclerView rvChild) {
        if (menu.getMenuItems() != null && menu.getMenuItems().size() != 0) {
            rvChild.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
            rvChild.setHasFixedSize(true);
            ChildMenuRecyclerAdapter adapter = new ChildMenuRecyclerAdapter(menu.getMenuItems(), this, this);
            rvChild.setAdapter(adapter);
        } else {
            chooseTypeToIntent(menu);
        }
    }


    public void chooseTypeToIntent(MenuItem type) {
        String typeId = type.getIdentifier();
        switch (typeId) {
            case AdaliveConstants.TYPE_HOME:
                navigateToTimelineActivity();
                break;
            case AdaliveConstants.TYPE_PROFILE:
                navigateToEditProfileActivity();
                break;
            case AdaliveConstants.TYPE_EVENTS:
                navigateToEventsActivity();
                break;
            case AdaliveConstants.TYPE_AGENDA:
                navigateToAgendaActivity();
                break;
            case AdaliveConstants.TYPE_DOCUMENTS:
                navigateToDocumentsActivity();
                break;
            case AdaliveConstants.TYPE_SPONSOR:
                navigateToSponsorsActivity();
                break;
            case AdaliveConstants.TYPE_VIDEOS:
                navigateToVideosActivity();
                break;
            case AdaliveConstants.TYPE_SCANNER:
                checkPermissionsScanner();
                break;
            case AdaliveConstants.TYPE_GIFTCARD:
                //NÃO FOI DESENVOLVIDO
                break;
            case AdaliveConstants.TYPE_VIRTUAL_SHOWCASE:
                navigateToShowCaseActivity();
                break;
            case AdaliveConstants.TYPE_SHOWCASE_360:
                navigateToShowCase360();
                break;
            case AdaliveConstants.TYPE_EXIT:
                showExitDialog();
                break;
            case AdaliveConstants.TYPE_WEBPAGE:
                if(type.isFlgApiAdalive()){
                    showProgress();
                    title = type.getName();
                    menuInteractor.getUrl(type.getUrl().substring(type.getUrl().length() - 2), this, getUserToken());
                }
                break;
            case AdaliveConstants.TYPE_ABOUT:
                navigateToAboutActivity();
                break;
            case AdaliveConstants.TYPE_CHAT:
                navigateToChatActivity();
                break;
            case AdaliveConstants.TYPE_PROMOTIONALCARD:
                navigateToPromotionalCardActivity();
                break;
            case AdaliveConstants.TYPE_MANAGER:
                navigateToManagerApplicationActivity();
                break;

            case AdaliveConstants.TYPE_GEOFENCE:
                navigateToGeofenceActivity();
                break;

            default:
                break;

        }

    }
    //endregion

    //region Scanner Permissions
    private Permission.PermissionCallback mPermissionCallback = new Permission.PermissionCallback() {
        @Override
        public void onPermissionGranted(int i) {
            navigateToScannerActivity();
        }

        @Override
        public void onPermissionDenied(int i) {}

        @Override
        public void onPermissionAccessRemoved(int i) {}
    };

    /**
     * Verify if permission was granted.
     */

    private void checkPermissionsScanner() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {

            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                    || checkSelfPermission(Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {

                Permission.PermissionBuilder permissionBuilder = new Permission.PermissionBuilder(SCANNER_PERMISSIONS,
                        SCANNER_PERMISSION_REQUESTED,
                        mPermissionCallback).enableDefaultRationalDialog(getString(R.string.DIALOG_TITLE_PERMISSION),
                        getString(R.string.DIALOG_SCANNER_MESSAGE_PERMISSION));
                requestAppPermissions(permissionBuilder.build());

            } else {
                navigateToScannerActivity();
            }
        } else {
            navigateToScannerActivity();
        }
    }
    //endregion

    //region Button Actions
    @OnClick(R.id.btnDrawer)
    protected void onBtnDrawerTouched() {
        if (!drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.openDrawer(GravityCompat.START, true);
            rvMenu.setVisibility(View.VISIBLE);
        }
    }

    @OnClick(R.id.ivMenu)
    protected void onIvMenuTouched() {
        if (!drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.openDrawer(GravityCompat.START, true);
            rvMenu.setVisibility(View.VISIBLE);
        }
    }

    @OnClick(R.id.ivChat)
    protected void onIvChatTouched() {
        if (this instanceof ChatGroupListActivity ||
                this instanceof ChatActivity) {
            return;
        }

        AdaliveApplication.getInstance().setClearNotificationValue();

        Intent intent = new Intent(this, ChatGroupListActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.ivNotification)
    protected void onIvNotificationTouched() {
        Intent intent = new Intent(this, NotificationActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.ivCart)
    protected void onIvCartTouched() {
        showProgress();
        title = menuName;
        menuInteractor.getUrl(urlCarrinho.substring(urlCarrinho.length() - 2), this, getUserToken());
    }

    //endregion

    //region Toolbar
    @Override
    public void closeDrawer() {
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            rvMenu.setVisibility(View.GONE);
            drawer.closeDrawer(GravityCompat.START, true);
        }
    }

    @Override
    public void setUserPhoto(String imageUrl) {
        RequestOptions options = new RequestOptions();
        options.placeholder(R.drawable.ic_picture_placeholder);

        if (!TextUtils.isEmpty(imageUrl)) {
            Glide.with(this)
                    .load(imageUrl)
                    .apply(options)
                    .into(ivProfilePhoto);
        }
    }

    @Override
    public void setToolbarTitle(int title) {
        tvTitle.setText(getString(title));
        if (this instanceof TimelineActivity) {
            tvTitle.setGravity(Gravity.CENTER);
            ivMenu.setVisibility(View.VISIBLE);
            ivChat.setVisibility(View.VISIBLE);
            ivGallery.setVisibility(View.GONE);
            ivNotification.setVisibility(View.VISIBLE);
            txtEdit.setVisibility(View.GONE);
            ivSearch.setVisibility(View.GONE);
            ivDownload.setVisibility(View.GONE);
        } else {
            ivMenu.setVisibility(View.GONE);
            ivChat.setVisibility(View.GONE);
            ivGallery.setVisibility(View.GONE);
            ivNotification.setVisibility(View.GONE);
            txtEdit.setVisibility(View.GONE);
            ivSearch.setVisibility(View.GONE);
            ivDownload.setVisibility(View.GONE);
        }
    }

    @Override
    public void setToolbarTitle(String title) {
        tvTitle.setText(title);
        if (this instanceof TimelineActivity) {
            tvTitle.setGravity(Gravity.CENTER);
            ivMenu.setVisibility(View.VISIBLE);
            ivChat.setVisibility(View.VISIBLE);
            ivGallery.setVisibility(View.GONE);
            ivNotification.setVisibility(View.VISIBLE);
            txtEdit.setVisibility(View.GONE);
            ivSearch.setVisibility(View.GONE);
            ivDownload.setVisibility(View.GONE);
        } else if (this instanceof WebviewActivity){
            tvTitle.setGravity(Gravity.CENTER);
            ivMenu.setVisibility(View.VISIBLE);
            ivChat.setVisibility(View.GONE);
            ivGallery.setVisibility(View.GONE);
            ivNotification.setVisibility(View.GONE);
            txtEdit.setVisibility(View.GONE);
            ivSearch.setVisibility(View.GONE);
            ivDownload.setVisibility(View.GONE);
            if(title.equals("Loja Virtual")){
                ivCart.setVisibility(View.VISIBLE);
            }
        }else {
            ivMenu.setVisibility(View.GONE);
            ivChat.setVisibility(View.GONE);
            ivGallery.setVisibility(View.GONE);
            ivNotification.setVisibility(View.GONE);
            txtEdit.setVisibility(View.GONE);
            ivSearch.setVisibility(View.GONE);
            ivDownload.setVisibility(View.GONE);
        }
    }

    @Override
    public void navigateToAgendaActivity() {
        Intent intent = new Intent(this, EventsTabActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED, true);
        startActivity(intent);
    }
    //endregion

    //region  Navigation : Destinies
    public void navigateLogOut() {
        AdaliveApplication application = AdaliveApplication.getInstance();
        mInteractor = new ChatInteractor(this);
        mInteractor.unregisterDeviceId(1, application.getUser().getId(), application.getFcmToken(), this);

        userLogOut();

        //ActivityCompat.finishAffinity(this);
        //ProcessPhoenix.triggerRebirth(this);

        finish();

        Intent intent = new Intent(this, SplashScreenActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }




    public void navigateToAtlantic() {
        Uri uri = Uri.parse("http://atlanticsolutions.com.br");
        CustomTabsIntent.Builder customTabsIntentBuilder = new CustomTabsIntent.Builder(null);
        CustomTabsIntent customTabsIntent = customTabsIntentBuilder.build();
        customTabsIntent.launchUrl(NavigationDrawerActivity.this, uri);
    }

    @Override
    public void navigateToTimelineActivity() {
        if (this instanceof TimelineActivity) {
            return;
        }

        Intent intent = new Intent(this, TimelineActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    @Override
    public void navigateToEditProfileActivity() {
        Intent intent = new Intent(this, EditProfileActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToEventsActivity() {
        Intent intent = new Intent(this, EventsTabActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_ONLY_REGISTERED, false);
        startActivity(intent);
    }

    @Override
    public void navigateToDocumentsActivity() {
        Intent intent = new Intent(this, DocumentCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToChatActivity() {
        if (this instanceof ChatGroupListActivity ||
                this instanceof ChatActivity) {
            return;
        }

        Intent intent = new Intent(this, ChatGroupListActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToSponsorsActivity() {
        Intent intent = new Intent(this, SponsorsActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToVideosActivity() {
        Intent intent = new Intent(this, VideoCategoryActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToScannerActivity() {
        Intent intent = new Intent(this, ScannerActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToShowCaseActivity() {
        Intent intent = new Intent(this, ShowCaseActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToShowCase360() {
        Intent intent = new Intent(this, ShowCase360Activity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToManagerApplicationActivity() {
        Intent intent = new Intent(this, ManagerApplicationActivity.class);
        startActivity(intent);
    }


    @Override
    public void navigateToGeofenceActivity() {
        Intent intent = new Intent(this, GeofenceActivity.class);
        startActivity(intent);
    }

    @Override
    public void navigateToPromotionalCardActivity() {
        Intent intent = new Intent(this, PrePromotionalCardActivity.class);
        startActivity(intent);
    }


    //    @Override
//    public void navigateToShowCase() {
//        startActivity(new Intent(this, CapturePhotoActivity.class));
//    }

    @Override
    public void navigateToAboutActivity() {
        StringBuilder url = new StringBuilder("");
        if(!url.toString().contains("http"))
            url.insert(0,"http://");

        Intent intent = new Intent(this, AboutActivity.class);
        intent.putExtra(AdaliveConstants.TAG_ACTION_URL, url.toString());
        startActivity(intent);
    }

    @Override
    public void navigateToParticipants() {
        /*
        Intent intent = new Intent(this, ParticipantsActivity.class);
        startActivity(intent);
        */
    }

    @Override
    public void navigateToEquip() {
        /*
        Intent intent = new Intent(this, EquipActivity.class);
        startActivity(intent);
        */
    }

    @Override
    public void navigateToGeneralSurvey() {
        /*
        Intent it = new Intent(NavigationDrawerActivity.this, LaucherSurveyActivity.class);

        String targetName = AdaliveApplication.getInstance().getLayoutParam().getSurveyGeral();
        it.putExtra(AdaliveConstants.INTENT_TAG_DIRECT_SURVEY, targetName);
        startActivity(it);
        */
    }

    //endregion


    //region Chat
    @Override
    public void onChatRequestError(String error, int requestType, int position) {}

    @Override
    public void onChatRequestSuccess(ChatBaseResponse response, int requestType, int position) {}
    //endregion

    //region Message
    private void showExitDialog() {
        new AlertDialog.Builder(this)
                .setTitle(getString(R.string.DIALOG_BUTTON_EXIT))
                .setMessage(getString(R.string.DIALOG_EXIT_MESSAGE))
                .setPositiveButton(getString(R.string.DIALOG_BUTTON_FINISH), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        navigateLogOut();
                    }
                })
                .setNegativeButton(getString(R.string.DIALOG_BUTTON_CANCEL), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                })
                .create()
                .show();
    }
    //endregion

    //region Subs
    @Override
    public void createSubscription() {
        profileChangeSubscription = AdaliveApplication.getBus().subscribe(RxQueues.USER_PROFILE_CHANGED_QUEUE, new Observer<ProfileChanged>() {
            @Override
            public void onCompleted() {}

            @Override
            public void onError(Throwable e) {}

            @Override
            public void onNext(ProfileChanged profileChanged) {
                setUserPhoto(profileChanged.getUser().getProfileImageURL());
            }
        });
    }

    @Override
    public void onUrlLoadError(Throwable e) {
        hideProgress();
        showSnackMessage(e.toString());
    }

    @Override
    public void onUrlLoadSuccess(Url response) {
        hideProgress();
        Intent it = new Intent(this, WebviewActivity.class);
        it.putExtra(AdaliveConstants.TAG_ACTION_URL, response.getUrl());
        if(title.equals("Carrinho"))title = "Loja Virtual";
        it.putExtra(AdaliveConstants.TAG_ACTION_WEBVIEW_TITLE, title);

        if (this instanceof WebviewActivity) {
            finish();
        }

        startActivity(it);
    }
    //endregion
}
