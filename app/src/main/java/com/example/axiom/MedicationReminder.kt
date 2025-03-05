package com.example.axiom

import android.Manifest
import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import java.text.SimpleDateFormat
import java.util.*
import kotlin.random.Random

class MedicationReminder : ComponentActivity() {
    // Create the permission launcher at the Activity level
    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        if (isGranted) {
            // Permission granted
            Toast.makeText(this, "Notifications permission granted", Toast.LENGTH_SHORT).show()
        } else {
            // Permission denied
            Toast.makeText(this,
                "Medication reminders require notification permission",
                Toast.LENGTH_LONG).show()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Create notification channel for reminders
        createNotificationChannel()

        // Check notification permission if needed
        if (Build.VERSION.SDK_INT >= 33) {
            if (ContextCompat.checkSelfPermission(
                    this,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED) {
                requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        }

        // Check if we're opening from a notification
        val medicationId = intent.getIntExtra("MEDICATION_ID", -1)
        val openFromNotification = intent.action == "OPEN_MEDICATION_DETAILS" ||
                intent.getBooleanExtra("OPEN_MEDICATION_TAB", false)

        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    MedicationReminderScreen(
                        onBackClick = { finish() },
                        highlightMedicationId = if (openFromNotification) medicationId else null
                    )
                }
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Medication Reminder Channel"
            val descriptionText = "Channel for medication reminders"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel("medication_reminder_channel", name, importance).apply {
                description = descriptionText
            }

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}

data class MedicationRemindItem(
    val id: Int,
    val medicationName: String,
    val dosage: String,
    val time: Calendar,
    val isActive: Boolean = true
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MedicationReminderScreen(
    onBackClick: () -> Unit = {},
    highlightMedicationId: Int? = null
) {
    val context = LocalContext.current

    // State for medications list
    var medicationsList by rememberSaveable { mutableStateOf(listOf<MedicationRemindItem>()) }

    // State for dialog
    var showAddDialog by remember { mutableStateOf(false) }

    // State for new medication
    var newMedicationName by remember { mutableStateOf("") }
    var newDosage by remember { mutableStateOf("") }
    var selectedHour by remember { mutableStateOf(8) }
    var selectedMinute by remember { mutableStateOf(0) }

    // Remove the problematic code that was using rememberSaveable with ActivityResultContracts.RequestPermission

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Medication Reminders") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = "Back"
                        )
                    }
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { showAddDialog = true }
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add Reminder")
            }
        }
    ) { paddingValues ->
        // Rest of your existing code remains the same
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp)
        ) {
            // Existing code continues... {
            if (medicationsList.isEmpty()) {
                // Empty state
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(16.dp),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        Text(
                            text = "No medication reminders yet",
                            style = MaterialTheme.typography.bodyLarge
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Tap + to add a reminder",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            } else {
                // List of medications
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(medicationsList) { medication ->
                        MedicationReminderItem(
                            medication = medication,
                            onDelete = {
                                medicationsList = medicationsList.filter { it.id != medication.id }
                                // Cancel alarm when deleting
                                cancelMedicationReminder(context, medication.id)
                            },
                            onToggleActive = { isActive ->
                                medicationsList = medicationsList.map {
                                    if (it.id == medication.id) it.copy(isActive = isActive) else it
                                }

                                if (isActive) {
                                    // Re-schedule the reminder
                                    scheduleMedicationReminder(context, medication)
                                } else {
                                    // Cancel the reminder
                                    cancelMedicationReminder(context, medication.id)
                                }
                            }
                        )
                    }
                }
            }

            // Add Medication Dialog
            if (showAddDialog) {
                AlertDialog(
                    onDismissRequest = { showAddDialog = false },
                    title = { Text("Add Medication Reminder") },
                    text = {
                        Column {
                            TextField(
                                value = newMedicationName,
                                onValueChange = { newMedicationName = it },
                                label = { Text("Medication Name") },
                                modifier = Modifier.fillMaxWidth()
                            )

                            Spacer(modifier = Modifier.height(8.dp))

                            TextField(
                                value = newDosage,
                                onValueChange = { newDosage = it },
                                label = { Text("Dosage (e.g., 1 pill)") },
                                modifier = Modifier.fillMaxWidth()
                            )

                            Spacer(modifier = Modifier.height(16.dp))

                            Text("Set reminder time:")

                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                // Hours picker
                                Column {
                                    Text("Hour")
                                    NumberPicker(
                                        value = selectedHour,
                                        onValueChange = { selectedHour = it },
                                        range = 0..23
                                    )
                                }

                                // Minutes picker
                                Column {
                                    Text("Minute")
                                    NumberPicker(
                                        value = selectedMinute,
                                        onValueChange = { selectedMinute = it },
                                        range = 0..59
                                    )
                                }
                            }
                        }
                    },
                    confirmButton = {
                        Button(
                            onClick = {
                                if (newMedicationName.isBlank()) {
                                    Toast.makeText(context, "Please enter medication name", Toast.LENGTH_SHORT).show()
                                    return@Button
                                }

                                val time = Calendar.getInstance().apply {
                                    set(Calendar.HOUR_OF_DAY, selectedHour)
                                    set(Calendar.MINUTE, selectedMinute)
                                    set(Calendar.SECOND, 0)

                                    // If time is in the past, schedule for tomorrow
                                    if (before(Calendar.getInstance())) {
                                        add(Calendar.DAY_OF_MONTH, 1)
                                    }
                                }

                                val newMedication = MedicationRemindItem(
                                    id = Random.nextInt(),
                                    medicationName = newMedicationName,
                                    dosage = newDosage,
                                    time = time
                                )

                                medicationsList = medicationsList + newMedication

                                // Schedule the reminder
                                scheduleMedicationReminder(context, newMedication)

                                // Reset dialog fields
                                newMedicationName = ""
                                newDosage = ""
                                selectedHour = 8
                                selectedMinute = 0
                                showAddDialog = false
                            }
                        ) {
                            Text("Add")
                        }
                    },
                    dismissButton = {
                        TextButton(
                            onClick = { showAddDialog = false }
                        ) {
                            Text("Cancel")
                        }
                    }
                )
            }
        }
    }
}

