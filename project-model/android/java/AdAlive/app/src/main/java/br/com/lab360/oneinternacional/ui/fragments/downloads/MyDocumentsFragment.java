package br.com.lab360.oneinternacional.ui.fragments.downloads;


import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import androidx.fragment.app.Fragment;
import androidx.core.content.FileProvider;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.MimeTypeMap;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveApplication;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.listeners.OnBtnDeleteTouchListener;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.downloads.MyDocumentsListPresenter;
import br.com.lab360.oneinternacional.logic.rxbus.RxQueues;
import br.com.lab360.oneinternacional.logic.rxbus.events.DownloadFileDeletedEvent;
import br.com.lab360.oneinternacional.ui.adapters.downloads.MyDownloadsRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.DownloadUtils;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import butterknife.BindView;
import butterknife.ButterKnife;


public class MyDocumentsFragment extends Fragment implements MyDocumentsListPresenter.IDownloadListView, OnBtnDeleteTouchListener {

    private static final String ARG_PARAM1 = "documents";


    @BindView(R.id.recyclerview_events)
    RecyclerView recyclerviewEvents;

    @BindView(R.id.textview_empty)
    TextView textviewEmpty;

    private MyDocumentsListPresenter mPresenter;
    private ArrayList<DownloadInfoObject> documents;


    public MyDocumentsFragment() {
    }

    public static MyDocumentsFragment newInstance(ArrayList<DownloadInfoObject> documents) {

        MyDocumentsFragment fragment = new MyDocumentsFragment();
        Bundle args = new Bundle();
        args.putParcelableArrayList(ARG_PARAM1, documents);
        fragment.setArguments(args);
        return fragment;

    }

    //region Android Lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            documents = getArguments().getParcelableArrayList(ARG_PARAM1);
        }
        mPresenter = new MyDocumentsListPresenter(this, documents);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_all_documentos, container, false);
        ButterKnife.bind(this, view);

        if (mPresenter != null)
            mPresenter.start();
        return view;
    }
    //endregion



    @Override
    public void setPresenter(MyDocumentsListPresenter presenter) {
        this.mPresenter = presenter;
    }

    @Override
    public void setupRecyclerView(ArrayList<DownloadInfoObject> downloads) {

        final MyDownloadsRecyclerAdapter adapter = new MyDownloadsRecyclerAdapter(downloads, getContext(), this);
        recyclerviewEvents.setAdapter(adapter);
        recyclerviewEvents.setHasFixedSize(true);
        recyclerviewEvents.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false));
        recyclerviewEvents.addOnItemTouchListener(new RecyclerItemClickListener(getContext(), recyclerviewEvents, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {

            }

            @Override
            public void onItemLongClick(View view, int position) {

            }
        }));

    }


    @Override
    public void showEmptyListText() {
        recyclerviewEvents.setVisibility(View.GONE);
        textviewEmpty.setVisibility(View.VISIBLE);
    }
    //endregion


    @Override
    public void attemptToOpenFile(String fileName, final String mime) {

        File file = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getPath() + "/AHK/" + fileName);

        StringBuilder filePath = new StringBuilder(String.valueOf(Environment.DIRECTORY_DOWNLOADS))
                .append("/AHK")
                .append("/")
                .append(fileName);

        //File file = new File(sdcard, String.valueOf(filePath));

        if (!file.exists()) {
            Toast.makeText(getActivity(), getString(R.string.ALERT_MESSAGE_FILE_NOT_FOUND), Toast.LENGTH_SHORT).show();
            return;
        }

        MimeTypeMap map = MimeTypeMap.getSingleton();
        String ext = file.getName().substring(file.getName().lastIndexOf(".") + 1, file.getName().length());
        String type = map.getMimeTypeFromExtension(ext);

        /*if (type != MIME_TYPE_PDF && !AppUtils.canDisplayPdf(this)) {

            Toast.makeText(this,getText(R.string.ALERT_MESSAGE_NO_PDF), Toast.LENGTH_LONG).show();
            //Intent intent = new Intent(this, PdfViewActivity.class);
            //intent.putExtra(AppConstants.TAG_PDF, filePath.toString());
            //startActivity(intent);
            return;
        }*/

        if (type == null)
            type = "*/*";

        Uri data = FileProvider.getUriForFile(this.getContext(),
                AdaliveConstants.FILE_PROVIDER_URI,
                file);

        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(data, type);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        startActivity(intent);
    }

    @Override
    public void removeFile(DownloadInfoObject objectDeleted) {
        DownloadUtils.removeFileFromMyDownloadList(getContext(), objectDeleted);
        DownloadUtils.removeFileFromDevice(objectDeleted);

        AdaliveApplication.getBus().publish(RxQueues.DELETE_DOWNALOADED_FILE, new DownloadFileDeletedEvent());
    }

    @Override
    public void onBtnDeleteTouched(final int position) {

        new AlertDialog.Builder(getActivity())
                .setTitle(getString(R.string.DIALOG_DELETE_TITLE))
                .setMessage(getString(R.string.DIALOG_DELETE_MESSAGE))
                .setPositiveButton(getString(R.string.DIALOG_DELETE_BUTTON_FINISH), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        mPresenter.onDocumentToDelete(position);
                        ((MyDownloadsRecyclerAdapter)recyclerviewEvents.getAdapter()).remove(position);
                    }
                })
                .setNegativeButton(getString(R.string.DIALOG_DELETE_BUTTON_CANCEL), new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                })
                .create()
                .show();

    }

    @Override
    public void onBtnOpenFileTouched(int position) {

        mPresenter.onDocumentTouched(position);


    }



}
