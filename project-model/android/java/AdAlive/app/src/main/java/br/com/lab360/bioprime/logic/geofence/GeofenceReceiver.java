package br.com.lab360.bioprime.logic.geofence;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import androidx.annotation.RequiresApi;
import android.telephony.TelephonyManager;
import android.text.format.DateFormat;
import android.text.format.DateUtils;

import com.google.android.gms.location.Geofence;
import com.google.android.gms.location.GeofencingEvent;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import br.com.lab360.bioprime.application.AdaliveApplication;
import br.com.lab360.bioprime.logic.model.pojo.geofence.GeofenceItem;
import br.com.lab360.bioprime.logic.model.pojo.geofence.GeofenceMessage;
import br.com.lab360.bioprime.utils.SharedPrefsHelper;
import lib.location.GPSTracker;

public class GeofenceReceiver extends IntentService {
    public static final int NOTIFICATION_ID = 1;
    private static final long GEOFENCE_EXPIRATION_IN_HOURS = 12;
    public static final long GEOFENCE_EXPIRATION_IN_MILLISECONDS = GEOFENCE_EXPIRATION_IN_HOURS * DateUtils.HOUR_IN_MILLIS;
    public static List<GeofenceItem> geofenceList;
    int transitionType;
    public GeofenceReceiver() {
        super("GeofenceReceiver");
    }

