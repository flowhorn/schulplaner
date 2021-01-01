package com.xla.school;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

/**
 * Created by felix on 14.05.2017.
 */

public class DateString {

    public static Calendar getNow(){
        return Calendar.getInstance();
    }
    public static Calendar getToday(){
        Calendar c = Calendar.getInstance();
        c.set(Calendar.MINUTE, 0);
        c.set(Calendar.SECOND, 0);
        c.set(Calendar.HOUR_OF_DAY, 0);
        c.set(Calendar.MILLISECOND, 0);
        return c;
    }

    public static final String buildDatestring(Calendar calendar){
        return new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).format(calendar.getTime());
    }
    private static final String buildSimpleString(Calendar calendar){
        return new SimpleDateFormat("yyyy_MM_dd", Locale.ENGLISH).format(calendar.getTime());
    }

    public static Calendar buildCalendar(String datestring){
        String[]parts = datestring.split("-");
        if(parts.length !=3) return Calendar.getInstance();
        int year =  Integer.valueOf(parts[0]);
        int month =  Integer.valueOf(parts[1]) -1;
        int day =   Integer.valueOf(parts[2]);
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);
        return calendar;
    }

    public static final int getWeekNumber(){
        return Calendar.getInstance().get(Calendar.WEEK_OF_YEAR);
    }
    public static final int getWeekNumber(String datestring){
        return DateString.buildCalendar(datestring).get(Calendar.WEEK_OF_YEAR);
    }

    public static boolean areSameDay(Calendar c1, Calendar c2)
    {
        return buildSimpleString(c1).equals(buildSimpleString(c2));
    }
    public static boolean areSameDay(Calendar c1, String s1)
    {
        return buildSimpleString(c1).equals(buildSimpleString(buildCalendar(s1)));
    }
    public static boolean areSameDay(String s1, String s2)
    {
        return buildSimpleString(buildCalendar(s1)).equals(buildSimpleString(buildCalendar(s2)));
    }

    public static boolean isinRange(String dateString, String start, String end){
        if(dateString== null)return false;
        if(start == null || end == null)return true;
        Calendar date = buildCalendar(dateString);
        if(date.before(buildCalendar(start)))return false;
        if(date.after(buildCalendar(end)))return false;
        return true;
    }

    public static Integer getDayofWeek(Calendar calendar){
        int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
       if(dayOfWeek == 1)return 7;
       else return dayOfWeek-1;

    }
}
