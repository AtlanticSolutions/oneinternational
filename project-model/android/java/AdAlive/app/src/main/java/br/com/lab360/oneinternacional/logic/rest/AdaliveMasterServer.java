package br.com.lab360.oneinternacional.logic.rest;


import br.com.lab360.oneinternacional.logic.model.pojo.MasterServerResponse;
import retrofit2.http.GET;
import retrofit2.http.Query;
import rx.Observable;

/**
 * Created by Alessandro Valenza on 28/10/2016.
 */

public interface AdaliveMasterServer {

    @GET("/api/v1/master_apps")
    Observable<MasterServerResponse> getMasterServerData(
            @Query("app_id") int appId,
            @Query("device_name") String device_name,
            @Query("longitude") String longitude,
            @Query("latitude") String latitude,
            @Query("device_system_name") String device_system_name,
            @Query("device_id_vendor") String device_id_vendor,
            @Query("device_system_version") String device_system_version,
            @Query("device_model") String device_model,
            @Query("device_version") String device_version
            );


}
