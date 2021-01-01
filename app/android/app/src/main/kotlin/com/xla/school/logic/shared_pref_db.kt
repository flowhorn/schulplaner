package com.xla.school.logic

import android.content.Context
import android.content.SharedPreferences
import androidx.preference.PreferenceManager

private fun getSharedPreferenceInstance(context: Context): SharedPreferences{
    return context.getSharedPreferences("com.xla.school.data", Context.MODE_PRIVATE)
}

object SharedPrefDatabase{

    val mydailynotificationssettings = SharedPrefString("dailynotifications_settings")
    val all_lesson = SharedPrefString("widget_all_lesson")
    val all_cours = SharedPrefString("widget_all_cours")
    val all_periods = SharedPrefString("widget_all_periods")
    val mywidgettimetablesettings = SharedPrefString("widget_mytimetablesettings")

    val alltasks = SharedPrefString( "widget_tasks");
    val memberid = SharedPrefString("widget_memberid")
    val alltasksrefreshed = SharedPrefLong( "widget_tasksrefreshed", -1)
    val currentweektype = SharedPrefInt("widget_timetable_currentweektype", 0)
}


class SharedPrefInt(private val key:String, private val standard:Int){
    fun setValue(context: Context, value:Int){
        getSharedPreferenceInstance(context).edit().putInt(key,value).apply()
    }

    fun getValue(context: Context):Int{
        return getSharedPreferenceInstance(context)
                .getInt(key, standard)
    }
}


class SharedPrefLong(private val key:String, private val standard:Long){
    fun setValue(context: Context, value:Long){
        getSharedPreferenceInstance(context).edit().putLong(key,value).apply()
    }

    fun getValue(context: Context):Long{
        return getSharedPreferenceInstance(context)
                .getLong(key, standard)
    }
}
class SharedPrefString(private val key:String){
    fun setValue(context: Context, value:String){
        getSharedPreferenceInstance(context).edit().putString(key,value).apply()
    }

    fun getValue(context: Context):String?{
        return getSharedPreferenceInstance(context)
                .getString(key, null)
    }
}