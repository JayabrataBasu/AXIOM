package com.example.axiom

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import android.widget.Toast
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.platform.LocalContext
import com.example.axiom.api.ApiClient
import com.example.axiom.model.InsuranceDto
import com.example.axiom.model.UserDto
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.AttachMoney
import androidx.compose.material.icons.filled.LocalHospital
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.example.axiom.ui.theme.AxiomTheme


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InsuranceScreen(onBackClick: () -> Unit = {}) {
    var policyNumber by remember { mutableStateOf("POL-123456789") }
    var memberName by remember { mutableStateOf("John Doe") }
    var insuranceProvider by remember { mutableStateOf("HealthGuard Insurance") }

    // Add date-related variables
    var validFrom by remember { mutableStateOf(LocalDate.now()) }
    var validUntil by remember { mutableStateOf(LocalDate.now().plusYears(1)) }

    // State for API integration
    var userId by remember { mutableStateOf<Long?>(null) }
    var isLoading by remember { mutableStateOf(false) }
    var errorMessage by remember { mutableStateOf<String?>(null) }
    var successMessage by remember { mutableStateOf<String?>(null) }
    val coroutineScope = rememberCoroutineScope()
    val context = LocalContext.current

    fun saveInsuranceForUser(userId: Long?) {
        if (userId == null) {
            errorMessage = "User ID is missing"
            isLoading = false
            return
        }

        val dateFormatter = DateTimeFormatter.ISO_LOCAL_DATE
        val insurance = InsuranceDto(
            policyNumber = policyNumber,
            provider = insuranceProvider,
            validFrom = validFrom.format(dateFormatter),
            validUntil = validUntil.format(dateFormatter)
        )

        coroutineScope.launch {
            try {
                val response = withContext(Dispatchers.IO) {
                    ApiClient.apiService.createInsurance(userId, insurance).execute()
                }
                withContext(Dispatchers.Main) {
                    isLoading = false
                    if (response.isSuccessful) {
                        successMessage = "Insurance information saved successfully!"
                        Toast.makeText(context, successMessage, Toast.LENGTH_LONG).show()
                    } else {
                        errorMessage = "Error saving insurance: ${response.errorBody()?.string() ?: "Unknown error"}"
                        Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show()
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    isLoading = false
                    errorMessage = "Error: ${e.message ?: "Unknown error"}"
                    Toast.makeText(context, errorMessage, Toast.LENGTH_LONG).show()
                }
            }
        }
    }

    // Function to save insurance info by first creating a user if needed
    fun saveInsuranceInfo() {
        isLoading = true
        errorMessage = null
        successMessage = null

        // First create or get a user
        val user = UserDto(
            name = memberName,
            email = "$memberName@example.com".replace(" ", "").lowercase()
        )

        coroutineScope.launch {
            try {
                val userResponse = withContext(Dispatchers.IO) {
                    ApiClient.apiService.createUser(user).execute()
                }

                if (userResponse.isSuccessful && userResponse.body() != null) {
                    val createdUser = userResponse.body()!!
                    userId = createdUser.id
                    saveInsuranceForUser(createdUser.id)
                } else {
                    withContext(Dispatchers.Main) {
                        errorMessage = "Error creating user: ${userResponse.errorBody()?.string() ?: "Unknown error"}"
                        isLoading = false
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    errorMessage = "Error: ${e.message ?: "Unknown error"}"
                    isLoading = false
                }
            }
        }
    }

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("Insurance Information") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = "Navigate back"
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .padding(paddingValues)
                .padding(16.dp)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Insurance Card
            InsuranceCard(
                policyNumber = policyNumber,
                memberName = memberName,
                insuranceProvider = insuranceProvider
            )

            // Insurance Details Form
            InsuranceDetailsForm(
                policyNumber = policyNumber,
                onPolicyNumberChange = { policyNumber = it },
                memberName = memberName,
                onMemberNameChange = { memberName = it },
                insuranceProvider = insuranceProvider,
                onInsuranceProviderChange = { insuranceProvider = it }
            )

            // Coverage Information
            CoverageInformation()

            // Claims Section
            ClaimsSection()

            // Loading indicator
            if (isLoading) {
                LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
            }

            // Error message
            errorMessage?.let {
                Text(
                    text = it,
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier
                        .background(
                            color = MaterialTheme.colorScheme.errorContainer,
                            shape = RoundedCornerShape(4.dp)
                        )
                        .padding(8.dp)
                        .fillMaxWidth()
                )
            }

            // Success message
            successMessage?.let {
                Text(
                    text = it,
                    color = Color(0xFF1B5E20),
                    style = MaterialTheme.typography.bodyMedium,
                    modifier = Modifier
                        .background(
                            color = Color(0xFFDCEDC8),
                            shape = RoundedCornerShape(4.dp)
                        )
                        .padding(8.dp)
                        .fillMaxWidth()
                )
            }

            // Save button
            Button(
                onClick = { saveInsuranceInfo() },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading
            ) {
                Text("Save Insurance Information")
            }

            Spacer(modifier = Modifier.height(16.dp))
        }
    }
}

