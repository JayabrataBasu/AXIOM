package com.example.axiom

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat

class MedicationReminderReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val medicationId = intent.getIntExtra("MEDICATION_ID", 0)
        val medicationName = intent.getStringExtra("MEDICATION_NAME") ?: "Medication"
        val medicationDosage = intent.getStringExtra("MEDICATION_DOSAGE") ?: ""

        // Create an intent to open the medication details when notification is tapped
        val contentIntent = Intent(context, MedicationReminder::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            putExtra("MEDICATION_ID", medicationId)
            putExtra("OPEN_MEDICATION_TAB", true)  // Flag to indicate we want to show medication details
            action = "OPEN_MEDICATION_DETAILS"  // Specific action to distinguish from other intents
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            medicationId,
            contentIntent,
            PendingIntent.FLAG_IMMUTABLE
        )

        // Build the notification
        val builder = NotificationCompat.Builder(context, "medication_reminder_channel")
            .setSmallIcon(R.drawable.ic_launcher_foreground)
            .setContentTitle("Medication Reminder")
            .setContentText("Time to take $medicationName $medicationDosage")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        // Optional: Add a "Taken" action button
        val takenIntent = Intent(context, MedicationTakenReceiver::class.java).apply {
            putExtra("MEDICATION_ID", medicationId)
        }

        val takenPendingIntent = PendingIntent.getBroadcast(
            context,
            medicationId + 1000, // Different request code to avoid conflict
            takenIntent,
            PendingIntent.FLAG_IMMUTABLE
        )

        builder.addAction(0, "Taken", takenPendingIntent)

        // Show the notification - with permission check
        val notificationManager = NotificationManagerCompat.from(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) == PackageManager.PERMISSION_GRANTED) {
                notificationManager.notify(medicationId, builder.build())
            }
            // If permission not granted, we can't show notification
        } else {
            notificationManager.notify(medicationId, builder.build())
        }

        // Schedule next day's reminder (for recurring medications)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        val nextAlarmIntent = Intent(context, MedicationReminderReceiver::class.java).apply {
            putExtra("MEDICATION_ID", medicationId)
            putExtra("MEDICATION_NAME", medicationName)
            putExtra("MEDICATION_DOSAGE", medicationDosage)
        }

        val nextPendingIntent = PendingIntent.getBroadcast(
            context,
            medicationId,
            nextAlarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Set next alarm for same time tomorrow
        val calendar = java.util.Calendar.getInstance().apply {
            add(java.util.Calendar.DAY_OF_YEAR, 1)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
            alarmManager.setAndAllowWhileIdle(
                android.app.AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                nextPendingIntent
            )
        } else {
            alarmManager.setExactAndAllowWhileIdle(
                android.app.AlarmManager.RTC_WAKEUP,
                calendar.timeInMillis,
                nextPendingIntent
            )
        }
    }
}

// Receiver for the "Taken" action
class MedicationTakenReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val medicationId = intent.getIntExtra("MEDICATION_ID", 0)

        // Cancel the notification
        val notificationManager = NotificationManagerCompat.from(context)
        notificationManager.cancel(medicationId)
    }
}