package br.com.lab360.bioprime.logic.model.pojo;

import androidx.annotation.IntDef;
import android.text.TextUtils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;

/**
 * Created by thiagofaria on 17/01/17.
 */

public class CodeRequest {

    private String code;

    public CodeRequest(String code) {
        this.code = code;
    }

    public ArrayList<Integer> validate() {
        ArrayList<Integer> wrongFields = new ArrayList<>();

        if(TextUtils.isEmpty(code)){
            wrongFields.add(FieldType.CODE);
        }

        return wrongFields.size() > 0 ? wrongFields : null;
    }

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({FieldType.CODE})
    public @interface FieldType{
        int CODE = 3;
    }

}
