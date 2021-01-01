package com.xla.school.models

import android.graphics.Color

data class Course(val id:String, val name:String, val design: Design, val shortname:String){

    fun getDesignVal():Int{
        try {
            return Color.parseColor("#"+design.primary);
        }catch (e:Exception){
            return Color.parseColor("#"+"FFFFFF");
        }
    }
    fun getShortnameOrName():String = getCorrectShortname()

    fun getCorrectShortname():String{
        if(shortname==null||shortname=="null"||shortname=="")return name;
        else return shortname;
    }
}