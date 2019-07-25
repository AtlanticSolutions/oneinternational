package br.com.lab360.oneinternacional.ui.fragments.downloads;

import android.content.Intent;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.R;
import br.com.lab360.oneinternacional.application.AdaliveConstants;
import br.com.lab360.oneinternacional.logic.model.pojo.download.DownloadInfoObject;
import br.com.lab360.oneinternacional.logic.presenter.downloads.AllDocumentsListPresenter;
import br.com.lab360.oneinternacional.ui.activity.downloads.FileDescriptionActivity;
import br.com.lab360.oneinternacional.ui.adapters.downloads.DownloadInfoRecyclerAdapter;
import br.com.lab360.oneinternacional.utils.DownloadUtils;
import br.com.lab360.oneinternacional.utils.RecyclerItemClickListener;
import butterknife.BindView;
import butterknife.ButterKnife;


public class AllDocumentosFragment extends Fragment implements AllDocumentsListPresenter.IDownloadDocumentsListView {

    private static final String ARG_PARAM1 = "documents";

    @BindView(R.id.recyclerview_events)
    RecyclerView recyclerviewEvents;

    @BindView(R.id.textview_empty)
    TextView textviewEmpty;

    private AllDocumentsListPresenter mPresenter;
    private ArrayList<DownloadInfoObject> documents;

    private static final int REQUEST_DOWNLOAD_INFO = 0x32;

    public AllDocumentosFragment() {
        // Required empty public constructor
    }

    public static AllDocumentosFragment newInstance() {

        AllDocumentosFragment fragment = new AllDocumentosFragment();
//        Bundle args = new Bundle();
//        args.putParcelableArrayList(ARG_PARAM1, documents);
//        fragment.setArguments(args);
        return fragment;

    }

    //region Android Lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            documents = getArguments().getParcelableArrayList(ARG_PARAM1);
        }
        mPresenter = new AllDocumentsListPresenter(this, getContext());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_all_documentos, container, false);
        ButterKnife.bind(this, view);

        if (mPresenter != null) {
            mPresenter.start();
        }

        return view;
    }
    //endregion

    @Override
    public void setPresenter(AllDocumentsListPresenter presenter) {
        this.mPresenter = presenter;
    }

    @Override
    public void setupRecyclerView(ArrayList<DownloadInfoObject> downloads) {

        final DownloadInfoRecyclerAdapter adapter = new DownloadInfoRecyclerAdapter(downloads, getContext());
        recyclerviewEvents.setAdapter(adapter);
        recyclerviewEvents.setHasFixedSize(true);
        recyclerviewEvents.setLayoutManager(new LinearLayoutManager(getContext(), LinearLayoutManager.VERTICAL, false));
        recyclerviewEvents.addOnItemTouchListener(new RecyclerItemClickListener(getContext(), recyclerviewEvents, new RecyclerItemClickListener.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                mPresenter.onDocumentTouched (position);
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

    @Override
    public void attemptToOpenFile(String fileName, String mime) {

    }

    @Override
    public void downloadFile(DownloadInfoObject fileToDownload) {

        if(!DownloadUtils.alreadyDownloadedFile(getContext(),fileToDownload)){

            Intent intent = new Intent(getContext(), FileDescriptionActivity.class);
            intent.putExtra(AdaliveConstants.INTENT_TAG_DOWNLOAD, fileToDownload);
            startActivity(intent);
        }
    }

    //endregion

}
