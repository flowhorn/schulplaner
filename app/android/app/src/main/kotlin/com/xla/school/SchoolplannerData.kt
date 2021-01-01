package com.xla.school

import android.app.IntentService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import androidx.core.app.JobIntentService
import android.widget.Toast
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.QuerySnapshot
import com.google.firebase.firestore.DocumentSnapshot
import com.google.gson.Gson
import com.xla.school.logic.DataParser
import com.xla.school.logic.SharedPrefDatabase
import com.xla.school.models.Course
import com.xla.school.models.SchoolTask
import java.text.SimpleDateFormat
import java.util.*

data class nCourse(val id:String = "", val name:String = "", val designid:String = "");

data class nTask(val id:String = "", val title:String = "", val due:String = "", val type:Int = 0, val coursid:String=""){

    fun getCourse(list: List<nCourse>):nCourse{
        list.forEach {course->
            if(course.id == coursid)return course;
        }
        return  nCourse()
    }
};



/*c
class Schoolplanner(val accountid:String, val personalkey:String){

    var courses: MutableList<nCourse> = arrayListOf()
    var tasks: MutableList<nTask> = arrayListOf()

    private var onFinished: (SchoolplannerData)-> Unit = {data->};

    private var loaded_courses:Boolean = false
    private  var total_courses_standard:Int = 0

    private  var loaded_courseinfo:Int = 0
    private  var loaded_coursetask:Int = 0



    init {
        val root = FirebaseDatabase.getInstance().reference;
        var schoolplannerref : DatabaseReference
        if(accountid == "DEFAULT")schoolplannerref = root.child("users").child(personalkey)
        else schoolplannerref = root.child("schoolplanner").child(personalkey)


        //RETREIVE ALL COURSES

        schoolplannerref.child("mycourses").addListenerForSingleValueEvent(object:ValueEventListener{
            override fun onDataChange(p0: DataSnapshot?) {
                val list: List<String> = p0?.children?.map { it.key }?: arrayListOf();
                list.forEach {
                    val courseref = root.child("courses").child(it);
                    courseref.child("info").addListenerForSingleValueEvent(object:ValueEventListener{
                        override fun onCancelled(p0: DatabaseError?) {

                        }

                        override fun onDataChange(p0: DataSnapshot?) {
                            val courseinfo:nCourse? = p0?.getValue(nCourse::class.java)
                            if(courseinfo != null){
                                courses.add(courseinfo)
                            }
                            loaded_courseinfo++
                            checkState()
                        }

                    })
                    courseref.child("task").orderByChild("due").startAt(DateHelper.getToday()).endAt(DateHelper.getThreeDays()).addListenerForSingleValueEvent(object:ValueEventListener{
                        override fun onCancelled(p0: DatabaseError?) {

                        }

                        override fun onDataChange(p0: DataSnapshot?) {
                            val coursetasks:List<nTask?> = p0?.children?.map { it.getValue(nTask::class.java) }?: arrayListOf<nTask>()
                            coursetasks.forEach { if(it != null){
                                courseref.child("taskpersonal").child(personalkey).child(it.id).child("finished").addListenerForSingleValueEvent(object:ValueEventListener{
                                    override fun onCancelled(p0: DatabaseError?) {

                                    }

                                    override fun onDataChange(p0: DataSnapshot?) {
                                        if(p0 != null){

                                            if(p0.exists()){
                                                if(p0.getValue(Boolean::class.java) == false){
                                                    tasks.add(it)
                                                    checkState()
                                                }
                                            }else{
                                                tasks.add(it)
                                                checkState()
                                            }

                                        }

                                    }

                                })


                            }   }
                            loaded_coursetask++
                            checkState()
                        }

                    })
                }
                total_courses_standard = list.size
                loaded_courses = true
                checkState()
            }

            override fun onCancelled(p0: DatabaseError?) {
            }

        })

        schoolplannerref.child("myclasses").addListenerForSingleValueEvent(object:ValueEventListener{
            override fun onDataChange(p0: DataSnapshot?) {
                val list: List<String> = p0?.children?.map { it.key }?: arrayListOf();
                list.forEach {
                    schoolplannerref.child("myclasses").addListenerForSingleValueEvent(object:ValueEventListener{
                        override fun onDataChange(p0: DataSnapshot?) {
                            val list: List<String> = p0?.children?.map { it.key }?: arrayListOf();
                        }

                        override fun onCancelled(p0: DatabaseError?) {
                        }

                    })
                }
            }

            override fun onCancelled(p0: DatabaseError?) {
            }

        })

    }


    fun onceFinished(listener:(SchoolplannerData)-> Unit){
        onFinished = listener;
    }

    fun checkState(){
        if(loaded_courses == false)return;
        if(loaded_courseinfo < total_courses_standard)return;
        if(loaded_coursetask < total_courses_standard)return;
        onFinished(this)
    }


}
 */


