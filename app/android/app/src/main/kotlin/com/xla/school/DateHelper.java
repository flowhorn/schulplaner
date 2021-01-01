package com.xla.school;

import android.content.Context;

import com.xla.school.R;

import java.text.SimpleDateFormat;
import java.util.Calendar;


public class DateHelper {

    public static String getYesterday()
    {
        Calendar c = DateString.getToday();
        c.add(Calendar.DAY_OF_YEAR, -1);
        return DateString.buildDatestring(c);
    }
    public static String getTomorrow()
    {
        Calendar c = DateString.getToday();
        c.add(Calendar.DAY_OF_YEAR, +1);
        return DateString.buildDatestring(c);
    }

    public static String getThreeDays()
    {
        Calendar c = DateString.getToday();
        c.add(Calendar.DAY_OF_YEAR, +3);
        return DateString.buildDatestring(c);
    }
    public static String getToday()
    {
        return DateString.buildDatestring(DateString.getToday());
    }


    public static boolean insideDateRange(String range, String datestring)
    {
        String start = range.split(":")[0];
        String end = range.split(":")[0];
        Calendar startc = DateString.buildCalendar(start);
        Calendar endc = DateString.buildCalendar(end);
        while (!DateString.areSameDay(startc, endc))
        {
            if(DateString.areSameDay(startc, datestring))return true;
            startc.add(Calendar.DAY_OF_YEAR, +1);
        }

        return false;
    }
    public static String getStringtoDayDate(Context context, String datestring)
    {

        if(DateString.areSameDay(getToday(), datestring))
        {
            return context.getString(R.string.today) + " ("+ stringashumandate(datestring) +") ";
        }else if(DateString.areSameDay(getTomorrow(), datestring))
        {
            return context.getString(R.string.tomorrow) + " ("+ stringashumandate(datestring) +") ";
        }else if(DateString.areSameDay(getYesterday(), datestring))
        {
            return context.getString(R.string.yesterday) + " ("+ stringashumandate(datestring) +") ";
        }else{
            return stringashumandate(datestring);
        }

    }

    public static String stringashumandate(String s)
    {
        try{
            SimpleDateFormat fmt;
            if(DateString.buildCalendar(s).get(Calendar.YEAR) == DateString.getToday().get(Calendar.YEAR))
                fmt = new SimpleDateFormat("EEEE, dd.MMMM");
            else  fmt = new SimpleDateFormat("EEEE, dd.MMMM YYYY");
            return fmt.format(DateString.buildCalendar(s).getTime());
        }catch (Exception e){
            return s;
        }

    }
    public static String getWeekDayName(int day, Context context){
      switch (day){
          case 1:return context.getString(R.string.monday);
          case 2:return context.getString(R.string.tuesday);
          case 3:return context.getString(R.string.wednesday);
          case 4:return context.getString(R.string.thursday);
          case 5:return context.getString(R.string.friday);
          case 6:return context.getString(R.string.saturday);
          case 7:return context.getString(R.string.sunday);
      }
        return "";
    }
}
