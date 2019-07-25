package br.com.lab360.oneinternacional.utils;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import androidx.fragment.app.DialogFragment;
import android.widget.DatePicker;
import android.widget.EditText;
import java.util.Calendar;
import br.com.lab360.oneinternacional.R;

/**
 * Created by David Canon on 10/01/2018.
 *
 */

public class DatePickerUtil extends DialogFragment implements DatePickerDialog.OnDateSetListener {
    private EditText mEditText;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        final Calendar c = Calendar.getInstance();

        DatePickerDialog picker = new DatePickerDialog(getActivity(), R.style.DialogTheme, this,
                c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DAY_OF_MONTH));
        picker.getDatePicker().setMaxDate(c.getTimeInMillis());
        return picker;
    }

    @Override
    public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
        /*if (month == 0)
            month = 1;*/

        month++;

        String monthBorn = String.valueOf(month).length() == 1 ? "0" + month : String.valueOf(month);
        String dayBorn = String.valueOf(dayOfMonth).length() == 1 ? "0" + dayOfMonth : String.valueOf(dayOfMonth);
        mEditText.setText(dayBorn + '/' + monthBorn + '/' + year);
    }

    public void setEditText(EditText editText) {
        mEditText = editText;
    }
}