class LoadTaskData : JobIntentService(){
    override fun onHandleWork(intent: Intent) {
        val gson = Gson()
        val memberid:String = SharedPrefDatabase.memberid.getValue(this) ?: ""
        println("STARTSERVICE");
        if(memberid == ""){
            Handler(Looper.getMainLooper()).post(Runnable {
                Toast.makeText(this,
                        "Bitte Widget in den Einstellungen aktualisieren", Toast.LENGTH_SHORT)
                        .show();
            })
            return;
        }
        val uid = memberid.split("::")[0];
        val plannerid = memberid.split("::")[1];

        val courses: List<Course> = DataParser.getCourses(this)
        val data = arrayListOf<Task<QuerySnapshot>>()

        val formatdate = SimpleDateFormat("yyyy-MM-dd");
        val today = formatdate.format(Calendar.getInstance().time)
        val lastdaycalendar = Calendar.getInstance();
        lastdaycalendar.add(Calendar.DAY_OF_YEAR, 7);
        val lastday = formatdate.format((lastdaycalendar.time));


        data.add(FirebaseFirestore.getInstance()
                .collection("users")
                .document(uid).collection("planner").document(plannerid)
                .collection("tasks")
                .whereGreaterThanOrEqualTo("due", today)
                .whereLessThanOrEqualTo("due", lastday)
                .whereEqualTo("archived", false)
                .get());
        for(course in courses){
            data.add(FirebaseFirestore.getInstance()
                    .collection("courses")
                    .document(course.id).collection("tasks")
                    .whereGreaterThanOrEqualTo("due", today)
                    .whereLessThanOrEqualTo("due", lastday)
                    .whereEqualTo("archived", false)
                    .get())
        }
        Tasks.whenAllComplete(data).addOnCompleteListener {
            val results = it.result;
            if(results==null)return@addOnCompleteListener;
            println("Results::"+results.size.toString())
            val tasklist: ArrayList<SchoolTask>  = arrayListOf();
            for(task in results){
                val result = task.result;
                if(result is QuerySnapshot){
                    result.documents.forEach { docSnap ->
                        val docData = docSnap.data;
                        if(docSnap!=null && docData!=null){
                            println("ADD"+docSnap.id)
                            var finishedval = false;
                            val finishedmap = docSnap.data?.get("finished");
                            println(finishedmap);
                            if(finishedmap != null && finishedmap is Map<*,*>){
                                val finished_member = finishedmap.get(memberid);
                                if(finished_member != null && finished_member is Map<*,*>){
                                    val value = finished_member.get("finished");
                                    if(value != null && value is Boolean){
                                        finishedval =value;
                                    }
                                }
                            }

                            tasklist.add(SchoolTask(
                                    id = docData.get("id")?.toString()?:"id",
                                    title = docData.get("title")?.toString()?:"title",
                                    due = docData.get("due")?.toString()?:"due" ,
                                    courseid = docData.get("courseid")?.toString()?:"courseid",
                                    finished = finishedval
                            ))
                        }
                    }
                }
            }
            println(tasklist.size)
            SharedPrefDatabase.alltasks.setValue(this, gson.toJson(tasklist))
            SharedPrefDatabase.alltasksrefreshed.setValue(this, System.currentTimeMillis());
            updateTaskWidgets(this)
        }

    }


}