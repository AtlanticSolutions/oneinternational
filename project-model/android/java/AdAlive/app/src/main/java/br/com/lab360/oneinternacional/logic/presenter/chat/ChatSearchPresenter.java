package br.com.lab360.oneinternacional.logic.presenter.chat;

import android.util.Log;

import com.google.common.base.Strings;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.interactor.ChatInteractor;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnAddChatUserListener;
import br.com.lab360.oneinternacional.logic.listeners.Chat.OnGetChatUsersListener;
import br.com.lab360.oneinternacional.logic.listeners.OnGroupLoadedListener;
import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;
import br.com.lab360.oneinternacional.logic.model.pojo.user.User;
import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatUser;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class ChatSearchPresenter implements IBasePresenter, OnGroupLoadedListener, OnGetChatUsersListener, OnAddChatUserListener {
    private final ChatInteractor mInteractor;
    private final boolean isGroup;
    private final ArrayList<BaseObject> mAlreadyRegisted;

    private IChatSearchNewView mView;
    private ArrayList<BaseObject> mfilteredList;
    private ArrayList<BaseObject> mItems;
    private BaseObject mItemSelected;
    private int mSelectedPosition;

    public ChatSearchPresenter(IChatSearchNewView view, boolean isGroup, ArrayList<BaseObject> listGroup) {
        this.mView = view;
        this.isGroup = isGroup;
        this.mInteractor = new ChatInteractor(mView.getContext());
        this.mItems = new ArrayList<>();
        this.mAlreadyRegisted = listGroup;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.setupSearchView();
        mView.setupRecyclerView();
        mView.showProgress();
        if (isGroup) {
            mInteractor.getChatGroups(AdaliveConstants.ACCOUNT_ID, this);
            return;
        }
        User user = AdaliveApplication.getInstance().getUser();
        mInteractor.getChatUsers(AdaliveConstants.ACCOUNT_ID, user.getId(), this);
    }

    public void onQueryTextChange(String query) {
        mfilteredList = filter(mItems, query);
        mView.updateList(mfilteredList);
    }

    private ArrayList<BaseObject> filter(ArrayList<BaseObject> models, String query) {
        final String lowerCaseQuery = query.toLowerCase();

        final ArrayList<BaseObject> filteredModelList = new ArrayList<>();
        for (BaseObject model : models) {

            final String text = model.getName().toLowerCase();
            final String jobRole = model.getCargo().toLowerCase();

            if (text.contains(lowerCaseQuery) || jobRole.contains(lowerCaseQuery)) {
                filteredModelList.add(model);
            }
        }
        return filteredModelList;
    }

    public void onItemSelected(int position) {
        if (mfilteredList.size() > 0) {
            mItemSelected = mfilteredList.get(position);
        } else {
            mItemSelected = mItems.get(position);
        }

        if(!isGroup || mItemSelected.isSelected()){
            mView.navigateToChatActivity(mItemSelected,isGroup);
            return;
        }
        mSelectedPosition = position;
        User mUser = AdaliveApplication.getInstance().getUser();
        mInteractor.addChatUser(mUser.getId(), mItemSelected.getId(),this);
    }

    //region OnUserGroupLoadedListener
    @Override
    public void onActiveGroupsLoadSuccess(ArrayList<BaseObject> groups) {
        for(BaseObject object : mAlreadyRegisted){
            if(groups.contains(object)){
                int index = groups.indexOf(object);
                groups.get(index).toggleSelection();
            }
        }

        Collections.sort(groups, new Comparator<BaseObject>()
        {
            @Override
            public int compare(BaseObject o1, BaseObject o2) {
                return o1.getName().compareToIgnoreCase(o2.getName());
            }
        });

        mItems = groups;
        mfilteredList = groups;
        mView.hideProgress();
        mView.updateList(groups);
    }

    @Override
    public void onActiveGroupsLoadError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }
    //endregion

    //region OnGetChatUsersListener
    @Override
    public void onGetChatUsersError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }

    @Override
    public void onGetChatUsersSuccess(ArrayList<ChatUser> chatUsers) {
        User mUser = AdaliveApplication.getInstance().getUser();
        mItems = new ArrayList<>();
        mfilteredList = new ArrayList<>();
        for(ChatUser user : chatUsers){
            if(user.getId() == mUser.getId()){
                continue;
            }

            if(!Strings.isNullOrEmpty(user.getCity())){
                Log.v("erro", "ssss");
            }


            BaseObject listObject = new BaseObject(user.getId(), user.getFirstName(), user.getEmail(), user.getJobRole(), user.getCity(), user.getState());

//            BaseObject listObject = new BaseObject(user.getId(), user.getFirstName(), user.getEmail(), "DIRETOR", "CIDADE", "SP");

            if(mAlreadyRegisted.contains(listObject)){
                listObject.toggleSelection();
            }
            mItems.add(listObject);
        }

        Collections.sort(mItems, new Comparator<BaseObject>()
        {
            @Override
            public int compare(BaseObject o1, BaseObject o2) {
                return o1.getName().compareToIgnoreCase(o2.getName());
            }
        });

        mfilteredList.addAll(mItems);

        mView.hideProgress();
        mView.updateList(mfilteredList);
    }
    //endregion

    //region OnGetChatUsersListener
    @Override
    public void onAddChatUserSuccess(ArrayList<Integer> groups) {
        mItems.get(mSelectedPosition).toggleSelection();
        mView.updateItem(mSelectedPosition);
        mView.navigateToChatActivity(mItemSelected, isGroup);
    }

    @Override
    public void onAddChatUserError(String message) {
        mView.hideProgress();
        mView.showToastMessage(message);
    }
    //endregion

    public interface IChatSearchNewView extends IBaseView {
        void initToolbar();

        void setPresenter(ChatSearchPresenter presenter);

        void setupRecyclerView();

        void setupSearchView();

        void updateList(ArrayList<BaseObject> mfilteredList);

        void navigateToChatActivity(BaseObject mItemSelected, boolean isGroup);

        void updateItem(int mSelectedPosition);
    }
}