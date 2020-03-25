package br.com.lab360.bioprime.logic.rxbus.events;

import com.google.gson.Gson;

import java.util.Map;

import br.com.lab360.bioprime.logic.model.pojo.chat.EventMessage;


/**
 * Created by Alessandro Valenza on 09/11/2016.
 */

public class FcmMessageReceivedEvent {
    private EventMessage chatMessage;

    public FcmMessageReceivedEvent(Map<String, String> data) {
        chatMessage = new Gson().fromJson(data.get("message"),EventMessage.class);
    }

    public EventMessage getChatMessage() {
        return chatMessage;
    }

}
