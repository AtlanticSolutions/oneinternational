package br.com.lab360.oneinternacional.utils;

import androidx.annotation.IntDef;
import android.text.TextUtils;
import android.widget.EditText;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * Created by virginia on 10/11/2017.
 */

public class FieldsValidator {



    /**
     * Checks if a email field is a email address valid. This is not check if a email address exist just if it is well formed.
     * @param string the filed that represent the email address
     * @return it a email address is well formed.
     */
    public  static boolean isValidEmail(String string){
        final String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
        Pattern pattern = Pattern.compile(EMAIL_PATTERN);
        Matcher matcher = pattern.matcher(string);
        return matcher.matches();
    }

    /**
     * Checks if a string is empty or not
     * @param string represents the field content to check
     * @return the result of the check
     */
    public static boolean isNullOrEmpty(String string){
        return TextUtils.isEmpty(string);
    }


    /**
     * Checks if a field content that was inputed is a number
     * @param string this string must have only digits to be a number
     * @return the result of the check
     */
    public static boolean isNumeric(String string){
        return TextUtils.isDigitsOnly(string);
    }

    /**
     * This method validates if a content in edittext is empty or not
     * @param fieldsToValidate a map with all edittext to check
     * @return a map with the editext that are empty
     */
    public static Map<Integer,EditText> validateEditTextContent(Map<Integer,EditText> fieldsToValidate) {
        Map<Integer,EditText> wrongFieldsEdt = new HashMap<>();

        for(int key :fieldsToValidate.keySet()){
            if(isNullOrEmpty(fieldsToValidate.get(key).getText().toString())){
                wrongFieldsEdt.put(key,fieldsToValidate.get(key));
            }
        }


        return wrongFieldsEdt;
    }


    /**
     * This method validates if a string tha represent a field is empty or not
     * @param fieldsToValidate a map with all content fields to check
     * @return a list with the key fields that are empty
     */
    public static List<Integer> validateContent(Map<Integer,String> fieldsToValidate) {
        List<Integer> wrongFields = new ArrayList<Integer>();

        for(int key :fieldsToValidate.keySet()){
            if(fieldsToValidate.get(key).isEmpty()){
                wrongFields.add(key);
            }
        }


        return wrongFields.size() > 0 ? wrongFields : null;
    }

    @Retention(RetentionPolicy.SOURCE)
    @IntDef({FieldType.CPF,FieldType.RG,FieldType.NAME , FieldType.BORN,FieldType.GENDER,FieldType.DDD_TEL,
            FieldType.TELEPHONE, FieldType.DDD_CELL,FieldType.CELULAR,FieldType.ADDRESS, FieldType.NUMBER, FieldType.ZONE,FieldType.MORE_ADDRESS, FieldType.DISTRICT, FieldType.CITY, FieldType.STATE, FieldType.EMAIL})
    public @interface FieldType{

        int CPF = 0;
        int RG = 1;
        int NAME = 2;
        int BORN = 3;
        int GENDER = 4;
        int DDD_TEL = 5;
        int TELEPHONE = 6;
        int DDD_CELL = 7;
        int CELULAR = 8;
        int ZONE = 9;
        int ADDRESS = 10;
        int NUMBER = 11;
        int MORE_ADDRESS = 12;
        int DISTRICT = 13;
        int CITY = 14;
        int STATE = 15;
        int EMAIL = 16;

    }
}
