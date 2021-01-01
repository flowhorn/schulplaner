package com.xla.school

import android.graphics.Color
import com.google.gson.Gson;
import com.google.gson.stream.JsonReader
import java.io.StringReader
import io.flutter.plugin.common.MethodCall
import android.content.Context
import com.xla.school.logic.SharedPrefDatabase
import com.xla.school.models.Course
import com.xla.school.models.Lesson
import com.xla.school.models.Period




data class DesignBase(val id:String?,val name:String?, val primary:String?, val accent:String?, val darkmode:Boolean?, val autodark:Boolean?);



data class SettingsBase(val appdesign:DesignBase?, val multiple_weektypes:Boolean?, val maxlesson:Int?, val timetable_useshortname:Boolean?, val schedule_showlessontime:Boolean?, val zero_lesson: Boolean?);


data class UpdateWidgetMessage(val courses:List<Course>?, val lessons:List<Lesson>?, val periods:List<Period>?, val settings:SettingsBase?, val memberid:String?)

fun updateWidgetDate(call: MethodCall?, context: Context?){
  if(call == null)throw(Exception("CALL IS NULL!"))
  if(context == null)throw(Exception("CONTEXT IS NULL!"))
  if(call.arguments==null)return
  val rawData = call.arguments

    try{
        val updatewidgetobject = rawData as Map<String, Any>
        SharedPrefDatabase.all_cours.setValue(context,Gson().toJson(updatewidgetobject["courses"]))

        SharedPrefDatabase.all_lesson.setValue(context,Gson().toJson(updatewidgetobject["lessons"]))

        SharedPrefDatabase.all_periods.setValue(context,Gson().toJson(updatewidgetobject["periods"]))

        SharedPrefDatabase.mywidgettimetablesettings.setValue(context,Gson().toJson(updatewidgetobject["settings"]))

        SharedPrefDatabase.memberid.setValue(context, updatewidgetobject["memberid"].toString())

    }catch (e: Exception){

    }


  updateTimetableWidgets(context);
  updateTaskWidgets(context);

}

data class DailyNotificationsSettings(val timeofday:String, val enabled:Boolean, val personalkey:String, val accountid:String);

fun getDaysOfWeek(context: Context):List<String>{
    return listOf(
            "",
            context.getString(R.string.monday),
            context.getString(R.string.tuesday),
            context.getString(R.string.wednesday),
            context.getString(R.string.thursday),
            context.getString(R.string.friday),
            context.getString(R.string.saturday),
            context.getString(R.string.sunday)
    );
}

fun getWeekTypeNames(context: Context):List<String>{
    return listOf(
            context.getString(R.string.always),
            context.getString(R.string.week_a),
            context.getString(R.string.week_b),
            context.getString(R.string.week_c),
            context.getString(R.string.week_d)
    );
}





fun loadPlannerData(context: Context){
 /*
  Thread({
    val notificationSettings:DailyNotificationsSettings = Gson().fromJson(SharedPrefDatabase.mydailynotificationssettings.getValue(context), DailyNotificationsSettings::class.java)
    SchoolplannerData(accountid = notificationSettings.accountid, personalkey = notificationSettings.personalkey).onceFinished {data->
      val GROUP_KEY_DAILYNOTIFICATIONS = "com.xla.school.DAILY_NOTIFICATIONS"
      val SUMMARY_ID = 0
      val notificationManager = NotificationManagerCompat.from(context)
      println("UPCOMINGTASKS:"+data.tasks.size.toString()+data.tasks.toString())

      val summary = NotificationCompat.Builder(context, MainActivity.CHANNEL_ID)
              .setSmallIcon(R.drawable.baseline_school_black_48)
              .setContentTitle(data.tasks.size.toString()+" " +context.getString(R.string.upcoming_tasks))
              .setPriority(NotificationCompat.PRIORITY_DEFAULT)
              .setCategory(NotificationCompat.CATEGORY_REMINDER)
              .setGroup(GROUP_KEY_DAILYNOTIFICATIONS)
              .setGroupAlertBehavior(NotificationCompat.GROUP_ALERT_SUMMARY)
              .setGroupSummary(true)

      notificationManager.notify(SUMMARY_ID, summary.build())

      data.tasks.forEach {


        val mBuilder = NotificationCompat.Builder(context, MainActivity.CHANNEL_ID)
                .setSmallIcon(R.drawable.baseline_school_black_48)
                .setContentTitle(it.getCourse(data.courses).name+": "+it.title)
                .setContentText(DateHelper.getStringtoDayDate(context, it.due))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setGroupAlertBehavior(NotificationCompat.GROUP_ALERT_SUMMARY)
                .setGroup(GROUP_KEY_DAILYNOTIFICATIONS)
                .setGroupSummary(false)



        notificationManager.notify(NotificationID.getID(), mBuilder.build())
      }

    }

  }).start()
  */



}

/*
class MainActivityOld(): FlutterActivity() {
  private val WIDGETCHANNEL = "com.xla.school.widget"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, WIDGETCHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "updatewidget") {
        //val message:String = call.arguments.toString();
        val rawdata:String = call.arguments.toString();
        val reader:JsonReader  = JsonReader(StringReader(rawdata.trim()))
        reader.isLenient = true
        val updatewidgetobject:UpdateWidgetMessage
                =  Gson().fromJson(reader, UpdateWidgetMessage::class.java)
        SharedPrefDatabase.all_cours.setValue(this,Gson().toJson(updatewidgetobject.courses))
        SharedPrefDatabase.all_lesson.setValue(this,Gson().toJson(updatewidgetobject.lessons))
        SharedPrefDatabase.all_periods.setValue(this,Gson().toJson(updatewidgetobject.periods))
        SharedPrefDatabase.mywidgettimetablesettings.setValue(this,Gson().toJson(updatewidgetobject.settings))
        print("OBJECT:"+updatewidgetobject);
          updateWidgets(this);

      } else if (call.method == "hasplayservices") {
        val googleApiAvailability = GoogleApiAvailability.getInstance()
        val resultCode = googleApiAvailability.isGooglePlayServicesAvailable(this)
        if(resultCode ==  ConnectionResult.SUCCESS) result.success(true)
        else result.success(false)
      }
      else {
        result.notImplemented()
      }
    }
  }



}
 */
