package br.com.lab360.oneinternacional.ui.activity.notifications;


import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.view.View;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.logic.model.pojo.notification.NotificationObject;
import br.com.lab360.oneinternacional.logic.presenter.notifications.NotificationPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.notifications.NotificationRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import br.com.lab360.oneinternacional.utils.ScreenUtils;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;


public class NotificationActivity extends BaseActivity implements NotificationPresenter.INotificationListView {

    @BindView(R.id.rvNotifications)
    protected RecyclerView rvNotifications;

    private NotificationPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifications);
        ButterKnife.bind(this);

        new NotificationPresenter(this);


    }

    @Override
    public void initToolbar() {
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {

            ScreenUtils.updateStatusBarcolor(this, topColor);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    @Override
    public void setPresenter(NotificationPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }


    @Override
    public void setupRecyclerView() {

        final NotificationRecyclerAdapter adapter = new NotificationRecyclerAdapter(this);
        rvNotifications.setAdapter(adapter);
        rvNotifications.setHasFixedSize(true);
        rvNotifications.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvNotifications.addOnItemTouchListener(new RecyclerItemClickListener(this, rvNotifications, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {

                NotificationObject notificationObject = mPresenter.getNotification(position);

                if (!Strings.isNullOrEmpty(notificationObject.getInfo())) {
                    /*
                    Intent it = new Intent(NotificationActivity.this, LaucherSurveyActivity.class);
                    it.putExtra(AdaliveConstants.INTENT_TAG_DIRECT_SURVEY, notificationObject.getInfo());
                    startActivity(it);
                    */
                }

            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));

    }


    @Override
    public void updateList(ArrayList<NotificationObject> mfilteredList) {
        ((NotificationRecyclerAdapter) rvNotifications.getAdapter()).replaceAll(mfilteredList);
    }

    @Override
    public void updateItem(int position) {
        rvNotifications.getAdapter().notifyItemChanged(position);
    }


}