@Composable
fun InsuranceCard(
    policyNumber: String,
    memberName: String,
    insuranceProvider: String
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        ),
        shape = RoundedCornerShape(16.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = insuranceProvider,
                    style = MaterialTheme.typography.titleLarge,
                    color = MaterialTheme.colorScheme.onPrimaryContainer
                )
                Icon(
                    imageVector = Icons.Default.LocalHospital,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.onPrimaryContainer
                )
            }

            Text(
                text = memberName,
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            Text(
                text = "Policy: $policyNumber",
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onPrimaryContainer,
                modifier = Modifier.padding(bottom = 16.dp)
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.End
            ) {
                Text(
                    text = "MEMBER",
                    style = MaterialTheme.typography.labelMedium,
                    color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f)
                )
            }
        }
    }
}

@Composable
fun CoverageInformation() {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Coverage Information",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            CoverageItem(title = "Primary Care Visit", coverage = "$25 copay")
            CoverageItem(title = "Specialist Visit", coverage = "$50 copay")
            CoverageItem(title = "Emergency Room", coverage = "$300 copay")
            CoverageItem(title = "Urgent Care", coverage = "$75 copay")
            CoverageItem(title = "Annual Deductible", coverage = "$1,500")
            CoverageItem(title = "Out-of-Pocket Maximum", coverage = "$7,000")
        }
    }
}

@Composable
fun CoverageItem(title: String, coverage: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = title,
            style = MaterialTheme.typography.bodyMedium
        )
        Text(
            text = coverage,
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.Bold
        )
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun InsuranceDetailsForm(
    policyNumber: String,
    onPolicyNumberChange: (String) -> Unit,
    memberName: String,
    onMemberNameChange: (String) -> Unit,
    insuranceProvider: String,
    onInsuranceProviderChange: (String) -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Insurance Details",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            OutlinedTextField(
                value = policyNumber,
                onValueChange = onPolicyNumberChange,
                label = { Text("Policy Number") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                singleLine = true
            )

            OutlinedTextField(
                value = memberName,
                onValueChange = onMemberNameChange,
                label = { Text("Member Name") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                singleLine = true
            )

            OutlinedTextField(
                value = insuranceProvider,
                onValueChange = onInsuranceProviderChange,
                label = { Text("Insurance Provider") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                singleLine = true
            )
        }
    }
}

@Composable
fun ClaimsSection() {
    Card(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Recent Claims",
                style = MaterialTheme.typography.titleMedium,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            if (true) { // Replace with actual check for claims
                Column {
                    ClaimItem(
                        date = "May 15, 2023",
                        provider = "General Hospital",
                        amount = "$750.00",
                        status = "Paid"
                    )
                    ClaimItem(
                        date = "April 3, 2023",
                        provider = "City Medical Center",
                        amount = "$1,200.00",
                        status = "Processing"
                    )
                    ClaimItem(
                        date = "March 22, 2023",
                        provider = "Dr. Smith Office",
                        amount = "$175.00",
                        status = "Paid"
                    )
                }
            } else {
                Text(
                    text = "No recent claims",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(vertical = 8.dp)
                )
            }
        }
    }
}

@Composable
fun ClaimItem(
    date: String,
    provider: String,
    amount: String,
    status: String
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = date,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )

            Text(
                text = provider,
                style = MaterialTheme.typography.bodyMedium
            )
        }

        Column(
            horizontalAlignment = Alignment.End,
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = amount,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.SemiBold
            )

            Text(
                text = status,
                style = MaterialTheme.typography.bodySmall,
                color = when(status) {
                    "Approved" -> Color(0xFF4CAF50) // Green
                    "Pending" -> Color(0xFFFFA000)  // Amber
                    "Denied" -> Color(0xFFF44336)   // Red
                    else -> MaterialTheme.colorScheme.onSurfaceVariant
                }
            )
        }
    }

    Divider(
        modifier = Modifier.padding(vertical = 4.dp),
        color = MaterialTheme.colorScheme.outlineVariant
    )
}

@Preview(showBackground = true)
@Composable
fun InsuranceScreenPreview() {
    AxiomTheme {
        InsuranceScreen()
    }
}