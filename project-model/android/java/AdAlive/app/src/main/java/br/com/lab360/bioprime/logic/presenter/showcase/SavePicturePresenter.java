package br.com.lab360.bioprime.logic.presenter.showcase;

import br.com.lab360.bioprime.logic.presenter.IBasePresenter;

public class SavePicturePresenter implements IBasePresenter {
    private ISavePicturePresenter view;

    public SavePicturePresenter(ISavePicturePresenter view) {
        this.view = view;
        view.setPresenter(this);
    }

    @Override
    public void start() {
        view.loadUserImage();
        view.configureToolbarAndButtonColors();
    }

    public void onSaveClicked() {
        view.saveImageToGallery();
    }

    public void onShareClicked() {
        view.openShare();
    }

    public void onPictureFrameClicked() {
        view.expandUserImage();
    }

    public void onCloseBtnClicked() {
        view.closeExpandedUserImage();
    }

    public interface ISavePicturePresenter {

        void setPresenter(SavePicturePresenter presenter);

        void loadUserImage();

        void openShare();

        void saveImageToGallery();

        void configureToolbarAndButtonColors();

        void expandUserImage();

        void closeExpandedUserImage();
    }
}
