package br.com.lab360.oneinternacional.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

/**
 * Created by Alessandro Valenza on 25/11/2016.
 */

public class DateUtils {

    public static String formatAdAliveDate(String unFormattedTime, String format) {
        String formattedTime;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault());
            Date date = sdf.parse(unFormattedTime);

            sdf = new SimpleDateFormat(format, Locale.getDefault());
            formattedTime = sdf.format(date);

            return formattedTime;

        } catch (ParseException e) {
            e.printStackTrace();
        }

        return "";
    }

    /**
     * Convert string event date to calendar. Used in the event calendar.
     *
     * @param stringDate event date.
     * @return calendar converted.
     */
    public static Calendar dateEventToCalendar(String stringDate) {
        Calendar cal = Calendar.getInstance();
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault());
            Date date = sdf.parse(stringDate);
            cal.setTime(date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return cal;
    }

    /**
     * Format the seconds value to 'mm:ss'.
     * @param time time in seconds.
     * @return formatted in 'mm:ss'.
     */
    public static String secondsToMinuteAndSeconds(int time) {
        return String.format(Locale.getDefault(), "%02d:%02d", time / 60, time% 60);
    }


    public static Date stringToDate(String dataString, String formatDate){

        //String dtStart = "2010-10-15T09:27:37Z";
        SimpleDateFormat format = new SimpleDateFormat(formatDate);

        Date date = null;

        try {

            date = format.parse(dataString);

        } catch (ParseException e) {

            e.printStackTrace();
        }

        return date;
    }

    public static String dateToString(Date date, String format){

        SimpleDateFormat dateFormat = new SimpleDateFormat(format);

        String dateTime = "";

        try {

            dateTime = dateFormat.format(date);

        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        return dateTime;
    }
}
