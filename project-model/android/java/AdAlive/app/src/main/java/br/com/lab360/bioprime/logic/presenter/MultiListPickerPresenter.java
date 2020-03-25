package br.com.lab360.bioprime.logic.presenter;

import java.util.ArrayList;

import br.com.lab360.bioprime.logic.model.pojo.user.BaseObject;

/**
 * Created by Alessandro Valenza on 23/11/2016.
 */
public class MultiListPickerPresenter implements IBasePresenter {
    private IMultiListPickerView mView;
    private ArrayList<BaseObject> mListItems;
    private String mTitle;

    public MultiListPickerPresenter(IMultiListPickerView view, ArrayList<BaseObject> items, String title) {
        this.mView = view;
        this.mListItems = items;
        this.mTitle = title;
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar(mTitle);
        mView.setupRecyclerView();
        mView.populateRecyclerView(mListItems);
    }

    public void onItemSelected(int position){
        mListItems.get(position).toggleSelection();
        mView.notifyItemChanged(position,mListItems.get(position));
    }

    public void setResult(){
        mView.setResult(mListItems);
    }

    public interface IMultiListPickerView {
        void initToolbar(String mTitle);

        void setPresenter(MultiListPickerPresenter presenter);

        void setupRecyclerView();

        void populateRecyclerView(ArrayList<BaseObject> mListItems);

        void notifyItemChanged(int position, BaseObject object);

        void setResult(ArrayList<BaseObject> mListItems);
    }
}