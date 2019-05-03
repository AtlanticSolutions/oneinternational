package br.com.lab360.oneinternacional.ui.activity.timeline;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.appcompat.widget.Toolbar;
import android.widget.EditText;
import android.widget.ImageButton;

import com.google.common.base.Strings;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.CommentObject;
import br.com.lab360.oneinternacional.logic.model.pojo.timeline.Post;
import br.com.lab360.oneinternacional.logic.presenter.timeline.CommentPresenter;
import br.com.lab360.oneinternacional.ui.activity.BaseActivity;
import br.com.lab360.oneinternacional.ui.adapters.timeline.CommentsRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.UserUtils;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CommentActivity extends BaseActivity implements CommentPresenter.ICommentView {

    @BindView(R.id.btnSendMessage)
    protected ImageButton btnSendMessage;
    @BindView(R.id.etMessage)
    protected EditText etMessage;
    @BindView(R.id.rvComments)
    protected RecyclerView rvComments;

    private CommentPresenter mPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comment);
        ButterKnife.bind(this);

        Post post = (Post) getIntent().getExtras().get(AdaliveConstants.INTENT_TAG_TIMELINE_POST);
        new CommentPresenter(this, post);

        //Paulo Create a generic method - Paulo
        String topColor = UserUtils.getBackgroundColor(this);

        if (!Strings.isNullOrEmpty(topColor)) {
            Toolbar myToolbar = (Toolbar) findViewById(R.id.toolbar);
            setSupportActionBar(myToolbar);

            ColorDrawable cd = new ColorDrawable(Color.parseColor(topColor));
            getSupportActionBar().setBackgroundDrawable(cd);
        }
    }

    @Override
    public void initToolbar(){
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public void setPresenter(CommentPresenter presenter) {
        this.mPresenter = presenter;
        this.mPresenter.start();
    }

    @Override
    public void clearEditText() {
        this.etMessage.setText("");
    }

    @Override
    public void setupCommentsRecyclerView(ArrayList<CommentObject> comments) {
        rvComments.setLayoutManager(new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false));
        rvComments.setHasFixedSize(false);
        rvComments.setAdapter(new CommentsRecyclerAdapter(this, comments));
    }

    @Override
    public void populateCommentsRecyclerView(ArrayList<CommentObject> comments) {
        ((CommentsRecyclerAdapter)rvComments.getAdapter()).replaceAll(comments);
    }

    @OnClick(R.id.btnSendMessage)
    public void onBtnSendMessageTouched() {
        mPresenter.onBtnSendMessageTouched(etMessage.getText().toString());
    }
}
