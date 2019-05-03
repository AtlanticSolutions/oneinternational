package br.com.lab360.oneinternacional.ui.viewholder.downloads;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Alessandro Valenza on 26/10/2016.
 */
public class MyDownloadInfoViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.tvFileName)
    protected TextView tvFileName;

    @BindView(R.id.tvAuthor)
    protected TextView tvAuthor;

    @BindView(R.id.tvCompany)
    protected TextView tvCompany;

    @BindView(R.id.imgDelete)
    protected ImageButton imgDelete;

    @BindView(R.id.btnOpen)
    protected Button btnOpen;

    public MyDownloadInfoViewHolder(View itemView) {
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

    public ImageButton getImgDelete() {
        return imgDelete;
    }

    public Button getBtnOpen() {
        return btnOpen;
    }

}