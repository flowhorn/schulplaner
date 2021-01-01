package com.xla.school

import android.content.Intent
import android.widget.RemoteViewsService
import android.content.Context;
import android.widget.RemoteViews;
import java.util.ArrayList
import android.appwidget.AppWidgetManager
import android.graphics.Color
import androidx.annotation.IdRes
import android.view.View
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import android.os.Bundle
import com.xla.school.logic.DataParser
import com.xla.school.models.*
import com.xla.school.views.RemoteViewObject


class ServiceWidgetTimetable : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsService.RemoteViewsFactory {
        println("ServiceWidgetTimetable STARTED");
        println(intent.getIntExtra("randomvalue", -5).toString())
        val appWidgetId = intent.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID)
        return WidgetDataProvider(this, intent)
    }
}



fun isColorDark(color:Int):Boolean{
    val darkness = 1 - (0.299 * Color.red(color) + 0.587 * Color.green(color) + 0.114 * Color.blue(color)) / 255
    return if (darkness < 0.4) {
        false // It's a light color
    } else {
        true // It's a dark color
    }
}

class WidgetDataProvider(private val context: Context, private val intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    var mywidgetsettings: Settings = Settings(multiple_weektypes = true,maxlesson = 4,appdesign = Design("", "","FFFFFF", accent = "000000", darkmode = false, autodark = false),timetable_useshortname = true,schedule_showlessontime = false, zero_lesson = false);
    var mList_cours:List<Course> = arrayListOf();
    var mList_lesson:List<Lesson> = arrayListOf();
    var mList_Schoolhour:List<Period> = arrayListOf();
    var maxlesson = 8;
    var days = 5;
    var weektype=0;

    var internal_list:List<String> = BuildEmptyList()

    init {
        println("WidgetDataProvider init");
        weektype = intent.getIntExtra("weektype",0)
    }



    override fun onCreate() {

    }

    fun createPrimitiveLessonList(input:List<Lesson>):MutableList<Lesson>{
        val newlist:MutableList<Lesson> = mutableListOf<Lesson>()
        input.forEach {
            if(it.isMultiLesson()){
                newlist.addAll(it.getSingleLessons())
            }else newlist.add(it)
        }
        return newlist
    }

    override fun onDataSetChanged() {
        println("TIMETABLEWIDGETSERVICE UPDATED!!")
        mList_cours = DataParser.getCourses(context)
        mList_lesson = createPrimitiveLessonList(DataParser.getLessons(context))

        mywidgetsettings = DataParser.getSettings(context)
        maxlesson = mywidgetsettings.maxlesson
        mList_Schoolhour =  DataParser.getPeriodList(context)


        internal_list = BuildEmptyList()
    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return internal_list.size;
    }

    override fun getViewAt(i: Int): RemoteViews {

            val remoteViews = RemoteViews(context.packageName, R.layout.widget_item_timetable)


            val textview_name = RemoteViewObject(R.id.text1, remoteViews)
            val textview_ab = RemoteViewObject(R.id.text_ab, remoteViews)
            val parent = RemoteViewObject(R.id.parent, remoteViews)
            remoteViews.setTextViewTextSize(R.id.text1, 1, 14.0f)
            //remoteViews.setOnClickFillInIntent(R.id.parent, null)


        if(internal_list.size <= i){
            textview_name.setText("Error")

            return remoteViews;
        }
        if(internal_list.get(i).startsWith("SCHOOLHOUR")){
            val count = internal_list.get(i).split("-")[1].toInt()
            textview_ab.setText("")
            parent.setDefaultBackground(mywidgetsettings.appdesign);
            remoteViews.setTextColor(R.id.text1, Color.GRAY)
            remoteViews.setTextViewTextSize(R.id.text1, 1, 12.0f)
            if(mywidgetsettings.schedule_showlessontime) {
                val schoolhour: Period? =  mList_Schoolhour.find { it.id == count }
                textview_name.setText(schoolhour?.start+" - "+schoolhour?.end )
            }else    textview_name.setText( count.toString()+".")


            return remoteViews;
        }else{
            val lesson = findLesson(internal_list.get(i))
            if(lesson.id== "EMPTY"){
                textview_name.setText("")
                textview_ab.setText("")
                parent.setDefaultBackground(mywidgetsettings.appdesign);
            }else{
                val cours = mList_cours.find { it.id == lesson.courseid }?: Course("", "", Design("","","","", darkmode = false, autodark = false),"")
                parent.setBackgroundColor(cours.getDesignVal())
                if(mywidgetsettings.timetable_useshortname){
                    textview_name.setText(cours.getShortnameOrName())
                }else{
                    textview_name.setText(cours.name)
                }
                if(lesson.weektype == 0)textview_ab.setText("")
                else{
                    if(lesson.weektype == 1)textview_ab.setText("A")
                    else if(lesson.weektype == 2)textview_ab.setText("B")
                }

                if(isColorDark(cours.getDesignVal())){
                    remoteViews.setTextColor(R.id.text1, Color.WHITE)
                    remoteViews.setTextColor(R.id.text_ab, Color.WHITE)
                }else{
                    remoteViews.setTextColor(R.id.text1, Color.BLACK)
                    remoteViews.setTextColor(R.id.text_ab, Color.BLACK)
                }

                val extras = Bundle()
                extras.putString("data_lesson_id",lesson.id);
                val fillInIntent = Intent()
                fillInIntent.putExtras(extras)
                remoteViews.setOnClickFillInIntent(R.id.parent, fillInIntent)
        }




                // val intent_click =  Intent(context, WidgetTaskActivity::class.java)
                // intent_click.setAction("lesson_clicked")
                // intent.putExtra("lesson", Gson().toJson(lesson))
                //  intent.putExtra("cours", Gson().toJson(cours))
                // intent.putExtra("settings", Gson().toJson(mywidgetsettings))

            return remoteViews;
        }



    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int =1

    override fun getItemId(i: Int): Long {
        return i.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }


    fun findLesson(key:String):Lesson{
        val weektype = Lesson.getWeektypeByKey(key)
        val day = Lesson.getDayByKey(key)
        val start = Lesson.getStartByKey(key)
        if(weektype == 0){
            val mLesson:Lesson =  mList_lesson.find { if(it.day == day && it.start == start)true else false }?: Lesson("EMPTY",courseid = "NULL",day = 0,start = 0,weektype = 0,end = 0)
            return mLesson
        }else{
            val mLesson:Lesson =  mList_lesson.find { if(it.weektype == weektype && it.day == day && it.start == start)true else false }?: mList_lesson.find { if(it.weektype == 0 && it.day == day && it.start == start)true else false }?: Lesson("EMPTY",courseid = "NULL",day = 0,start = 0,weektype = 0,end = 0)
            return mLesson
        }

    }

    fun BuildEmptyList():List<String>{
        val list: ArrayList<String> = arrayListOf()
        for(lessonnumber:Int in ( if(mywidgetsettings.zero_lesson) 0 else 1 )..maxlesson){
            list.add("SCHOOLHOUR-"+lessonnumber.toString())
            days.forEach {
                list.add(Lesson.getScheduleKey(weektype, it, lessonnumber))
            }
        }


        return list
    }



}


fun Int.forEach(every: (Int) -> Unit){
    for (i in 1..this) every(i)
}


