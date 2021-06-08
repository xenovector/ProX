package com.example.prox

import android.content.Context
import android.graphics.Point
import android.os.Build
import android.view.WindowInsets
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.common.GoogleApiAvailability
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    private val PROX_CHANNEL = "com.prox.method_channel/prox";
    var concurrentContext = this@MainActivity.context
    var statusBarHeight: Int = 0;
    var navigationBarHeight: Int = 0;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        statusBarHeight = getStatusBarHeight();
        navigationBarHeight = context.systemNavigationBarHeight;
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PROX_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isGmsAvailable") {
                result.success(isGmsAvailable());
            } else if (call.method == "statusBarHeight") {
                result.success(statusBarHeight);
            } else if (call.method == "navigationBarHeight") {
                result.success(navigationBarHeight);
            } else {
                result.notImplemented()
            }
        }
    }



    private fun isGmsAvailable(): Boolean {
        var isAvailable = false
        val context: Context = concurrentContext
        if (null != context) {
            val result: Int = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(context)
            isAvailable = com.google.android.gms.common.ConnectionResult.SUCCESS === result
        }
        return isAvailable
    }


    @JvmName("getStatusBarHeight1")
    private fun getStatusBarHeight(): Int {
        var result = 0
        val resourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            result = resources.getDimensionPixelSize(resourceId)
        }
        return result
    }

    private val Context.systemNavigationBarHeight: Int
        get() {
            val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

            return if (Build.VERSION.SDK_INT >= 30) {
                windowManager
                        .currentWindowMetrics
                        .windowInsets
                        .getInsets(WindowInsets.Type.navigationBars())
                        .bottom

            } else {
                val currentDisplay = try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        display
                    } else {
                        windowManager.defaultDisplay
                    }
                } catch (e: NoSuchMethodError) {
                    windowManager.defaultDisplay
                }

                val appUsableSize = Point()
                val realScreenSize = Point()
                currentDisplay?.apply {
                    getSize(appUsableSize)
                    getRealSize(realScreenSize)
                }

                // navigation bar on the side
                if (appUsableSize.x < realScreenSize.x) {
                    return realScreenSize.x - appUsableSize.x
                }

                // navigation bar at the bottom
                return if (appUsableSize.y < realScreenSize.y) {
                    realScreenSize.y - appUsableSize.y
                } else 0
            }
        }

}
