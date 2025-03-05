package com.example.axiom

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

// Keep only one Welcome class
class Welcome : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            com.example.axiom.ui.theme.AxiomTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    AxiomNavGraph()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun WelcomeScreen(
    onInsuranceClick: () -> Unit,
    onTriageClick: () -> Unit,
    onMedicationReminderClick: () -> Unit,
    onAppointmentTrackerClick: () -> Unit
) {
    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("Axiom Health") }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Welcome header
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(vertical = 16.dp)
            ) {
                Text(
                    text = "Welcome to Axiom",
                    style = MaterialTheme.typography.headlineLarge
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = "Your personal healthcare companion",
                    style = MaterialTheme.typography.bodyLarge,
                    textAlign = TextAlign.Center,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
            }

            // Menu options
            ElevatedCard(
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    Text(
                        text = "Services",
                        style = MaterialTheme.typography.titleMedium
                    )

                    // Insurance Button
                    Button(
                        onClick = onInsuranceClick,
                        modifier = Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(vertical = 16.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Shield,
                            contentDescription = null,
                            modifier = Modifier.padding(end = 8.dp)
                        )
                        Text("Insurance")
                    }

                    // Triage Button
                    Button(
                        onClick = onTriageClick,
                        modifier = Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(vertical = 16.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.HealthAndSafety,
                            contentDescription = null,
                            modifier = Modifier.padding(end = 8.dp)
                        )
                        Text("Triage")
                    }

                    // Medication Reminder Button
                    Button(
                        onClick = onMedicationReminderClick,
                        modifier = Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(vertical = 16.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.MedicalServices,
                            contentDescription = null,
                            modifier = Modifier.padding(end = 8.dp)
                        )
                        Text("Medication Reminder")
                    }

                    // Appointment Tracker Button
                    Button(
                        onClick = onAppointmentTrackerClick,
                        modifier = Modifier.fillMaxWidth(),
                        contentPadding = PaddingValues(vertical = 16.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.CalendarToday,
                            contentDescription = null,
                            modifier = Modifier.padding(end = 8.dp)
                        )
                        Text("Appointment Tracker")
                    }
                }
            }
        }
    }
}

@Composable
fun AxiomNavGraph() {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "welcome") {
        composable("welcome") {
            WelcomeScreen(
                onInsuranceClick = { navController.navigate("insurance") },
                onTriageClick = { navController.navigate("triage") },
                onMedicationReminderClick = { navController.navigate("medication_reminder") },
                onAppointmentTrackerClick = { navController.navigate("appointment_tracker") }
            )
        }

        composable("insurance") {
            InsuranceScreen(onBackClick = { navController.navigateUp() })
        }

        composable("triage") {
            TriageScreen(onBackClick = { navController.navigateUp() })
        }

        composable("medication_reminder") {
            MedicationReminderScreen(onBackClick = { navController.navigateUp() })
        }

        composable("appointment_tracker") {
            AppointmentTrackerScreen(onBackClick = { navController.navigateUp() })
        }
    }
}

@Preview(showBackground = true)
@Composable
fun WelcomeScreenPreview() {
    MaterialTheme {
        WelcomeScreen(
            onInsuranceClick = {},
            onTriageClick = {},
            onMedicationReminderClick = {},
            onAppointmentTrackerClick = {}
        )
    }
}