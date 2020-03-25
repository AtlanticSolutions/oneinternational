package br.com.lab360.bioprime.utils.customdialog;

import android.content.Context;
import android.widget.Button;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Edson on 19/10/2018.
 */
public class CustomDialogBuilder {
    private Context context;
    private DIALOG_TYPE type;
    private String title;
    private String message;
    private int image;
    private List<Button> buttons;

    public enum DIALOG_TYPE {
        SUCCESS,
        QUESTION,
        ERROR,
        BUY,
        ATENTION,
        INFORMATION
    }

    public CustomDialogBuilder(Context context) {
        this.context = context;
        this.buttons = new ArrayList<>();
    }

    public String getTitle(){
        return title;
    }

    public String getMessage(){
        return message;
    }

    public int getImage(){
        return image;
    }

    public DIALOG_TYPE getType() {
        return type;
    }

    public List<Button> getButtons() {
        return buttons;
    }


    public CustomDialogBuilder setTitle(String title){
        this.title = title;
        return this;
    }

    public CustomDialogBuilder setMessage(String message){
        this.message = message;
        return this;
    }

    public CustomDialogBuilder setImage(int image){
        this.image = image;
        return this;
    }

    public CustomDialogBuilder setType(DIALOG_TYPE type){
        this.type = type;
        return this;
    }

    public CustomDialogBuilder setButtons(List<Button> buttons){
        this.buttons = buttons;
        return this;
    }

    public CustomDialogBuilder addButton(Button button){
        this.buttons.add(button);
        return this;
    }

}
