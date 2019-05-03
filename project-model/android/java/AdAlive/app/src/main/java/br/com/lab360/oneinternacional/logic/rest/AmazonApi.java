package br.com.lab360.oneinternacional.logic.rest;

import br.com.lab360.oneinternacional.logic.model.pojo.managerApplication.ManagerApplicationResponse;
import br.com.lab360.oneinternacional.logic.model.pojo.promotionalcard.Plist;
import retrofit2.http.GET;
import retrofit2.http.Path;
import rx.Observable;

/**
 * Created by Edson on 28/06/2018.
 */

public interface AmazonApi {

    @GET("/ad-alive.com/downloads/lab360/version/app_manager_android.xml")
    Observable<ManagerApplicationResponse> getManagerApplication();

    @GET("/ad-alive.com/downloads/lab360/promotionalcards/{card_name}/carddata.xml")
    Observable<Plist> getPromotionalCard(@Path("card_name") String cardname);
}
