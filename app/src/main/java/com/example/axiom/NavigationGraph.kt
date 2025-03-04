// Create this in a new file called NavigationGraph.kt
package com.example.axiom

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

object Destinations {
    const val WELCOME_SCREEN = "welcome"
    const val INSURANCE_SCREEN = "insurance"
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
                onTriageClick = { /* TODO */ },
                onMedicationReminderClick = { /* TODO */ }
            )
        }
        composable(Destinations.INSURANCE_SCREEN) {
            InsuranceScreen(
                onBackClick = { navController.navigateUp() }
            )
        }
    }
}