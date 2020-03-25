package br.com.lab360.bioprime.utils.customdialog;

import android.content.Context;

import androidx.core.content.ContextCompat;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;

import br.com.lab360.bioprime.R;

/**
 * Created by Edson on 19/10/2018.
 */
public class ButtonBuilder {

    private Button button;
    private Context context;
    public static ButtonBuilder builder;

    public ButtonBuilder(Context context){
        this.context = context;
    }

    public ButtonBuilder newInstance(){
        button = new Button(context);
        return this;
    }

    public ButtonBuilder setTextButton(String titleButton){
        button.setText(titleButton);
        return this;
    }

    public ButtonBuilder setTextColor(int textColor){
        button.setTextColor(ContextCompat.getColor(context, R.color.white));
        return this;
    }

    public ButtonBuilder setColorButton(int background) {
        try {
            button.setBackground(ContextCompat.getDrawable(context, background));
        }catch (Exception e){
            button.setBackgroundColor(background);
        }
        LinearLayout.LayoutParams linearLayout = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        linearLayout.setMargins(1,20,1,1);
        button.setLayoutParams(linearLayout);

        return this;
    }

    public ButtonBuilder setListener(View.OnClickListener onClickListener){
        button.setOnClickListener(onClickListener);
        return this;
    }

    public static ButtonBuilder getBuilder() {
        return builder;
    }

    public Button getButton() {
        return button;
    }

    public ButtonBuilder create(CustomDialogBuilder builder){
        builder.addButton(button);
        return this;
    }
}
