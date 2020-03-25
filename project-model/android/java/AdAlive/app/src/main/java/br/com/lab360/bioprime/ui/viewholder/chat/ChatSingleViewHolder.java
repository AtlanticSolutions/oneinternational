package br.com.lab360.bioprime.ui.viewholder.chat;

import android.content.Context;
import android.graphics.PorterDuff;
import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 09/11/2016.
 */
public class ChatSingleViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.btnTitle)
    protected Button btnTitle;

    @BindView(R.id.btnBlock)
    protected ImageButton btnBlock;

    @BindView(R.id.txtEmail)
    protected TextView txtEmail;

    @BindView(R.id.txtCity)
    protected TextView txtCity;

    @BindView(R.id.tvTotalMessages)
    protected TextView tvTotalMessages;


    public ChatSingleViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setTitle(String title){
        btnTitle.setText(title);
    }

    public void setBtnTitleClickListener(View.OnClickListener listener){
        btnTitle.setOnClickListener(listener);
    }
    public void setBtnBlockClickListener(View.OnClickListener listener){
        btnBlock.setOnClickListener(listener);
    }

    public void setImageButtonColor(Context context, int resourceId){
        btnBlock.getDrawable().setColorFilter(ContextCompat.getColor(context,resourceId),PorterDuff.Mode.SRC_IN);
    }

    public void setEmail(String email){
        txtEmail.setText(email);
    }

    public void setInvisibleEmail(){
        txtEmail.setVisibility(View.GONE);
    }

    public void setRole(String role){
        txtEmail.setText(role);
    }

    public void setInvisibleRole(){
        txtEmail.setVisibility(View.GONE);
    }


    public void setCity(String city){
        txtCity.setText(city);
    }

    public void setInvisibleCity(){
        txtCity.setVisibility(View.GONE);
    }

    public ImageButton getBtnBlock() {
        return btnBlock;
    }

    public TextView getTvTotalMessages() {
        return tvTotalMessages;
    }

    public void setTotalMessages(int totalMessages) {
        this.tvTotalMessages.setText(String.valueOf(totalMessages));
    }
}