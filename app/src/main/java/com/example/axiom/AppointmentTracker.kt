package com.example.axiom

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import java.text.SimpleDateFormat
import java.util.*

// Data class for appointment
data class Appointment(
    val id: Int,
    val doctorName: String,
    val department: String,
    val date: Date,
    val location: String,
    val notes: String = "",
    val isPast: Boolean = false
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppointmentTrackerScreen(onBackClick: () -> Unit) {
    // Dummy data for appointments
    val initialAppointments = remember {
        listOf(
            Appointment(
                id = 1,
                doctorName = "Dr. Sarah Johnson",
                department = "Cardiology",
                date = Calendar.getInstance().apply {
                    add(Calendar.DAY_OF_MONTH, 5)
                    set(Calendar.HOUR_OF_DAY, 10)
                    set(Calendar.MINUTE, 30)
                }.time,
                location = "Main Hospital, Room 305",
                notes = "Annual heart checkup"
            ),
            Appointment(
                id = 2,
                doctorName = "Dr. Michael Chen",
                department = "Neurology",
                date = Calendar.getInstance().apply {
                    add(Calendar.DAY_OF_MONTH, -10)
                    set(Calendar.HOUR_OF_DAY, 14)
                    set(Calendar.MINUTE, 0)
                }.time,
                location = "Medical Tower, Floor 7",
                notes = "Follow-up on treatment",
                isPast = true
            ),
            Appointment(
                id = 3,
                doctorName = "Dr. Emily Rodriguez",
                department = "Dermatology",
                date = Calendar.getInstance().apply {
                    add(Calendar.DAY_OF_MONTH, 2)
                    set(Calendar.HOUR_OF_DAY, 9)
                    set(Calendar.MINUTE, 15)
                }.time,
                location = "Outpatient Clinic, Room 112",
                notes = "Skin condition assessment"
            )
        )
    }

    // State for appointment list
    var appointments by remember { mutableStateOf(initialAppointments) }

    // State for search query
    var searchQuery by remember { mutableStateOf("") }

    // State for selected appointment
    var selectedAppointment by remember { mutableStateOf<Appointment?>(null) }

    // State for showing appointment details
    var showDetails by remember { mutableStateOf(false) }

    // Filtered appointments based on search query
    val filteredAppointments = remember(appointments, searchQuery) {
        if (searchQuery.isEmpty()) {
            appointments
        } else {
            appointments.filter {
                it.doctorName.contains(searchQuery, ignoreCase = true) ||
                        it.department.contains(searchQuery, ignoreCase = true)
            }
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Appointment Tracker") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = {
                        // Sort appointments by date (most recent first)
                        appointments = appointments.sortedBy { it.date }
                    }) {
                        Icon(Icons.Default.Sort, contentDescription = "Sort")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Search bar
            OutlinedTextField(
                value = searchQuery,
                onValueChange = { searchQuery = it },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                label = { Text("Search appointments") },
                leadingIcon = {
                    Icon(Icons.Default.Search, contentDescription = "Search")
                },
                singleLine = true
            )

            // Appointments list
            LazyColumn(
                modifier = Modifier.fillMaxWidth(),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(filteredAppointments) { appointment ->
                    AppointmentCard(
                        appointment = appointment,
                        onClick = {
                            selectedAppointment = appointment
                            showDetails = true
                        },
                        onEdit = {
                            // In a real app, this would open an edit screen
                            // For now, just show a message
                        },
                        onDelete = {
                            // Remove the appointment from the list
                            appointments = appointments.filter { it.id != appointment.id }
                        }
                    )
                }
            }

            // Appointment details dialog
            if (showDetails && selectedAppointment != null) {
                AppointmentDetailsDialog(
                    appointment = selectedAppointment!!,
                    onDismiss = { showDetails = false }
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AppointmentCard(
    appointment: Appointment,
    onClick: () -> Unit,
    onEdit: () -> Unit,
    onDelete: () -> Unit
) {
    val dateFormat = SimpleDateFormat("EEE, MMM dd, yyyy - hh:mm a", Locale.getDefault())

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        colors = CardDefaults.cardColors(
            containerColor = if (appointment.isPast)
                MaterialTheme.colorScheme.surfaceVariant
            else
                MaterialTheme.colorScheme.surface
        )
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = appointment.doctorName,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )

                Badge(
                    containerColor = if (appointment.isPast) Color.Gray else Color(0xFF4CAF50)
                ) {
                    Text(
                        text = if (appointment.isPast) "Past" else "Upcoming",
                        color = Color.White,
                        modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = appointment.department,
                style = MaterialTheme.typography.bodyMedium
            )

            Spacer(modifier = Modifier.height(8.dp))

            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.DateRange,
                    contentDescription = "Date",
                    modifier = Modifier.size(16.dp)
                )
                Text(
                    text = dateFormat.format(appointment.date),
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.padding(start = 4.dp)
                )
            }

            Spacer(modifier = Modifier.height(4.dp))

            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.LocationOn,
                    contentDescription = "Location",
                    modifier = Modifier.size(16.dp)
                )
                Text(
                    text = appointment.location,
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier.padding(start = 4.dp)
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.End
            ) {
                IconButton(onClick = onEdit) {
                    Icon(
                        imageVector = Icons.Default.Edit,
                        contentDescription = "Edit"
                    )
                }

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

@Composable
fun AppointmentDetailsDialog(
    appointment: Appointment,
    onDismiss: () -> Unit
) {
    val dateFormat = SimpleDateFormat("EEEE, MMMM dd, yyyy", Locale.getDefault())
    val timeFormat = SimpleDateFormat("hh:mm a", Locale.getDefault())

    Dialog(onDismissRequest = onDismiss) {
        Card(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            elevation = CardDefaults.cardElevation(8.dp)
        ) {
            Column(
                modifier = Modifier.padding(16.dp)
            ) {
                Text(
                    text = "Appointment Details",
                    style = MaterialTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold
                )

                Spacer(modifier = Modifier.height(16.dp))

                LabeledText(label = "Doctor", value = appointment.doctorName)
                LabeledText(label = "Department", value = appointment.department)
                LabeledText(label = "Date", value = dateFormat.format(appointment.date))
                LabeledText(label = "Time", value = timeFormat.format(appointment.date))
                LabeledText(label = "Location", value = appointment.location)

                if (appointment.notes.isNotEmpty()) {
                    LabeledText(label = "Notes", value = appointment.notes)
                }

                Spacer(modifier = Modifier.height(16.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End
                ) {
                    TextButton(onClick = onDismiss) {
                        Text("Close")
                    }
                }
            }
        }
    }
}

@Composable
fun LabeledText(label: String, value: String) {
    Column(modifier = Modifier.padding(vertical = 4.dp)) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyLarge
        )
    }
}