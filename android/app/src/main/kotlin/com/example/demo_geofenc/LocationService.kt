package com.example.demo_geofenc

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody
import org.json.JSONObject
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Date

class LocationService : Service() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private val client = OkHttpClient()
    private val TAG = "LocationService"

    override fun onCreate() {
        super.onCreate()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult) {
                locationResult ?: return
                for (location in locationResult.locations) {
                    Log.d(TAG, "Location: ${location.latitude}, ${location.longitude}")
                    sendLocationToApi(location.latitude, location.longitude)
                }
            }
        }
        startLocationUpdates()
    }

    private fun startLocationUpdates() {
        val locationRequest = LocationRequest.create().apply {
            interval = 5000 // Set the interval to 5 seconds
            fastestInterval = 5000 // Set the fastest interval to 5 seconds
            priority = LocationRequest.PRIORITY_HIGH_ACCURACY
        }

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, null)
        Log.d(TAG, "Location updates started with interval of 5 seconds")
    }

    private fun sendLocationToApi(latitude: Double, longitude: Double) {
        val JSON = "application/json; charset=utf-8".toMediaTypeOrNull()
        val locationData = JSONObject().apply {
            put("latitude", latitude)
            put("longitude", longitude)
            put("Locationdatetime", SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(Date()))
            put("LocationAddress", "Background Service from Phone when app was closed")
            put("City", "Surat")
            put("Country", "India")
            put("PostalCode", "395005")
        }

        val body = RequestBody.create(JSON, locationData.toString())
        val request = Request.Builder()
                .url("http://116.72.8.100:2202/api/CommanAPI/SaveLocation")  // Replace with your API endpoint
                .post(body)
                .build()

        client.newCall(request).enqueue(object : okhttp3.Callback {
            override fun onFailure(call: okhttp3.Call, e: IOException) {
                Log.e(TAG, "API request failed: $e")
            }

            override fun onResponse(call: okhttp3.Call, response: okhttp3.Response) {
                if (!response.isSuccessful) {
                    Log.e(TAG, "Unexpected response code: ${response.code}")
                } else {
                    Log.d(TAG, "Location sent to API successfully: ${response.body?.string()}")
                }
            }
        })
        Log.d(TAG, "API request sent with data: $locationData")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        fusedLocationClient.removeLocationUpdates(locationCallback)
        Log.d(TAG, "Location updates stopped")
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
