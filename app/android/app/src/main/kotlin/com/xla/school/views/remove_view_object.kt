package com.xla.school.views

import android.graphics.Color
import android.view.View
import android.widget.RemoteViews
import androidx.annotation.IdRes
import com.xla.school.models.Design

class RemoteViewObject(@IdRes val id:Int, val remoteViews: RemoteViews){

    fun setBackgroundColor(color:Int){
        remoteViews.setInt(id, "setBackgroundColor",
                color);
    }

    fun setDefaultBackground(design: Design){
        if(design.darkmode){
            setBackgroundColor(0xFF303030.toInt());
        }else{
            setBackgroundColor(Color.WHITE);
        }
    }

    fun setDefaultTextColor(design: Design){
        if(design.darkmode){
            remoteViews.setTextColor(id, Color.WHITE);
        }else{
            remoteViews.setTextColor(id, 0xFF303030.toInt());
        }
    }

    fun setNumColumns(amount:Int){
        // remoteViews.setInt(id, "setNumColumns", 7);
    }

    fun setEnabled(boolean: Boolean){
        if(boolean == true){
            remoteViews.setBoolean(id, "setEnabled", true);
            remoteViews.setTextColor(id, Color.WHITE);
        }else{
            remoteViews.setBoolean(id, "setEnabled", false);
            remoteViews.setTextColor(id, Color.DKGRAY);
        }
    }
    fun setAlpha(alpha: Int){
        remoteViews.setInt(id, "setAlpha",
                alpha);
    }
    fun setVisibility(visible:Boolean){
        remoteViews.setViewVisibility(id, if(visible) View.VISIBLE else View.GONE)
    }
    fun setText(text:String){
        remoteViews.setTextViewText(id, text)
    }

}
