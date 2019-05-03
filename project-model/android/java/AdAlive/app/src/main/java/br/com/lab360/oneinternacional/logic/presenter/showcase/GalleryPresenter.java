package br.com.lab360.oneinternacional.logic.presenter.showcase;

import android.graphics.Bitmap;

import java.util.ArrayList;

import br.com.lab360.oneinternacional.logic.model.pojo.gallery.GalleryObject;
import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;
import br.com.lab360.oneinternacional.ui.view.IBaseView;

/**
 * Created by Edson on 14/05/2018.
 */

public class GalleryPresenter implements IBasePresenter {
    private GalleryPresenter.IGalleryView mView;
    private ArrayList<Bitmap> mItems;

    public GalleryPresenter(GalleryPresenter.IGalleryView view) {
        this.mView = view;
        this.mItems = new ArrayList<>();
        this.mView.setPresenter(this);
    }

    @Override
    public void start() {
        mView.initToolbar();
        mView.setupGridView();
    }

    public void gridItemClicked(GalleryObject galleryObject) {
        mView.expandImage(galleryObject.getImageBitmap());
    }


    public interface IGalleryView extends IBaseView {
        void initToolbar();
        void setPresenter(GalleryPresenter presenter);
        void setupGridView();
        void expandImage(Bitmap imageBitmap);
    }
}