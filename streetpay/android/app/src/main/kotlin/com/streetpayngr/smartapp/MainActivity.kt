package com.streetpayngr.smartapp

import android.util.Log
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        try {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        } catch (e: IllegalStateException) {
            Log.w("MainActivity", "Caught IllegalStateException in onRequestPermissionsResult: ${e.message}")
        } catch (e: Exception) {
            Log.w("MainActivity", "Caught Exception in onRequestPermissionsResult: ${e.message}")
        }
    }
}
