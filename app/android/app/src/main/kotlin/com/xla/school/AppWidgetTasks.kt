package com.xla.school

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.content.Intent
import android.net.Uri
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import android.app.PendingIntent
import android.content.ComponentName
import android.graphics.Color
import androidx.core.app.JobIntentService.enqueueWork
import com.xla.school.logic.DataParser
import com.xla.school.logic.SharedPrefDatabase
import com.xla.school.models.SchoolTask
import com.xla.school.models.Settings
import com.xla.school.views.RemoteViewObject
import java.text.SimpleDateFormat
import java.util.*



class AppWidgetTasks : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        super.onUpdate(context, appWidgetManager, appWidgetIds);
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }

    companion object {

        internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager,
                                     appWidgetId: Int) {
            val gson = Gson()
            val mywidgetsettings: Settings = DataParser.getSettings(context)

            // Construct the RemoteViews object
            val views = RemoteViews(context.packageName, R.layout.widget_layout_tasks)

            val intent =  Intent(context, ServiceWidgetTasks::class.java)
            intent.putExtra("random", NotificationID.getID())
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
            intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)));


            views.setRemoteAdapter( R.id.widget_listview_tasks, intent)
            val widget_toolbar = RemoteViewObject(R.id.widget_toolbar, views);
            val widget_text2 = RemoteViewObject(R.id.widget_toolbar_text2, views);
            val widget_textcenter = RemoteViewObject(R.id.widget_centertext, views);
            val widget_listview = RemoteViewObject(R.id.widget_listview_tasks, views);

            widget_listview.setDefaultBackground(mywidgetsettings.appdesign);


            val taskList: List<SchoolTask> = DataParser.getTasks(context)
            if(taskList.isNotEmpty()){
                widget_textcenter.setVisibility(false);
            }else{
                widget_textcenter.setVisibility(true);
            }
            val lastrefreshed = SharedPrefDatabase.alltasksrefreshed.getValue(context);
            if(lastrefreshed == 0.toLong()){
                widget_text2.setText(context.getString(R.string.pleaserefresh));
            }else{
                val calendar_lastrefersh = Calendar.getInstance();
                calendar_lastrefersh.timeInMillis = lastrefreshed;
                widget_text2.setText(context.getString(R.string.refreshed)+": " +SimpleDateFormat.getTimeInstance().format(calendar_lastrefersh.time))
            }


            widget_toolbar.setBackgroundColor(Color.parseColor("#"+mywidgetsettings.appdesign.primary))

            val pendingIntent_startApp = PendingIntent.getActivity(context, 0, startAppIntent(context, "starttasks"), PendingIntent.FLAG_UPDATE_CURRENT)
            views.setOnClickPendingIntent(R.id.widget_toolbar, pendingIntent_startApp)


            val intent_a =  Intent(context, AppWidgetTasks::class.java)
            intent_a.action = "widget_set_refresh"
            views.setOnClickPendingIntent(R.id.widget_button_refresh, PendingIntent.getBroadcast(context, 0, intent_a, 0));


            val pendingIntent_onLessonClick = PendingIntent.getActivity(context, 0, Intent(context, LessonDialogView::class.java),  PendingIntent.FLAG_UPDATE_CURRENT)

            views.setPendingIntentTemplate(R.id.widget_listview_tasks, pendingIntent_onLessonClick)

            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId,R.id.widget_listview_tasks);
            // Instruct the widget manager to update the widgetst
            appWidgetManager.updateAppWidget(appWidgetId, views)

        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        when(intent.action){
            "widget_set_refresh"->{
                enqueueWork(context, LoadTaskData::class.java, 0, intent)
            }

        }
        super.onReceive(context, intent)
    }

}




fun updateTaskWidgets(context: Context) {
    println("UPDATING TASK WIDGET")
    val intent = Intent(context, AppWidgetTasks::class.java)
    intent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
    val widgetManager = AppWidgetManager.getInstance(context)
    val ids = widgetManager.getAppWidgetIds(ComponentName(context, AppWidgetTasks::class.java))
    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
    context.sendBroadcast(intent)

}

