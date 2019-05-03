package br.com.lab360.oneinternacional.ui.decorator;

import android.graphics.drawable.Drawable;

import com.prolificinteractive.materialcalendarview.CalendarDay;
import com.prolificinteractive.materialcalendarview.DayViewDecorator;
import com.prolificinteractive.materialcalendarview.DayViewFacade;
import com.prolificinteractive.materialcalendarview.MaterialCalendarView;

import java.util.Date;

/**
 * Decorate a day by making the text big and bold
 */
public class CalendarDayDecorator implements DayViewDecorator {

    private CalendarDay date;
    private Drawable colorDrawable;

    public CalendarDayDecorator(CalendarDay date, Drawable colorDrawable) {
        this.date = date;
        this.colorDrawable = colorDrawable;
    }

    @Override
    public boolean shouldDecorate(CalendarDay day) {
        return date != null && day.equals(date);
    }

    @Override
    public void decorate(DayViewFacade view) {
//        view.addSpan(new StyleSpan(Typeface.BOLD));
//        view.addSpan(new DotSpan(45, R.color.yellowButton));
//        view.addSpan(new RelativeSizeSpan(1.4f));
        view.setBackgroundDrawable(colorDrawable);
    }

    /**
     * We're changing the internals, so make sure to call {@linkplain MaterialCalendarView#invalidateDecorators()}
     */
    public void setDate(Date date) {
        this.date = CalendarDay.from(date);
    }
}
