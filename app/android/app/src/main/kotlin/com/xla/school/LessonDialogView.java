package com.xla.school;

import android.content.Intent;
import android.content.res.TypedArray;
import android.graphics.Color;
import android.os.Bundle;
import androidx.annotation.AttrRes;
import androidx.annotation.NonNull;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.xla.school.logic.DataParser;
import com.xla.school.models.Course;
import com.xla.school.models.Lesson;
import com.xla.school.models.Period;
import com.xla.school.models.Settings;

import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class LessonDialogView extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStatusBarDim(true);

        setContentView(R.layout.lessondialog_view);
        findViewById(R.id.touch_outside).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finishAndRemoveTask();
            }
        });
        BottomSheetBehavior.from(findViewById(R.id.bottom_sheet))
                .setBottomSheetCallback(new BottomSheetBehavior.BottomSheetCallback() {
                    @Override
                    public void onStateChanged(@NonNull View bottomSheet, int newState) {
                        switch (newState) {
                            case BottomSheetBehavior.STATE_HIDDEN:
                                finishAndRemoveTask();
                                break;
                            case BottomSheetBehavior.STATE_EXPANDED:
                                setStatusBarDim(true);
                                break;
                            default:
                                setStatusBarDim(true);
                                break;
                        }
                    }

                    @Override
                    public void onSlide(@NonNull View bottomSheet, float slideOffset) {
                        // no op
                    }
                });

        Toolbar mActionBarToolbar = (Toolbar) findViewById(R.id.my_toolbar);
        setSupportActionBar(mActionBarToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeAsUpIndicator(R.drawable.baseline_close_black_24);

        Intent i = getIntent();
        String lessonid = i.getExtras().getString("data_lesson_id");
        if(lessonid != null){

            Lesson lesson = DataParser.INSTANCE.getLesson(this, lessonid);
            Course course  =DataParser.INSTANCE.getCourse(this, lesson.getCourseid());
            Period period = DataParser.INSTANCE.getIndividualPeriod(this, lesson.getStart(), lesson.getEnd());

            getSupportActionBar().setTitle((
                    MainActivityOldKt.getDaysOfWeek(this).get(lesson.getDay()) +
                            ", " + (lesson.isMultiLesson()? String.valueOf(lesson.getStart())+". - "+String.valueOf(lesson.getEnd())+". "
                            : String.valueOf(lesson.getStart())+". ")
            ));
            ((TextView) findViewById(R.id.text_info_course)).setText(course.getName());
            ((ImageView) findViewById(R.id.icon_info_course)).setColorFilter(course.getDesignVal());

            if(lesson.getTeacher() != null){
                ((TextView) findViewById(R.id.text_info_teacher)).setText(lesson.getTeacher().getName());
            }else{
                ((TextView) findViewById(R.id.text_info_teacher)).setText("-");
            }

            if(lesson.getLocation() != null){
                ((TextView) findViewById(R.id.text_info_place)).setText(lesson.getLocation().getName());
            }else{
                ((TextView) findViewById(R.id.text_info_place)).setText("-");
            }
            Settings settings = DataParser.INSTANCE.getSettings(this);

            if(settings.getMultiple_weektypes()){
                ((RelativeLayout) findViewById(R.id.layout_weektype)).setVisibility(View.VISIBLE);
                ((TextView) findViewById(R.id.text_info_weektype)).setText(MainActivityOldKt.getWeekTypeNames(this).get(lesson.getWeektype()));
            }

            ((TextView) findViewById(R.id.text_info_period)).setText(
            (lesson.isMultiLesson()? (String.valueOf(lesson.getStart())+". - "+String.valueOf(lesson.getEnd())+". "+getString(R.string.period)
                    +(settings.getSchedule_showlessontime()?
                    (
                            " "+period.getStart()+"-"+period.getEnd()
                    ):
                    "")
            )
                    : String.valueOf(lesson.getStart())+". "+getString(R.string.period)
                    +(settings.getSchedule_showlessontime()?
                    (
                     " "+period.getStart()+"-"+period.getEnd()
                            ):
                    ""
            )
            ));

        }
    }

    private void setStatusBarDim(boolean dim) {
        getWindow().setStatusBarColor(dim ? Color.TRANSPARENT :
                    ContextCompat.getColor(this, getThemedResId(R.attr.colorPrimaryDark)));
    }

    private int getThemedResId(@AttrRes int attr) {
        TypedArray a = getTheme().obtainStyledAttributes(new int[]{attr});
        int resId = a.getResourceId(0, 0);
        a.recycle();
        return resId;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finishAndRemoveTask();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

}
