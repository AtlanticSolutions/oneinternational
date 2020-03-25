package br.com.lab360.bioprime.logic.listeners;

import br.com.lab360.bioprime.logic.model.pojo.timeline.BannerResponse;

public interface OnBannerLoadedListener {
    void onBannerLoadError(Throwable e);
    void onBannerLoadSuccess(BannerResponse response);
}
