package com.example.peduli_beacon

import com.umair.beacons_plugin.BeaconsPlugin
import io.flutter.embedding.android.FlutterActivity
import android.bluetooth.BluetoothAdapter
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "bluetooth_On_Off"
    lateinit var bluetoothAdapter:BluetoothAdapter

    override fun onPause() {
        super.onPause()

        //Start Background service to scan BLE devices
        BeaconsPlugin.startBackgroundService(this)
    }

    override fun onResume() {
        super.onResume()

        //Stop Background service, app is in foreground
        BeaconsPlugin.stopBackgroundService(this)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method.equals("setBtOn")) {
                val statusBluetooth: String = setBtOn()
                result.success(statusBluetooth)
            } else if (call.method.equals("setBtOff")) {
                val statusBluetooth: String = setBtOff()
                result.success(statusBluetooth)
            }
        }
    }

    private fun setBtOn(): String {
        val status: String
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (!bluetoothAdapter.isEnabled) {
            bluetoothAdapter.enable()
        }
        status = "Bluetooth On"
        return status
    }

    private fun setBtOff(): String {
        val status: String
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter.isEnabled) {
            bluetoothAdapter.disable()
        }
        status = "Bluetooth Off"
        return status
    }
}
