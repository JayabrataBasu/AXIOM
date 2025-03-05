package com.example.axiom

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
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
                .fillMaxSize()
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

            // Coverage Information
            CoverageInformation()

            // Insurance Details Form
            InsuranceDetailsForm(
                policyNumber = policyNumber,
                onPolicyNumberChange = { policyNumber = it },
                memberName = memberName,
                onMemberNameChange = { memberName = it },
                insuranceProvider = insuranceProvider,
                onInsuranceProviderChange = { insuranceProvider = it }
            )

            // Claims Section
            ClaimsSection()

            Spacer(modifier = Modifier.height(16.dp))

            Button(
                onClick = { /* Save data */ },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("Save Insurance Information")
            }
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
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.primaryContainer
        )
    ) {
        Column(
            modifier = Modifier
                .padding(16.dp)
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(
                    text = insuranceProvider,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
                Icon(
                    imageVector = Icons.Default.LocalHospital,
                    contentDescription = null,
                    tint = MaterialTheme.colorScheme.primary
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            Text(
                text = memberName,
                style = MaterialTheme.typography.titleLarge
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Policy: $policyNumber",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onPrimaryContainer.copy(alpha = 0.7f)
            )

            Spacer(modifier = Modifier.height(16.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Column {
                    Text(
                        text = "Valid From",
                        style = MaterialTheme.typography.bodySmall
                    )
                    Text(
                        text = "01/01/2023",
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Bold
                    )
                }

                Column {
                    Text(
                        text = "Valid Until",
                        style = MaterialTheme.typography.bodySmall
                    )
                    Text(
                        text = "12/31/2023",
                        style = MaterialTheme.typography.bodyMedium,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

@Composable
fun CoverageInformation() {
    ElevatedCard(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Coverage Information",
                style = MaterialTheme.typography.titleMedium
            )

            Spacer(modifier = Modifier.height(8.dp))

            CoverageItem(
                title = "Primary Care",
                coverage = "Covered with $30 co-pay"
            )

            CoverageItem(
                title = "Specialist",
                coverage = "Covered with $50 co-pay"
            )

            CoverageItem(
                title = "Emergency",
                coverage = "Covered with $250 co-pay"
            )

            CoverageItem(
                title = "Hospitalization",
                coverage = "20% co-insurance after deductible"
            )

            CoverageItem(
                title = "Prescription Drugs",
                coverage = "Tier 1: $10, Tier 2: $30, Tier 3: $50"
            )
        }
    }
}

@Composable
fun CoverageItem(title: String, coverage: String) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = title,
            style = MaterialTheme.typography.bodyMedium
        )
        Text(
            text = coverage,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.primary
        )
    }

    Divider(
        modifier = Modifier.padding(vertical = 4.dp),
        color = MaterialTheme.colorScheme.outlineVariant
    )
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
    ElevatedCard(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = "Insurance Details",
                style = MaterialTheme.typography.titleMedium
            )

            OutlinedTextField(
                value = policyNumber,
                onValueChange = onPolicyNumberChange,
                label = { Text("Policy Number") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = memberName,
                onValueChange = onMemberNameChange,
                label = { Text("Member Name") },
                modifier = Modifier.fillMaxWidth()
            )

            OutlinedTextField(
                value = insuranceProvider,
                onValueChange = onInsuranceProviderChange,
                label = { Text("Insurance Provider") },
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
}

@Composable
fun ClaimsSection() {
    ElevatedCard(
        modifier = Modifier.fillMaxWidth()
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            Text(
                text = "Recent Claims",
                style = MaterialTheme.typography.titleMedium
            )

            Spacer(modifier = Modifier.height(8.dp))

            if (true) { // Replace with actual claims check
                ClaimItem(
                    date = "10/15/2023",
                    provider = "City Medical Center",
                    amount = "$350.00",
                    status = "Approved"
                )

                ClaimItem(
                    date = "09/28/2023",
                    provider = "Primary Care Clinic",
                    amount = "$120.00",
                    status = "Pending"
                )

                ClaimItem(
                    date = "08/14/2023",
                    provider = "Pharmacy",
                    amount = "$45.75",
                    status = "Approved"
                )
            } else {
                Text(
                    text = "No recent claims found",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.outline
                )
            }

            Spacer(modifier = Modifier.height(8.dp))

            OutlinedButton(
                onClick = { /* Navigate to claims history */ },
                modifier = Modifier.fillMaxWidth(),
                border = BorderStroke(1.dp, MaterialTheme.colorScheme.primary)
            ) {
                Text("View All Claims")
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
    val statusColor = when (status) {
        "Approved" -> Color(0xFF4CAF50)
        "Pending" -> Color(0xFFFFC107)
        "Rejected" -> Color(0xFFF44336)
        else -> MaterialTheme.colorScheme.outline
    }

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = provider,
                style = MaterialTheme.typography.bodyMedium,
                fontWeight = FontWeight.Bold
            )

            Text(
                text = date,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.outline
            )
        }

        Row(
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.AttachMoney,
                contentDescription = null,
                modifier = Modifier.size(16.dp),
                tint = MaterialTheme.colorScheme.primary
            )

            Text(
                text = amount,
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary
            )
        }

        Spacer(modifier = Modifier.width(16.dp))

        Box(
            modifier = Modifier
                .background(
                    color = statusColor.copy(alpha = 0.1f),
                    shape = RoundedCornerShape(4.dp)
                )
                .padding(horizontal = 8.dp, vertical = 4.dp)
        ) {
            Text(
                text = status,
                style = MaterialTheme.typography.bodySmall,
                color = statusColor
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
    com.example.axiom.ui.theme.AxiomTheme {
        InsuranceScreen()
    }
}