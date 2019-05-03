package br.com.lab360.oneinternacional.utils.customdialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import androidx.annotation.NonNull;

import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions;
import com.bumptech.glide.request.RequestOptions;
import com.google.common.base.Strings;

import java.util.List;

import br.com.lab360.oneinternacional.R;
import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by Edson on 19/10/2018.
 */
public class CustomDialog extends Dialog{
    @BindView(R.id.tvTitle)
    protected TextView tvTitle;
    @BindView(R.id.tvMessage)
    protected TextView tvMessage;
    @BindView(R.id.ivIcon)
    protected ImageView ivIcon;
    @BindView(R.id.llIcon)
    protected LinearLayout llIcon;
    @BindView(R.id.ivPhoto)
    protected ImageView ivPhoto;
    @BindView(R.id.buttonContainer)
    protected LinearLayout buttonContainer;

    private CustomDialogBuilder builder;
    private Context context;

    public CustomDialog(@NonNull Context context) {
        super(context);
        this.context = context;
    }

    public CustomDialogBuilder builder(Context context){
        builder = new CustomDialogBuilder(context);
        return builder;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.custom_dialog);
        setCancelable(false);
        ButterKnife.bind(this);

        configTitle(builder.getTitle());
        configMessage(builder.getMessage());
        configImage(builder.getImage(), context);
        configButtons(builder.getButtons());
        configType(builder.getType());
    }

    public void configTitle(String title){
        if (!Strings.isNullOrEmpty(title)) {
            tvTitle.setText(title);
            tvTitle.setTypeface(Typeface.DEFAULT_BOLD);
            tvTitle.setVisibility(View.VISIBLE);
        }
    }

    public void configMessage(String message){
        if (!Strings.isNullOrEmpty(message)) {
            tvMessage.setText(message);
            tvMessage.setVisibility(View.VISIBLE);
        }
    }

    public void configImage(int image, Context context){
        DrawableTransitionOptions transitionOptions = new DrawableTransitionOptions();
        transitionOptions.crossFade();

        if (image != 0) {
            Glide.with(context)
                    .load(image)
                    .transition(transitionOptions)
                    .into(ivPhoto);
            ivPhoto.setVisibility(View.VISIBLE);
        }
    }

    public void configButtons(List<Button> buttons){
        if (buttons != null && buttons.size() != 0) {
            for (Button button : buttons){
                buttonContainer.addView(button);
            }
        }
    }

    public void configType(CustomDialogBuilder.DIALOG_TYPE  type){
        GradientDrawable drawable = (GradientDrawable) llIcon.getBackground();
        int px = 15;
        DisplayMetrics displayMetrics = getContext().getResources().getDisplayMetrics();
        int roundedBackgroundSize = Math.round(px / (displayMetrics.xdpi / DisplayMetrics.DENSITY_DEFAULT));

        switch (type) {
            case SUCCESS:
                ivIcon.setImageResource(R.drawable.ic_dialog_success);
                drawable.setStroke(roundedBackgroundSize, context.getResources().getColor(R.color.white));
                drawable.setColor(context.getResources().getColor(R.color.green));
                break;
            case QUESTION:
                ivIcon.setImageResource(R.drawable.ic_dialog_question);
                drawable.setStroke(roundedBackgroundSize, context.getResources().getColor(R.color.white));
                drawable.setColor(context.getResources().getColor(R.color.blue_background_dark));
                break;
            case ERROR:
                ivIcon.setImageResource(R.drawable.ic_dialog_error);
                drawable.setStroke(roundedBackgroundSize, context.getResources().getColor(R.color.white));
                drawable.setColor(context.getResources().getColor(R.color.red));
                break;
            case ATENTION:
                ivIcon.setImageResource(R.drawable.ic_dialog_atention);
                drawable.setStroke(roundedBackgroundSize, context.getResources().getColor(R.color.white));
                drawable.setColor(context.getResources().getColor(R.color.yellowButton));
                break;
            case INFORMATION:
                ivIcon.setImageResource(R.drawable.ic_dialog_information);
                drawable.setStroke(roundedBackgroundSize, context.getResources().getColor(R.color.white));
                drawable.setColor(context.getResources().getColor(R.color.blue_background_dark));
                break;
            default:
                break;
        }
    }
}
