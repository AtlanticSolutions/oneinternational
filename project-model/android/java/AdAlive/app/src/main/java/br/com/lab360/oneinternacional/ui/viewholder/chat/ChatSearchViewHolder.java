package br.com.lab360.oneinternacional.ui.viewholder.chat;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public class ChatSearchViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tvTitle)
    protected TextView tvTitle;

    @BindView(R.id.ivCheckmark)
    protected ImageView ivCheckmark;

    @BindView(R.id.txtEmail)
    protected TextView txtEmail;

    @BindView(R.id.txtRole)
    protected TextView txtRole;

    @BindView(R.id.txtCity)
    protected TextView txtCity;


    public ChatSearchViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setTitle(String title){
        tvTitle.setText(title);
    }

    public void toggleSelected(){
        int visibility = ivCheckmark.getVisibility() == View.VISIBLE ? View.GONE : View.VISIBLE;
        ivCheckmark.setVisibility(visibility);
    }

    public void recycle() {
        ivCheckmark.setVisibility(View.GONE);
    }

    public void setEmail(String email){
        txtEmail.setText(email);
    }

    public void setRole(String role){
        txtRole.setText(role);
    }

    public void setCity(String city){
        txtCity.setText(city);
    }

    public void setInvisibleEmail(){ txtEmail.setVisibility(View.GONE);}

    public void setInvisibleRole(){ txtRole.setVisibility(View.GONE);}

    public void setInvisibleCity(){ txtCity.setVisibility(View.GONE);}

}