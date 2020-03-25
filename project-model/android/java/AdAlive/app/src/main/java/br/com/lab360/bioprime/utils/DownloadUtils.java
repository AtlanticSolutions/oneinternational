package br.com.lab360.bioprime.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Environment;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import br.com.lab360.bioprime.application.AdaliveConstants;
import br.com.lab360.bioprime.logic.model.pojo.download.DownloadInfoObject;

/**
 * Created by Alessandro Valenza on 01/12/2016.
 */

public class DownloadUtils {
    public static ArrayList<DownloadInfoObject> getSharedPrefsMyDownloadList(Context context) {
        SharedPreferences prefs = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE);
        String myDownloadsListJson = prefs.getString(AdaliveConstants.PREFS_TAG_MYDOWNLOADS, "");

        Gson gson = new Gson();
        Type type = new TypeToken<ArrayList<DownloadInfoObject>>() {
        }.getType();

        ArrayList<DownloadInfoObject> myDownloads = new ArrayList<>();
        if (!TextUtils.isEmpty(myDownloadsListJson)) {
            myDownloads = gson.fromJson(myDownloadsListJson, type);
        }
        return myDownloads;
    }

    public static void setSharedPrefsMyDownloadList(Context context, ArrayList<DownloadInfoObject> myDownloads) {
        Gson gson = new Gson();
        String myDownloadsListJson = gson.toJson(myDownloads);
        SharedPreferences.Editor editor = context.getSharedPreferences(AdaliveConstants.SHARED_PREFS, Context.MODE_PRIVATE).edit();
        editor.putString(AdaliveConstants.PREFS_TAG_MYDOWNLOADS, myDownloadsListJson).apply();
    }

    /**
     * Add current downloading file to shared prefs list
     * but currently not visible in My Downloads List
     *
     * @param item - file currently in download
     * @return - item list index
     */
    public static int addFileToMyDownloadList(Context context, DownloadInfoObject item) {
        ArrayList<DownloadInfoObject> myDownloads = getSharedPrefsMyDownloadList(context);
        myDownloads.add(item);
        setSharedPrefsMyDownloadList(context, myDownloads);
        return myDownloads.indexOf(item);
    }

    /**
     * Remove file from shared preferences my downloads list
     *
     * @param item - item to remove
     */
    public static void removeFileFromMyDownloadList(Context context, DownloadInfoObject item) {
        ArrayList<DownloadInfoObject> myDownloads = getSharedPrefsMyDownloadList(context);
        for (int i = 0; i < myDownloads.size(); i++) {
            if (myDownloads.get(i).getId() == item.getId()) {
                myDownloads.remove(i);
                break;
            }
        }
        setSharedPrefsMyDownloadList(context, myDownloads);
    }

    /**
     * Check if file already downloaded and is visible in AHK download folder
     *
     * @param item
     */
    public static boolean isFileInDownloadFolder(DownloadInfoObject item) {
        File parentDir = new File(Environment.getExternalStorageDirectory() + "/" + Environment.DIRECTORY_DOWNLOADS + "/AHK");
        ArrayList<File> ahkFiles = getListFiles(parentDir);
        for (File file : ahkFiles) {
            if (file.getName().equals(item.getTitle() + "." + item.getFileExtension())) {
                return true;
            }
        }
        return false;
    }

    /**
     * Get all files inside given folder
     *
     * @param parentDir - parent directory
     * @return
     */
    private static ArrayList<File> getListFiles(File parentDir) {
        ArrayList<File> inFiles = new ArrayList<File>();
        File[] files = parentDir.listFiles();
        if (files == null || files.length == 0) {
            return inFiles;
        }

        for (File file : files) {
            if (file.isDirectory()) {
                inFiles.addAll(getListFiles(file));
            } else {
                inFiles.add(file);
            }
        }
        return inFiles;
    }

    /**
     * Enable file which already is inside sharedprefs my download list to be visible in My Downloads Activity List
     *
     * @param item - item to be enabled
     */
    public static void enableFileInMyDownloadList(Context context, DownloadInfoObject item) {
        ArrayList<DownloadInfoObject> myDownloads = getSharedPrefsMyDownloadList(context);
        int index = -1;
        for (int i = 0; i < myDownloads.size(); i++) {
            if (myDownloads.get(i).getId() == item.getId()) {
                index = i;
            }
        }
        item.setVisible(true);
        myDownloads.set(index, item);
        setSharedPrefsMyDownloadList(context, myDownloads);
    }

    /**
     * Enable file which already is inside sharedprefs my download list to be visible in My Downloads Activity List
     *
     * @param index - item list index
     */
    public static void enableFileInMyDownloadList(Context context, int index) {
        ArrayList<DownloadInfoObject> myDownloads = getSharedPrefsMyDownloadList(context);
        DownloadInfoObject item = myDownloads.get(index);
        item.setVisible(true);
        myDownloads.set(index, item);
        setSharedPrefsMyDownloadList(context, myDownloads);
    }

    /**
     * Remove file from device
     *
     * @param objectDeleted
     */
    public static boolean removeFileFromDevice(DownloadInfoObject objectDeleted) {
        StringBuilder filePath = new StringBuilder(Environment.getExternalStorageDirectory() + "/" + Environment.DIRECTORY_DOWNLOADS + "/AHK");
        filePath.append("/").append(objectDeleted.getTitle()).append(".").append(objectDeleted.getFileExtension());
        File file = new File(filePath.toString());
        if (file.exists()) {
            file.delete();
            return true;
        }
        return false;
    }

    /**
     * Check if a file already downloaded
     *
     * @param context
     * @param object
     * @return
     */
    public static boolean alreadyDownloadedFile(Context context, DownloadInfoObject object) {
        ArrayList<DownloadInfoObject> files = getSharedPrefsMyDownloadList(context);
        for (int i = 0; i < files.size(); i++) {
            if (files.get(i).getId() == object.getId()) {
                return true;
            }
        }
        return false;
    }


    public static void downloadFile(String fileUrl, File directory){
        try {

            URL url = new URL(fileUrl);
            HttpURLConnection urlConnection = (HttpURLConnection)url.openConnection();
            urlConnection.connect();

            InputStream inputStream = urlConnection.getInputStream();
            FileOutputStream fileOutputStream = new FileOutputStream(directory);

            byte[] buffer = new byte[1024 * 1024];
            int bufferLength = 0;
            while((bufferLength = inputStream.read(buffer))>0 ){
                fileOutputStream.write(buffer, 0, bufferLength);
            }
            fileOutputStream.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
