package ru.xfnii.getx_gallery.thumbnail_creator

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.ThumbnailUtils
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.ByteArrayOutputStream
import java.io.File

class ThumbnailPlugin :  FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var appDirPath: String
    private val mainScope = CoroutineScope(Dispatchers.Main)

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        appDirPath = context.getExternalFilesDir(null)!!.path
        val thumbnailFolder = File("$appDirPath/thumbnails")
        if(!thumbnailFolder.exists()){
            thumbnailFolder.mkdir()
        }
        channel = MethodChannel(binding.binaryMessenger, "thumbnail_creator")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "create" -> {
                mainScope.launch {
                    val res = withContext(Dispatchers.Default) {
                        try {
                            val arg = call.arguments as Map<*, *>
                            val image: Bitmap = ThumbnailUtils.extractThumbnail(BitmapFactory.decodeFile(arg["path"] as String?), arg["width"] as Int, arg["height"] as Int)
                            val stream = ByteArrayOutputStream()
                            image.compress(Bitmap.CompressFormat.JPEG, 60, stream)
                            val path = "$appDirPath/thumbnails/${arg["path"].hashCode()}.jpg"
                            val file = File(path)
                            file.writeBytes(stream.toByteArray())
                            path
                        } catch (e: Exception) {
                            e.message
                        }
                    }
                    result.success(res)
                }
            }
            else -> result.notImplemented()
        }
    }
}