@Composable
fun NumberPicker(
    value: Int,
    onValueChange: (Int) -> Unit,
    range: IntRange
) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.padding(8.dp)
    ) {
        Button(
            onClick = {
                if (value > range.first) onValueChange(value - 1)
            },
            enabled = value > range.first
        ) {
            Text("-")
        }

        Text(
            text = value.toString().padStart(2, '0'),
            modifier = Modifier.padding(horizontal = 16.dp)
        )

        Button(
            onClick = {
                if (value < range.last) onValueChange(value + 1)
            },
            enabled = value < range.last
        ) {
            Text("+")
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MedicationReminderItem(
    medication: MedicationRemindItem,
    onDelete: () -> Unit,
    onToggleActive: (Boolean) -> Unit
) {
    val timeFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())

    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(
                modifier = Modifier.weight(1f)
            ) {
                Text(
                    text = medication.medicationName,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "Dosage: ${medication.dosage}",
                    style = MaterialTheme.typography.bodyMedium
                )

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "Time: ${timeFormat.format(medication.time.time)}",
                    style = MaterialTheme.typography.bodySmall
                )
            }

            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Switch(
                    checked = medication.isActive,
                    onCheckedChange = onToggleActive
                )

                IconButton(onClick = onDelete) {
                    Icon(
                        imageVector = Icons.Default.Delete,
                        contentDescription = "Delete",
                        tint = Color.Red
                    )
                }
            }
        }
    }
}

// Function to schedule medication reminder
private fun scheduleMedicationReminder(context: Context, medication: MedicationRemindItem) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(context, MedicationReminderReceiver::class.java).apply {
        putExtra("MEDICATION_ID", medication.id)
        putExtra("MEDICATION_NAME", medication.medicationName)
        putExtra("MEDICATION_DOSAGE", medication.dosage)
    }

    val pendingIntent = PendingIntent.getBroadcast(
        context,
        medication.id,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
        if (alarmManager.canScheduleExactAlarms()) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                medication.time.timeInMillis,
                pendingIntent
            )
        } else {
            Toast.makeText(
                context,
                "Please allow exact alarm permission for reliable reminders",
                Toast.LENGTH_LONG
            ).show()

            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                medication.time.timeInMillis,
                pendingIntent
            )
        }
    } else {
        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            medication.time.timeInMillis,
            pendingIntent
        )
    }

    Toast.makeText(
        context,
        "Reminder set for ${SimpleDateFormat("hh:mm a", Locale.getDefault()).format(medication.time.time)}",
        Toast.LENGTH_SHORT
    ).show()
}

// Function to cancel medication reminder
private fun cancelMedicationReminder(context: Context, medicationId: Int) {
    val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
    val intent = Intent(context, MedicationReminderReceiver::class.java)
    val pendingIntent = PendingIntent.getBroadcast(
        context,
        medicationId,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    alarmManager.cancel(pendingIntent)
    pendingIntent.cancel()
}