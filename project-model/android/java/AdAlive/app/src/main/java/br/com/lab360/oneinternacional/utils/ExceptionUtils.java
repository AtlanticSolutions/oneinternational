package br.com.lab360.oneinternacional.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.ResponseBody;

public class ExceptionUtils {

    public static final String EXCEPTION_REGISTERED_EMAIL = "email";

    public static String getErrorMessage(ResponseBody responseBody) {
        String stringMessage = "";
        try {
            JSONObject jsonObject = new JSONObject(responseBody.string());
            if (jsonObject.get("message") instanceof JSONObject) {
                JSONObject jsonMessage = new JSONObject(jsonObject.getString("message"));

                JSONArray jsonArray = null;
                JSONArray arrayMessage = null;

                if (jsonMessage.has(EXCEPTION_REGISTERED_EMAIL)) {
                    jsonArray = jsonMessage.getJSONArray(EXCEPTION_REGISTERED_EMAIL);

                    int length = jsonArray.length();
                    if (length > 0) {
                        String[] messages = new String[length];
                        for (int i = 0; i < length; i++) {
                            messages[i] = jsonArray.getString(i);

                        }
                        stringMessage = messages[0];
                    }
                }

            } else if (jsonObject.get("message") instanceof String) {
                stringMessage = jsonObject.getString("message");
                return stringMessage;
            }
        } catch (JSONException | IOException e) {
            e.printStackTrace();
        }

        return stringMessage;

    }
}