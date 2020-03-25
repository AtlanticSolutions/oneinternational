package br.com.lab360.bioprime.ui.viewholder.chat;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatGroupViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.btnTitle)
    protected Button btnTitle;
    @BindView(R.id.btnExit)
    protected ImageButton btnExit;


    public ChatGroupViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setTitle(String title){
        btnTitle.setText(title);
    }

    public void setBtnTitleClickListener(View.OnClickListener listener){
        btnTitle.setOnClickListener(listener);
    }

    public void setBtnExitClickListener(View.OnClickListener listener){
        btnExit.setOnClickListener(listener);
    }

    public ImageButton getBtnExit() {
        return btnExit;
    }
}