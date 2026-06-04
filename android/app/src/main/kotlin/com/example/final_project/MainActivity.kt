package com.example.final_project

import android.app.WallpaperManager
import android.content.ComponentName
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.*
import java.net.URL

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.wallpaper/set_wallpaper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setWallpaper" -> {
                    val imageUrl = call.argument<String>("imageUrl")
                    val target = call.argument<String>("target")
                    if (imageUrl != null && target != null) {
                        Thread {
                            try {
                                val input = URL(imageUrl).openStream()
                                val bitmap = BitmapFactory.decodeStream(input)
                                val manager = WallpaperManager.getInstance(applicationContext)
                                when (target) {
                                    "Home" -> manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                                    "Lock" -> manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                                    "Both" -> {
                                        manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                                        manager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                                    }
                                }
                                runOnUiThread {
                                    result.success(" Image wallpaper set successfully")
                                }
                            } catch (e: Exception) {
                                runOnUiThread {
                                    result.error("WALLPAPER_ERROR", e.message, null)
                                }
                            }
                        }.start()
                    } else {
                        result.error("INVALID_ARGUMENTS", "Missing imageUrl or target", null)
                    }
                }

                "setVideoWallpaper" -> {
                    val videoUrl = call.argument<String>("videoUrl")
                    if (videoUrl != null) {
                        Thread {
                            try {
                                val file = File(filesDir, "live_wallpaper.mp4")
                                if (file.exists()) file.delete()

                                downloadVideo(videoUrl, file)

                                Handler(Looper.getMainLooper()).postDelayed({
                                    // 👇 Kill old wallpaper service before re-launching
                                    stopWallpaper()
                                    forceReloadLiveWallpaper()

                                    result.success(" Video wallpaper set successfully")
                                }, 1000)
                            } catch (e: Exception) {
                                runOnUiThread {
                                    result.error("DOWNLOAD_ERROR", e.message, null)
                                }
                            }
                        }.start()
                    } else {
                        result.error("INVALID_URL", "Video URL is null", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun downloadVideo(videoUrl: String, destFile: File) {
        val url = URL(videoUrl)
        val inputStream = BufferedInputStream(url.openStream())
        val outputStream = FileOutputStream(destFile)
        val buffer = ByteArray(1024)
        var bytesRead: Int
        while (inputStream.read(buffer).also { bytesRead = it } != -1) {
            outputStream.write(buffer, 0, bytesRead)
        }
        inputStream.close()
        outputStream.close()
    }

    private fun stopWallpaper() {
        try {
            val manager = WallpaperManager.getInstance(applicationContext)
            manager.clear()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun forceReloadLiveWallpaper() {
        val intent = Intent(WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER).apply {
            putExtra(
                WallpaperManager.EXTRA_LIVE_WALLPAPER_COMPONENT,
                ComponentName(this@MainActivity, LiveWallpaperService::class.java)
            )
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }
}
