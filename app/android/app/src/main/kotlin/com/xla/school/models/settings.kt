package com.xla.school.models


data class Settings(val appdesign:Design,
                    val multiple_weektypes:Boolean,
                    val maxlesson:Int,
                    val timetable_useshortname:Boolean,
                    val schedule_showlessontime:Boolean,
                    val zero_lesson: Boolean
)
