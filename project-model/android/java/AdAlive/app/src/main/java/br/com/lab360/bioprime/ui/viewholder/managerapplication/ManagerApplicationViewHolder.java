package br.com.lab360.bioprime.ui.viewholder.managerapplication;

import android.content.Context;
import androidx.recyclerview.widget.RecyclerView;

import android.graphics.Color;
import android.graphics.PorterDuff;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import br.com.lab360.bioprime.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 29/06/2018.
 */

public class ManagerApplicationViewHolder extends RecyclerView.ViewHolder {

    @BindView(R.id.tvApplicationName)
    protected TextView tvApplicationName;

    @BindView(R.id.tvAppVersion)
    protected TextView tvAppVersion;

    @BindView(R.id.tvBuildVersion)
    protected TextView tvBuildVersion;

    @BindView(R.id.ivApplication)
    protected ImageView ivApplication;

    @BindView(R.id.ivShare)
    protected ImageView ivShare;

    @BindView(R.id.btnDownloadApplication)
    protected Button btnDownloadApplication;

    public ManagerApplicationViewHolder(View itemView) {
        super(itemView);
        ButterKnife.bind(this, itemView);
    }

    public void setTvApplicationName(String applicationName) {
        tvApplicationName.setText(applicationName);
    }

    public void setTvApplicationNameColor(String color) {
        tvApplicationName.setTextColor(Color.parseColor(color));
    }

    public void setTvAppVersion(String appVersion) {
        tvAppVersion.setText(appVersion);
    }

    public void setTvBuildVersion(String buildVersion) {
        tvBuildVersion.setText(buildVersion);
    }

    public void setIvApplication(String url, Context context) {
        if (url == null || url.isEmpty())
            return;

        Glide.with(context)
                .load(url)
                .into(ivApplication);
    }
    public void setBtnDownloadApplicationColor(String color) {
        btnDownloadApplication.setBackgroundColor(Color.parseColor(color));
    }

    public Button getBtnDownloadApplication(){
        return btnDownloadApplication;
    }

    public void setIvShareColor(String color) {
        ivShare.setColorFilter(Color.parseColor(color), PorterDuff.Mode.SRC_IN);
    }

    public ImageView getIvShare(){
        return ivShare;
    }
}