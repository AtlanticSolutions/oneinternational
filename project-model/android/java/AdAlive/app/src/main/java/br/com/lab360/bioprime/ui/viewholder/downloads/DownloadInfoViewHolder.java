package br.com.lab360.bioprime.ui.viewholder.downloads;

import android.graphics.drawable.Drawable;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 26/10/2016.
 */
public class DownloadInfoViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.tvFileName)
    protected TextView tvFileName;
    @BindView(R.id.tvAuthor)
    protected TextView tvAuthor;
    @BindView(R.id.tvCompany)
    protected TextView tvCompany;
    @BindView(R.id.ivIcon)
    protected ImageView ivIcon;

    public DownloadInfoViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setFileName(String fileName) {
        this.tvFileName.setText(fileName);
    }

    public void setAuthor(String author) {
        this.tvAuthor.setText(author);
    }

    public void setCompany(String company) {
        this.tvCompany.setText(company);
    }

    public void setIconDrawable(Drawable icon){
        ivIcon.setImageDrawable(icon);
    }
}