    public static List<GeofenceItem> mockGeofenceItems(){
        List<GeofenceItem> geofences = new ArrayList<>();
        geofences.add(new GeofenceItem("LAB360", -23.501929, -46.846406,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("CENTRO COMERCIAL", -23.498385, -46.849247,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("MCDONALDS", -23.498598, -46.847442,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("CAPGEMINI", -23.500271, -46.843106,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("WALLMART", -23.501861, -46.836505,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("TELHANORTE", -23.502682, -46.833083,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("PONTS", -23.507262, -46.832914,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("PONTO DE ONIBUS CASTELLO BRANCO", -23.508955, -46.823575,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ACIMA DE RODOANEL MARIO COVAS", -23.509565, -46.821163,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("POSTO SHELL TIETE", -23.523527, -46.762383,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("MERCADO LIVRE",  -23.524056, -46.760515,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("DETRAN ARMENIA",  -23.523718, -46.632513,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO ARMENIA",  -23.525546, -46.629319,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO TIRADENTES",  -23.531103, -46.632040,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇAO LUZ",  -23.536714, -46.633567,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO SAO BENTO",  -23.544379, -46.633707,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO SE",  -23.550121, -46.633332,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO PEDRO II",  -23.549865, -46.625904,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO BRAS",  -23.547827, -46.615956,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO BRESSER MOOCA",  -23.546461, -46.607200,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO BELEM",  -23.542964, -46.589580,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO TATUAPÉ",  -23.540267, -46.576588,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO TATUAPÉ",-23.540267, -46.576588,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO CARRAO",-23.537830, -46.564134,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO PENHA",-23.533540, -46.542585,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO VILA MATILDE",-23.531881, -46.530909,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO GUILHERMINA ESPERANÇA",-23.529311, -46.516543,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO PATRIARCA",-23.531145, -46.501443,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO PATRIARCA",-23.531145, -46.501443,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ESTAÇÃO ARTUR ALVIM",-23.540485, -46.484434,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("AUTO ESCOLA SECULO XXI",-23.540802, -46.486464,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("EMEI MARIA VITORIA DA CUNHA",-23.543917, -46.486169,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("PRAÇA DILVA GOMES",-23.546123, -46.483575,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("POSTO POLICIAL",-23.549764, -46.483090,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("DIA SUPERMERCADO",-23.550913, -46.480359,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));


        geofences.add(new GeofenceItem("VISTA ESTADIO CORINTHIANS",-23.551558, -46.478828,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("LIDER DISTRIBUIDORA",-23.554850, -46.479911,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("SUPERMERCADO BENGALA",-23.556095, -46.478282,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("POSTO BR",-23.557550, -46.475870,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("ACADEMIA LIDER",-23.560075, -46.474437,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("MERCADO ITA",-23.563009, -46.474509,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("CASA",-23.563960, -46.471951,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofences.add(new GeofenceItem("CAROL",-23.497306, -46.470011,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));


        geofences.add(new GeofenceItem("MÃE",-23.490623, -46.503278,
                100, GEOFENCE_EXPIRATION_IN_MILLISECONDS,
                Geofence.GEOFENCE_TRANSITION_ENTER
                        | Geofence.GEOFENCE_TRANSITION_DWELL
                        | Geofence.GEOFENCE_TRANSITION_EXIT));

        geofenceList = geofences;

        return geofences;
    }
    @RequiresApi(api = Build.VERSION_CODES.CUPCAKE)
    @Override
    protected void onHandleIntent(Intent intent) {
        GeofencingEvent geoEvent = GeofencingEvent.fromIntent(intent);

        if (!geoEvent.hasError()) {
            transitionType = geoEvent.getGeofenceTransition();

            if (transitionType == Geofence.GEOFENCE_TRANSITION_ENTER
                    || transitionType == Geofence.GEOFENCE_TRANSITION_DWELL
                    || transitionType == Geofence.GEOFENCE_TRANSITION_EXIT) {
                List<Geofence> triggerList = geoEvent.getTriggeringGeofences();
                Gson gson = new Gson();
                SharedPrefsHelper sharedPrefsHelper = AdaliveApplication.getInstance().getSharedPrefsHelper();
                List<GeofenceItem> regionResponse = Arrays.asList(gson.fromJson(sharedPrefsHelper.get("GEOFENCE", ""), GeofenceItem[].class));

                for (Geofence geofenceTrigger : triggerList) {
                    for (GeofenceItem regionStore: regionResponse) {
                        String tigger = geofenceTrigger.getRequestId();
                        String store = String.valueOf(regionStore.getId());
                        if(geofenceTrigger.getRequestId().equals(String.valueOf(regionStore.getId()))){

                            GPSTracker tracker = new GPSTracker(this);
                            String transitionName = "";

                            switch (transitionType) {
                                case Geofence.GEOFENCE_TRANSITION_DWELL:
                                    transitionName = "Parado";
                                    break;

                                case Geofence.GEOFENCE_TRANSITION_ENTER:
                                    GeofenceMessage message = new GeofenceMessage();
                                    message.setMessage("MOCK MENSAGEM ENTRADA");
                                    message.setActive(true);
                                    message.setAutomatic(true);
                                    message.setId(22);
                                    GeofenceNotification geofenceNotification = new GeofenceNotification(
                                            this);
                                    geofenceNotification
                                            .displayNotification(message, transitionType);

                                    //GeofenceWS.attemptCallRegionMessage(regionStore.getId(), 0, 0, AdaliveApplication.getInstance().getUser().getEmail(), tracker.getLatitude(), tracker.getLongitude(),this,this);
                                    transitionName = "Entrada";
                                    break;

                                case Geofence.GEOFENCE_TRANSITION_EXIT:
                                    GeofenceMessage message2 = new GeofenceMessage();
                                    message2.setMessage("MOCK MENSAGEM SAIDA");
                                    message2.setActive(true);
                                    message2.setAutomatic(true);
                                    message2.setId(22);
                                    GeofenceNotification geofenceNotification2 = new GeofenceNotification(
                                            this);
                                    geofenceNotification2
                                            .displayNotification(message2, transitionType);

                                    //GeofenceWS.attemptCallRegionMessage(regionStore.getId(), 1, 0, AdaliveApplication.getInstance().getUser().getEmail(), tracker.getLatitude(), tracker.getLongitude(),this,this);
                                    transitionName = "Saida";
                                    break;
                            }
                            String date = DateFormat.format("yyyy-MM-dd hh:mm:ss",
                                    new Date()).toString();
                    /*
                    EventDataSource eds = new EventDataSource(
                            getApplicationContext());
                    eds.create(transitionName, date, geofence.getRequestId());
                    eds.close();
        */
                        }

                    }
                }
            }
        }
    }

    public String getDeviceId() {
        final TelephonyManager tm = (TelephonyManager) getBaseContext().getSystemService(Context.TELEPHONY_SERVICE);

        final String tmDevice, tmSerial, androidId;
        tmDevice = "" + tm.getDeviceId();
        tmSerial = "" + tm.getSimSerialNumber();
        androidId = "" + android.provider.Settings.Secure.getString(getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

        UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
        return deviceUuid.toString();
    }

}
