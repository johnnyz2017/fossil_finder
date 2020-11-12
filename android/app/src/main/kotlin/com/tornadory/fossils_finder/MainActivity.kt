package com.tornadory.fossils_finder

import io.flutter.embedding.android.FlutterActivity

import io.flutter.app.FlutterApplication;

//import com.baidu.mapapi.SDKInitializer;
//import com.baidu.flutter_bmfbase.BmfContextHelper;

class FossilApplication : FlutterApplication() {
  //lateinit var flutterEngine : FlutterEngine

  override fun onCreate() {
    super.onCreate()

    // Instantiate a FlutterEngine.
    //flutterEngine = FlutterEngine(this)

    // Start executing Dart code to pre-warm the FlutterEngine.
    //flutterEngine.dartExecutor.executeDartEntrypoint(
    //  DartExecutor.DartEntrypoint.createDefault()
    //)

    // Cache the FlutterEngine to be used by FlutterActivity.
    //FlutterEngineCache
    //  .getInstance()
    //  .put("my_engine_id", flutterEngine)

    //BmfContextHelper.sContext = this;
    //SDKInitializer.initialize(this);
  }
}

class MainActivity: FlutterActivity() {
}
