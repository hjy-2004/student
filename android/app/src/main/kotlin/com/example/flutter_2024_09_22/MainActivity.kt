package com.example.flutter_2024_09_22

import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.provider.DocumentsContract
import android.os.Environment


class MainActivity : FlutterActivity() {
    private val CHANNEL = "file_viewer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // 处理来自 Flutter 的方法调用
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIncomingIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIncomingIntent(intent)
    }

    private fun handleIncomingIntent(intent: Intent) {
        if (Intent.ACTION_VIEW == intent.action) {
            val fileUri: Uri? = intent.data
            if (fileUri != null) {
                val filePath = getRealPathFromURI(fileUri)
                Log.d("FileViewer", "Received file path: $filePath")
                MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger ?: return, CHANNEL)
                    .invokeMethod("openFile", filePath)
            } else {
                Log.e("FileViewer", "No fileUri received")
            }
        }
    }
    

    private fun getRealPathFromURI(uri: Uri): String? {
        var filePath: String? = null
        val projection = arrayOf(MediaStore.Images.Media.DATA)
    
        // 使用 ContentResolver 查询 URI
        val cursor: Cursor? = contentResolver.query(uri, projection, null, null, null)
        cursor?.use {
            val columnIndex = it.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            if (it.moveToFirst()) {
                filePath = it.getString(columnIndex)
            }
        }
    
        // 如果未找到路径，则返回 URI 的原始路径
        return filePath ?: uri.path
    }
    
    
    
    
}
