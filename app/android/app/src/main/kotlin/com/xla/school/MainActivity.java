package com.xla.school;


import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;





public class MainActivity extends FlutterActivity {
    public static final String CHANNEL_ID = "com.xla.school.upcoming_events";
    private static final String WIDGETCHANNEL = "com.xla.school.widget";
    private static final String UPDATEWIDGET = "updateWidget";
    String startargument = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent i = getIntent();
        if(i!=null){
            Bundle extras = i.getExtras();
            if(extras!=null){
                startargument = extras.getString("startargument");
            }
        }
        MainActivityOldKt.loadPlannerData(this);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
                GeneratedPluginRegistrant.registerWith(flutterEngine);
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), WIDGETCHANNEL)
                                .setMethodCallHandler(
                                    (call, result) -> {
                                        switch (call.method){
                                            case UPDATEWIDGET:{
                                                MainActivityOldKt.updateWidgetDate(call, MainActivity.this);
                                                result.success(true);
                                                break;
                                            }
                                            case "getstartargument":{
                                                result.success(startargument);
                                                break;
                                            }
                                            case "hasplayservices":{
                                                GoogleApiAvailability googleApiAvailability = GoogleApiAvailability.getInstance();
                                                int resultCode = googleApiAvailability.isGooglePlayServicesAvailable(MainActivity.this);
                                                if(resultCode ==  ConnectionResult.SUCCESS) result.success(true);
                                                else result.success(false);
                                                break;
                                            }
                                            default:{
                                                result.success(true);
                                                break;
                                            }
                                        }
                                            }
                                );
            }



}


