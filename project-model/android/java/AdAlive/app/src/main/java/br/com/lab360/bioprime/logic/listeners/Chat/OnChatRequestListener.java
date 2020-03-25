package br.com.lab360.bioprime.logic.listeners.Chat;

import androidx.annotation.IntDef;

import java.lang.annotation.Retention;

import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;

import static java.lang.annotation.RetentionPolicy.SOURCE;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */
public interface OnChatRequestListener {
    void onChatRequestError(String error, int requestType, int position);

    void onChatRequestSuccess(ChatBaseResponse response, int requestType, int position);

    @Retention(SOURCE)
    @IntDef({RequestType.FIND_SINGLE,
            RequestType.SEND_SINGLE,
            RequestType.FIND_GROUP,
            RequestType.SEND_GROUP,
            RequestType.REGISTER,
            RequestType.UNREGISTER})
    @interface RequestType {
        int FIND_SINGLE = 1;
        int SEND_SINGLE = 2;
        int FIND_GROUP = 3;
        int SEND_GROUP = 4;
        int REGISTER = 5;
        int UNREGISTER = 6;
    }
}
