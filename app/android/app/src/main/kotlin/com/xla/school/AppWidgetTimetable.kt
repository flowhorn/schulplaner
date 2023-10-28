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
import androidx.preference.PreferenceManager
import com.xla.school.logic.DataParser
import com.xla.school.logic.SharedPrefDatabase
import com.xla.school.models.*
import com.xla.school.views.RemoteViewObject
import java.lang.Exception


/**
 * Implementation of App Widget functionality.
 */




class AppWidgetTimetable : AppWidgetProvider() {

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
            println("UPDATE OF SINGLE WIDGET STARTED");
            val mywidgetsettings:Settings = DataParser.getSettings(context)
            val currentweektype = if(mywidgetsettings.multiple_weektypes) SharedPrefDatabase.currentweektype.getValue(context) else 0
            // Construct the RemoteViews object
            val views = RemoteViews(context.packageName, R.layout.widget_layout_schedule)
            val ab_layout = RemoteViewObject(R.id.widget_ab_layout, views);
            val widget_toolbar = RemoteViewObject(R.id.widget_timetable_toolbar, views);
            val topPanel = RemoteViewObject(R.id.topPanel, views);
            val button_a = RemoteViewObject(R.id.widget_button_a, views);
            val button_b = RemoteViewObject(R.id.widget_button_b, views);
            val textview_updatewidget = RemoteViewObject(R.id.textview_updatewidget, views)


            if(DataParser.getCourses(context).isEmpty()){
                textview_updatewidget.setVisibility(true)
            }else{
                textview_updatewidget.setVisibility(false)
            }

            if(mywidgetsettings.multiple_weektypes){
                ab_layout.setVisibility(true)
                button_a.setEnabled(false)
                if(currentweektype == 0){
                    button_a.setEnabled(true);
                    button_b.setEnabled(true)
                }else{
                    if(currentweektype == 1){
                        button_a.setEnabled(false);
                        button_b.setEnabled(true)
                    }else if(currentweektype == 2){
                        button_a.setEnabled(true);
                        button_b.setEnabled(false)
                    }
                }
                val intent_a =  Intent(context, AppWidgetTimetable::class.java)
                intent_a.action = "widget_set_a"
                views.setOnClickPendingIntent(R.id.widget_button_a, PendingIntent.getBroadcast(context, 0, intent_a, 0));

                val intent_b =  Intent(context, AppWidgetTimetable::class.java)
                intent_b.action = "widget_set_b"
                views.setOnClickPendingIntent(R.id.widget_button_b, PendingIntent.getBroadcast(context, 0, intent_b, 0));
            }else{
                ab_layout.setVisibility(false)
            }


            widget_toolbar.setBackgroundColor(Color.parseColor("#"+mywidgetsettings.appdesign.primary))
            topPanel.setBackgroundColor(Color.parseColor("#"+mywidgetsettings.appdesign.primary))

            val pendingIntent_startApp = PendingIntent.getActivity(context, 1, startAppIntent(context, "starttimetable"), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
            views.setOnClickPendingIntent(R.id.widget_timetable_toolbar, pendingIntent_startApp)

            val intent =  Intent(context, ServiceWidgetTimetable::class.java)
            intent.putExtra("randomvalue", NotificationID.getID())
            intent.putExtra("weektype", currentweektype);
            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
            intent.setData(Uri.parse(intent.toUri(Intent.URI_INTENT_SCHEME)));

            val pendingIntent_onLessonClick = PendingIntent.getActivity(context, 0, Intent(context, LessonDialogView::class.java), PendingIntent.FLAG_MUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
            views.setPendingIntentTemplate(R.id.widget_listview, pendingIntent_onLessonClick)

            views.setRemoteAdapter(R.id.widget_listview, intent)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.widget_listview)

            // Instruct the widget manager to update the widgetst
            appWidgetManager.updateAppWidget(appWidgetId, views)

        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        when(intent.action){
            "widget_set_a"->{
                SharedPrefDatabase.currentweektype.setValue(context, 1);
                val widgetManager = AppWidgetManager.getInstance(context)
                val ids = widgetManager.getAppWidgetIds(ComponentName(context, AppWidgetTimetable::class.java))
                onUpdate(context, widgetManager, ids)
            }
            "widget_set_b"->{
                SharedPrefDatabase.currentweektype.setValue(context, 2);
                val widgetManager = AppWidgetManager.getInstance(context)
                val ids = widgetManager.getAppWidgetIds(ComponentName(context, AppWidgetTimetable::class.java))
                onUpdate(context, widgetManager, ids)

            }
            "android.appwidget.action.APPWIDGET_UPDATE"->{
            }
        }
        super.onReceive(context, intent);
    }

}


fun startAppIntent(context:Context, arguments:String?):Intent{
    val i = Intent(context, MainActivity::class.java);
    i.putExtra("startargument", arguments?:"");
    return i;
}


fun updateTimetableWidgets(context: Context) {
    println("UPDATING TIMETABLE WIDGET")
    val intent = Intent(context, AppWidgetTimetable::class.java)
    intent.setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
    val widgetManager = AppWidgetManager.getInstance(context)
    val ids = widgetManager.getAppWidgetIds(ComponentName(context, AppWidgetTimetable::class.java))
    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
    context.sendBroadcast(intent)

// Use an array and EXTRA_APPWIDGET_IDS instead of AppWidgetManager.EXTRA_APPWIDGET_ID,
// since it seems the onUpdate() is only fired on that:

}

