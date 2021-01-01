package com.xla.school


import android.content.Intent
import android.widget.RemoteViewsService
import android.content.Context;
import android.widget.RemoteViews;
import android.appwidget.AppWidgetManager
import com.xla.school.logic.DataParser
import com.xla.school.models.Course
import com.xla.school.models.Design
import com.xla.school.models.SchoolTask
import com.xla.school.models.Settings
import com.xla.school.views.RemoteViewObject
import java.text.SimpleDateFormat


class ServiceWidgetTasks : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsService.RemoteViewsFactory {
        println("ServiceWidgetTasks STARTED");
        println(intent.getIntExtra("randomvalue", -5).toString())

        val appWidgetId = intent.getIntExtra(
                AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID)
        return SchoolTaskListProvider(this, intent)
    }
}




class SchoolTaskListProvider(private val context: Context, private val intent: Intent) : RemoteViewsService.RemoteViewsFactory {

    var mywidgetsettings: Settings = Settings(multiple_weektypes = true,maxlesson = 4,
            appdesign = Design("", "","FFFFFF", accent = "000000", darkmode = false, autodark = false),
            timetable_useshortname = true,schedule_showlessontime = false, zero_lesson = false);
    var mList_cours:List<Course> = arrayListOf();


    var tasklist:List<SchoolTask> = arrayListOf();

    init {
    }



    override fun onCreate() {

    }


    override fun onDataSetChanged() {
        println("TASK WIDGET UPDATED!!")
        mList_cours = DataParser.getCourses(context)
        tasklist = DataParser.getTasks(context)
        tasklist = tasklist.sortedBy { it.due }
        println(tasklist.size);
        mywidgetsettings = DataParser.getSettings(context)

    }

    override fun onDestroy() {}

    override fun getCount(): Int {
        return tasklist.size;
    }

    override fun getViewAt(i: Int): RemoteViews {
            val remoteViews = RemoteViews(context.packageName, R.layout.widget_item_tasks)

            val textview_title = RemoteViewObject(R.id.text1, remoteViews)
            val textview_subtitle = RemoteViewObject(R.id.text2, remoteViews)
            val textview_3 = RemoteViewObject(R.id.text3, remoteViews)
            val parent = RemoteViewObject(R.id.parent, remoteViews)
            val image = RemoteViewObject(R.id.image1, remoteViews)
            remoteViews.setTextViewTextSize(R.id.text1, 1, 14.0f)


            val item = tasklist.get(i);
            val course:Course? = mList_cours.find { it->it.id==item.courseid };
            textview_title.setText(item.title)
            textview_subtitle.setText(course?.name?:"Privat")
            try{
                val date = SimpleDateFormat("yyyy-MM-dd").parse(item.due);
                val textdate = SimpleDateFormat("EEE, d MMM")
                textview_3.setText(context.getString(R.string.due)+": "+ textdate.format(date));
            }catch (e:Throwable){
                textview_3.setText(context.getString(R.string.due)+": "+ item.due);
            }

            parent.setDefaultBackground(mywidgetsettings.appdesign)
            textview_title.setDefaultTextColor(mywidgetsettings.appdesign);
        textview_subtitle.setDefaultTextColor(mywidgetsettings.appdesign);
        textview_3.setDefaultTextColor(mywidgetsettings.appdesign);
            if(item.finished){
               image.setVisibility(true)
            }else{
                image.setVisibility(false)
            }
            return remoteViews;



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



}


