package com.xla.school.models


data class Lesson(val id:String, val courseid:String, val day:Int, val start:Int, val end:Int, val weektype:Int, val teacher: Teacher?=null, val location: Place?=null){

    fun isMultiLesson():Boolean{
        if(start==end)return false;
        else return true;
    }

    fun getSingleLessons():MutableList<Lesson>{
        val list:MutableList<Lesson> = mutableListOf<Lesson>()
        for (i in start..end) {
            list.add(copy(start = i,end = i))
        }
        return list;
    }

    companion object {
        fun getWeektypeByKey(key:String):Int{
            return key.split("-")[0].toInt()
        }
        fun getDayByKey(key:String):Int{
            return key.split("-")[1].toInt()
        }
        fun getStartByKey(key:String):Int{
            return key.split("-")[2].toInt()
        }
        fun getScheduleKey(weektype:Int,
                           day:Int,
                           start:Int):String
                = StringBuilder().append(weektype)
                .append("-").append(day)
                .append("-").append(start).toString()


    }

}
