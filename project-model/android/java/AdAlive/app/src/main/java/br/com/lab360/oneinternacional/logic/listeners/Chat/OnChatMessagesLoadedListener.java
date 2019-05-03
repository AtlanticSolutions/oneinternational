package br.com.lab360.oneinternacional.logic.listeners.Chat;

import br.com.lab360.oneinternacional.logic.model.pojo.chat.ChatBaseResponse;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public interface OnChatMessagesLoadedListener {
    void onMessagesLoaded(ChatBaseResponse response);
    void onMessagesLoadError(String error);
}
