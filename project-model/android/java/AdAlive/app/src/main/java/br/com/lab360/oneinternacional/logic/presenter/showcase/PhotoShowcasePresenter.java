package br.com.lab360.oneinternacional.logic.presenter.showcase;

import br.com.lab360.oneinternacional.logic.presenter.IBasePresenter;

public class PhotoShowcasePresenter implements IBasePresenter {
    private IPhotoShowcasePresenter view;

    public PhotoShowcasePresenter(IPhotoShowcasePresenter view) {
        this.view = view;
        view.setPresenter(this);
    }

    @Override
    public void start() {
        view.setupRecyclerView();
    }

    public void onAddClicked() {
        view.addAnotherLayerImage();
    }

    public void onRemoveClicked() {
        view.removeImageLayer();
    }

    public interface IPhotoShowcasePresenter {

        void setPresenter(PhotoShowcasePresenter presenter);

        void setupRecyclerView();

        void addAnotherLayerImage();

        void removeImageLayer();

    }
}
