package br.com.lab360.bioprime.logic.listeners.Chat;

import br.com.lab360.bioprime.logic.model.pojo.chat.EventMessage;

/**
 * Created by Alessandro Valenza on 05/12/2016.
 */
public interface OnChatMessageSentListener {
    void onSendMessageSuccess(EventMessage messageSent, int position);
    void onSendMessageError(String message, int position);
}

