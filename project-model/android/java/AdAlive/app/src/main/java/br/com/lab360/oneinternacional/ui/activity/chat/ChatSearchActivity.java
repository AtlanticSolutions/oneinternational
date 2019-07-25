package br.com.lab360.oneinternacional.ui.activity.chat;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.appcompat.widget.SearchView;
import androidx.appcompat.widget.Toolbar;
import android.view.View;

import com.google.common.base.Strings;
import com.simplecityapps.recyclerview_fastscroll.views.FastScrollRecyclerView;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.user.BaseObject;
import br.com.lab360.oneinternacional.logic.presenter.chat.ChatSearchPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.chat.ChatSearchRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;

public class ChatSearchActivity extends BaseActivity implements ChatSearchPresenter.IChatSearchNewView, SearchView.OnQueryTextListener {

    @BindView(R.id.searchView)
    protected SearchView searchView;

    @BindView(R.id.rvChatSearch)
    protected FastScrollRecyclerView rvChatSearch;

    private ChatSearchPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_search_new);
        ButterKnife.bind(this);

        Bundle extras = getIntent().getExtras();
        boolean isGroup = extras.getBoolean(AdaliveConstants.INTENT_TAG_GROUP);
        ArrayList<BaseObject> listGroup = extras.getParcelableArrayList(AdaliveConstants.INTENT_TAG_GROUP_LIST);
        new ChatSearchPresenter(this, isGroup, listGroup);


    }

    @Override
    protected void onResume() {
        super.onResume();

        searchView.setFocusable(true);
        searchView.setIconified(false);
        searchView.requestFocus();
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent(this, ChatGroupListActivity.class);
        startActivity(intent);
        finish();
    }

    @Override
    public void initToolbar() {

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onBackPressed();
            }
        });

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ScreenUtils.updateStatusBarcolor(this, topColor);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    @Override
    public void setPresenter(ChatSearchPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void setupRecyclerView() {
        final ChatSearchRecyclerAdapter adapter = new ChatSearchRecyclerAdapter(this);
        rvChatSearch.setThumbColor(Color.parseColor(UserUtils.getBackgroundColor(this)));
        rvChatSearch.setPopupBgColor(Color.parseColor(UserUtils.getBackgroundColor(this)));
        rvChatSearch.setAdapter(adapter);
        rvChatSearch.setHasFixedSize(true);
        rvChatSearch.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvChatSearch.addOnItemTouchListener(new RecyclerItemClickListener(this, rvChatSearch, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                mPresenter.onItemSelected(position);
            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));
    }

    @Override
    public void setupSearchView() {
        searchView.setOnQueryTextListener(this);
    }

    @Override
    public void updateList(ArrayList<BaseObject> mfilteredList) {
        ((ChatSearchRecyclerAdapter) rvChatSearch.getAdapter()).replaceAll(mfilteredList);
    }

    @Override
    public void updateItem(int position) {
        rvChatSearch.getAdapter().notifyItemChanged(position);
    }

    @Override
    public void navigateToChatActivity(BaseObject mItemSelected, boolean isGroup) {
        Intent intent = new Intent(this, ChatActivity.class);
        intent.putExtra(AdaliveConstants.INTENT_TAG_CHAT, mItemSelected);
        intent.putExtra(AdaliveConstants.INTENT_TAG_GROUP, isGroup);
        startActivity(intent);
        overridePendingTransition(R.anim.slide_in, R.anim.nothing);
    }

    //region SearchView.OnQueryTextListener
    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }

    @Override
    public boolean onQueryTextChange(String query) {
        mPresenter.onQueryTextChange(query);
        return true;
    }
    //endregion
}
