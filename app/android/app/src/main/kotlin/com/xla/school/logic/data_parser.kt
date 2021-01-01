package com.xla.school.logic

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.xla.school.SettingsBase
import com.xla.school.models.*
import java.lang.Exception


private val typePeriodList = object : TypeToken<List<Period>>() {}.type
private val typeLessonList = object : TypeToken<List<Lesson>>() {}.type
private val typeCourseList = object : TypeToken<List<Course>>() {}.type
private val typeTaskList = object : TypeToken<List<SchoolTask>>() {}.type

object DataParser{

    private val database: SharedPrefDatabase = SharedPrefDatabase
    private val gson: Gson = Gson()


    fun getSettings(context: Context): Settings {

        val timetableSettingsJson = database.mywidgettimetablesettings.getValue(context)
        var base: SettingsBase? = null
        try{
            base = gson.fromJson<SettingsBase>(timetableSettingsJson, SettingsBase::class.java)
        }catch (e: Exception){

        }
        return  Settings(
                appdesign = Design(
                        id = base?.appdesign?.id ?:"PREDESIGN_4",
                        name = base?.appdesign?.name ?: "Teal",
                        primary = base?.appdesign?.primary ?:"009688",
                        accent = base?.appdesign?.accent ?: "FFFFFF",
                        darkmode = base?.appdesign?.darkmode?:false,
                        autodark = base?.appdesign?.autodark?:false
                ),
                maxlesson = base?.maxlesson ?: 10,
                multiple_weektypes = base?.multiple_weektypes?:false,
                schedule_showlessontime = base?.schedule_showlessontime?:false,
                timetable_useshortname = base?.timetable_useshortname?:true,
                zero_lesson = base?.zero_lesson ?:false
        )
    }

    fun getCourses(context: Context): List<Course> {
        val coursesData = database.all_cours.getValue(context)
        return if(coursesData == null || coursesData == "null" || coursesData == "") listOf()
        else gson.fromJson(coursesData, typeCourseList)
    }

    fun getTasks(context: Context): List<SchoolTask> {
        val taskData = database.alltasks.getValue(context)
        return if(taskData == null || taskData == "null" || taskData=="")  listOf()
        else gson.fromJson(database.alltasks.getValue(context), typeTaskList)
    }

    fun getCourse(context: Context, courseID: String): Course? {
        val courses = getCourses(context)
        return courses.find{it.id==courseID}
    }

    fun getLessons(context: Context): List<Lesson> {
        val lessonsData = database.all_lesson.getValue(context)
        return if(lessonsData == null || lessonsData == "null" || lessonsData=="") listOf()
        else gson.fromJson(lessonsData, typeLessonList)
    }

    fun getLesson(context: Context, lessonID: String): Lesson? {
        val lessons = getLessons(context)
        return lessons.find{it.id==lessonID}
    }

    fun getPeriodList(context: Context):List<Period>{
        val periodsData: String? = database.all_periods.getValue(context)
        return if(periodsData == null || periodsData == "null" || periodsData=="")  listOf()
        else gson.fromJson(periodsData, typePeriodList)
    }

    fun getIndividualPeriod(context: Context, start: Int, end:Int): Period {
        val list = getPeriodList(context);
        val startString = list.find{ it.id == start }?.start?:"00:00"
        val endString = list.find { it.id == end }?.end?:"00:00"
        return Period(id = 0, start = startString, end = endString)
    }



}