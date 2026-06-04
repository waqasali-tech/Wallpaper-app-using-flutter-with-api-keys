package com.example.final_project

import android.media.MediaPlayer
import android.service.wallpaper.WallpaperService
import android.util.Log
import android.view.SurfaceHolder
import java.io.File

class LiveWallpaperService : WallpaperService() {

    override fun onCreateEngine(): Engine {
        return VideoWallpaperEngine()
    }

    private inner class VideoWallpaperEngine : Engine() {
        private var mediaPlayer: MediaPlayer? = null

        override fun onSurfaceCreated(holder: SurfaceHolder) {
            super.onSurfaceCreated(holder)
            Log.d("LiveWallpaper", "✅ Surface created")
            startVideo(holder)
        }

        private fun startVideo(holder: SurfaceHolder) {
            val videoFile = File(filesDir, "live_wallpaper.mp4")
            if (!videoFile.exists()) {
                Log.e("LiveWallpaper", "❌ Video file not found.")
                return
            }

            mediaPlayer?.release()
            mediaPlayer = MediaPlayer().apply {
                try {
                    setDataSource(videoFile.absolutePath)
                    setSurface(holder.surface)
                    isLooping = true
                    setVolume(0f, 0f)

                    setOnPreparedListener {
                        Log.d("LiveWallpaper", "✅ MediaPlayer prepared, starting...")
                        start()
                    }

                    setOnErrorListener { _, what, extra ->
                        Log.e("LiveWallpaper", "❌ MediaPlayer error: $what, $extra")
                        true
                    }

                    prepareAsync()
                } catch (e: Exception) {
                    Log.e("LiveWallpaper", "❌ Exception: ${e.message}", e)
                }
            }
        }

        override fun onSurfaceDestroyed(holder: SurfaceHolder) {
            super.onSurfaceDestroyed(holder)
            mediaPlayer?.release()
            mediaPlayer = null
            Log.d("LiveWallpaper", "🧹 Surface destroyed, MediaPlayer released")
        }
    }
}
