package ru.xfnii.getx_gallery
import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import com.rmawatson.flutterisolate.FlutterIsolatePlugin
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import ru.xfnii.getx_gallery.path_provider_ex.StorageUtils
import ru.xfnii.getx_gallery.thumbnail_creator.ThumbnailPlugin
import java.io.File
import java.util.*


class MainActivity: FlutterFragmentActivity () {

    private lateinit var context: Context


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.plugins.add(ThumbnailPlugin())
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "path_provider_ex").setMethodCallHandler { call, result ->
            if (call.method.equals("getExtStorageData")) {
                val reply: ArrayList<HashMap<*, *>> = StorageUtils.getExternalStorageAvailableData(context)
                result.success(reply)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        context = this
    }   
}