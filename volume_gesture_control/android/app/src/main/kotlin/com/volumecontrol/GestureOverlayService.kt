package com.volumecontrol

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.view.*
import android.view.GestureDetector.SimpleOnGestureListener
import kotlin.math.abs

class GestureOverlayService : Service() {
    private lateinit var windowManager: WindowManager
    private lateinit var gestureDetector: GestureDetector
    private lateinit var overlayView: View
    private lateinit var volumeService: VolumeControlService

    override fun onCreate() {
        super.onCreate()
        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        volumeService = VolumeControlService()
        
        setupGestureDetector()
        createOverlay()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun setupGestureDetector() {
        gestureDetector = GestureDetector(this, object : SimpleOnGestureListener() {
            private val SWIPE_THRESHOLD = 100
            private val SWIPE_VELOCITY_THRESHOLD = 100

            override fun onFling(
                e1: MotionEvent?,
                e2: MotionEvent?,
                velocityX: Float,
                velocityY: Float
            ): Boolean {
                if (e1 == null || e2 == null) return false

                val diffY = e2.y - e1.y
                val diffX = e2.x - e1.x

                // Only process gestures in top 25% of screen
                val screenHeight = resources.displayMetrics.heightPixels
                if (e1.y > screenHeight * 0.25) return false

                if (abs(diffX) > abs(diffY) && 
                    abs(diffX) > SWIPE_THRESHOLD && 
                    abs(velocityX) > SWIPE_VELOCITY_THRESHOLD) {
                    
                    if (diffX > 0) {
                        // Right swipe - increase volume
                        volumeService.increaseVolume()
                    } else {
                        // Left swipe - decrease volume
                        volumeService.decreaseVolume()
                    }
                    return true
                }
                return false
            }
        })
    }

    private fun createOverlay() {
        overlayView = object : View(this) {
            override fun onTouchEvent(event: MotionEvent): Boolean {
                return gestureDetector.onTouchEvent(event) || super.onTouchEvent(event)
            }
        }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                    WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.TOP or Gravity.START
        windowManager.addView(overlayView, params)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::overlayView.isInitialized) {
            windowManager.removeView(overlayView)
        }
    }
}
