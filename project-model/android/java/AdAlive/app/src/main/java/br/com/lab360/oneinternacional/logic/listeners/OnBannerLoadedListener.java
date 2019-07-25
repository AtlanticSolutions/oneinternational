package br.com.lab360.oneinternacional.logic.listeners;

import br.com.lab360.oneinternacional.logic.model.pojo.timeline.BannerResponse;

public interface OnBannerLoadedListener {
    void onBannerLoadError(Throwable e);
    void onBannerLoadSuccess(BannerResponse response);
}
