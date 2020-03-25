package br.com.lab360.bioprime.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.List;

import br.com.lab360.bioprime.logic.model.pojo.gallery.GalleryObject;

/**
 * Created by Edson on 14/05/2018.
 */

public class GalleryUtils {

    public static String PATH_GALLERY = "/Lab360/Galeria";

    public static List<GalleryObject> readImagesGallery(){

        List<GalleryObject> imagesFolder = new ArrayList<>();
        File path = new File(Environment.getExternalStorageDirectory(),PATH_GALLERY);

        if(path.exists()) {

            String[] fileNames = path.list();
            for(int i = 0; i < fileNames.length; i++) {
                GalleryObject galleryObject = new GalleryObject();
                galleryObject.setImageBitmap(BitmapFactory.decodeFile(path.getPath()+"/"+ fileNames[i]));
                galleryObject.setImagePath(path.getPath()+"/"+ fileNames[i]);
                imagesFolder.add(galleryObject);
            }
        }

        return imagesFolder;
    }


    public static void removeImageGallery(GalleryObject galleryObject){
        File path = new File(Environment.getExternalStorageDirectory(),PATH_GALLERY);

        if(path.exists()) {

            String[] fileNames = path.list();
            for(int i = 0; i < fileNames.length; i++) {
                if(galleryObject.getImagePath().contains(path.getPath()+"/"+ fileNames[i])){
                    File file = new File(path.getPath()+"/"+ fileNames[i]);
                    file.delete();
                }
            }
        }
    }


    public static void saveImageGallery(Bitmap bitmap){

        String root = Environment.getExternalStorageDirectory().toString();
        File myDir = new File(root , PATH_GALLERY);
        myDir.mkdirs();

        String fname = "IMG-"+ String.valueOf(System.currentTimeMillis()) +".png";
        File file = new File (myDir, fname);

        try {
            FileOutputStream out = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);

            out.flush();
            out.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
