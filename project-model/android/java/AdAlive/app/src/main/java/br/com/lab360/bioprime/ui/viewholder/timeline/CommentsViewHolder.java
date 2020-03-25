package br.com.lab360.bioprime.ui.viewholder.timeline;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.TextView;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by Alessandro Valenza on 18/01/2017.
 */
public class CommentsViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.ivCommentProfilePhoto)
    CircleImageView ivCommentProfilePhoto;
    @BindView(R.id.tvPostOwnerName)
    TextView tvPostOwnerName;
    @BindView(R.id.tvPostDate)
    TextView tvPostDate;
    @BindView(R.id.tvCommentMessage)
    TextView tvCommentMessage;

    public CommentsViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setPostOwnerName(String name){
        tvPostOwnerName.setText(name);
    }

    public void setPostDate(String date){
        tvPostDate.setText(date);
    }

    public void setMessage(String message){
        tvCommentMessage.setText(message);
    }

    public CircleImageView getCommentProfilePhoto() {
        return ivCommentProfilePhoto;
    }
}