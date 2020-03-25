package br.com.lab360.bioprime.ui.adapters.managerapplication;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import br.com.lab360.bioprime.R;
import br.com.lab360.bioprime.logic.model.pojo.managerApplication.ManagerApplication;
import br.com.lab360.bioprime.ui.viewholder.managerapplication.ManagerApplicationViewHolder;
import br.com.lab360.bioprime.utils.UserUtils;

/**
 * Created by Edson on 29/06/2018.
 */

public class ManagerApplicationRecyclerAdapter extends RecyclerView.Adapter<ManagerApplicationViewHolder> {
    private List<ManagerApplication> managerApplications;
    private Context context;
    private OnManagerApplicationClicked listener;

    public ManagerApplicationRecyclerAdapter(List<ManagerApplication> managerApplications, Context context, OnManagerApplicationClicked listener) {
        this.listener = listener;
        this.managerApplications = managerApplications;
        this.context = context;
    }

    @Override
    public ManagerApplicationViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.recycler_manager_application_item, parent, false);
        return new ManagerApplicationViewHolder(v);
    }

    @Override
    public void onBindViewHolder(@NonNull final ManagerApplicationViewHolder holder, int position) {
        final ManagerApplication managerApplication = managerApplications.get(position);

        holder.setTvApplicationName(managerApplication.getNameApp());
        holder.setTvApplicationNameColor(UserUtils.getBackgroundColor(context));
        holder.setTvAppVersion(managerApplication.getVersionApp());
        holder.setTvBuildVersion(managerApplication.getBuildApp());
        holder.setIvApplication(managerApplication.getUrlIconApp(), context);

        holder.setIvShareColor(UserUtils.getBackgroundColor(context));
        holder.setBtnDownloadApplicationColor(UserUtils.getBackgroundColor(context));
        holder.getBtnDownloadApplication().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onDownloadButtonClick(managerApplication);
            }
        });

        holder.getIvShare().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onSharedClick(managerApplication);
            }
        });
    }

    @Override
    public int getItemCount() {
        return managerApplications.size();
    }

    @Override
    public int getItemViewType(int position) {
        return position;
    }


    public interface OnManagerApplicationClicked {
        void onDownloadButtonClick(ManagerApplication managerApplication);
        void onSharedClick(ManagerApplication managerApplication);
    }

}