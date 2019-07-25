package br.com.lab360.oneinternacional.logic.model.pojo.gallery;

import android.graphics.Bitmap;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Edson on 20/05/2018.
 */

public class GalleryObject {

    @SerializedName("image_path")
    String imagePath;
    @SerializedName("image_bitmap")
    Bitmap imageBitmap;

    public GalleryObject(){

    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public Bitmap getImageBitmap() {
        return imageBitmap;
    }

    public void setImageBitmap(Bitmap imageBitmap) {
        this.imageBitmap = imageBitmap;
    }
}
