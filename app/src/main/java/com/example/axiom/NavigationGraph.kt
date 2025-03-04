package com.example.axiom

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

object Destinations {
    const val WELCOME_SCREEN = "welcome"
    const val INSURANCE_SCREEN = "insurance"
    const val TRIAGE_SCREEN = "triage"
    const val MEDICATION_REMINDER_SCREEN = "medication_reminder"
}

@Composable
fun AxiomNavGraph(
    navController: NavHostController = rememberNavController(),
    startDestination: String = Destinations.WELCOME_SCREEN
) {
    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Destinations.WELCOME_SCREEN) {
            WelcomeScreen(
                onInsuranceClick = { navController.navigate(Destinations.INSURANCE_SCREEN) },
                onTriageClick = { navController.navigate(Destinations.TRIAGE_SCREEN) },
                onMedicationReminderClick = { navController.navigate(Destinations.MEDICATION_REMINDER_SCREEN) }
            )
        }
        composable(Destinations.INSURANCE_SCREEN) {
            InsuranceScreen(
                onBackClick = { navController.navigateUp() }
            )
        }
        composable(Destinations.TRIAGE_SCREEN) {
            TriageScreen(
                onBackClick = { navController.navigateUp() }
            )
        }
        // You can add the medication reminder screen later
        composable(Destinations.MEDICATION_REMINDER_SCREEN) {
            // Placeholder for now - you'll implement this later
            InsuranceScreen(onBackClick = { navController.navigateUp() }) // Temporary placeholder
        }
    }
}