package br.com.lab360.bioprime.logic.listeners.Chat;

import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public interface OnChatMessagesLoadedListener {
    void onMessagesLoaded(ChatBaseResponse response);
    void onMessagesLoadError(String error);
}
