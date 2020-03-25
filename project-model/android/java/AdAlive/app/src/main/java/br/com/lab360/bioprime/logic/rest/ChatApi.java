package br.com.lab360.bioprime.logic.rest;

import br.com.lab360.bioprime.logic.model.pojo.chat.ChatBaseResponse;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;
import rx.Observable;

/**
 * Created by Alessandro Valenza on 06/12/2016.
 */

public interface ChatApi {
    @FormUrlEncoded
    @POST("/webservice/client")
    Observable<ChatBaseResponse> postChatAction(@Field("parametros") String json);

}
