package com.example.axiom

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.selection.selectable
import androidx.compose.foundation.selection.selectableGroup
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp

class Triage : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    TriageScreen(onBackClick = { finish() })
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TriageScreen(onBackClick: () -> Unit = {}) {
    var currentStep by remember { mutableIntStateOf(0) }
    var selectedSymptoms by remember { mutableStateOf<List<String>>(emptyList()) }
    var severityLevel by remember { mutableStateOf("") }
    var durationDays by remember { mutableIntStateOf(1) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Symptom Triage") },
                navigationIcon = {
                    IconButton(onClick = onBackClick) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = "Back"
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
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            when (currentStep) {
                0 -> SymptomSelection(
                    selectedSymptoms = selectedSymptoms,
                    onSymptomsSelected = { selectedSymptoms = it },
                    onNext = { currentStep = 1 }
                )
                1 -> SeverityAssessment(
                    selectedSymptoms = selectedSymptoms,
                    onSeveritySelected = { severityLevel = it },
                    onDurationChanged = { durationDays = it },
                    onNext = { currentStep = 2 }
                )
                2 -> TriageResults(
                    selectedSymptoms = selectedSymptoms,
                    severityLevel = severityLevel,
                    durationDays = durationDays,
                    onRestart = {
                        currentStep = 0
                        selectedSymptoms = emptyList()
                        severityLevel = ""
                        durationDays = 1
                    }
                )
            }
        }
    }
}

@Composable
fun SymptomSelection(
    selectedSymptoms: List<String>,
    onSymptomsSelected: (List<String>) -> Unit,
    onNext: () -> Unit
) {
    val commonSymptoms = listOf(
        "Fever", "Cough", "Headache", "Sore Throat",
        "Fatigue", "Nausea", "Vomiting", "Abdominal Pain",
        "Chest Pain", "Shortness of Breath", "Dizziness"
    )

    Text(
        text = "Select Your Symptoms",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold
    )

    Text(
        text = "Please select all symptoms you are currently experiencing:",
        style = MaterialTheme.typography.bodyMedium
    )

    Spacer(modifier = Modifier.height(8.dp))

    // Symptom checkboxes
    commonSymptoms.forEach { symptom ->
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Checkbox(
                checked = selectedSymptoms.contains(symptom),
                onCheckedChange = { checked ->
                    val updatedList = if (checked) {
                        selectedSymptoms + symptom
                    } else {
                        selectedSymptoms - symptom
                    }
                    onSymptomsSelected(updatedList)
                }
            )
            Text(
                text = symptom,
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier.padding(start = 8.dp)
            )
        }
    }

    Spacer(modifier = Modifier.height(16.dp))

    Button(
        onClick = onNext,
        enabled = selectedSymptoms.isNotEmpty(),
        modifier = Modifier.fillMaxWidth()
    ) {
        Text("Next")
    }
}

@Composable
fun SeverityAssessment(
    selectedSymptoms: List<String>,
    onSeveritySelected: (String) -> Unit,
    onDurationChanged: (Int) -> Unit,
    onNext: () -> Unit
) {
    var selectedSeverity by remember { mutableStateOf("") }
    var duration by remember { mutableIntStateOf(1) }

    val severityOptions = listOf("Mild", "Moderate", "Severe", "Very Severe")

    Text(
        text = "Symptoms Severity",
        style = MaterialTheme.typography.headlineSmall,
        fontWeight = FontWeight.Bold
    )

    Text(
        text = "How would you rate your ${selectedSymptoms.joinToString(", ")}?",
        style = MaterialTheme.typography.bodyMedium
    )

    Spacer(modifier = Modifier.height(16.dp))

    // Severity radio buttons
    Column(modifier = Modifier.selectableGroup()) {
        severityOptions.forEach { option ->
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
                    .selectable(
                        selected = option == selectedSeverity,
                        onClick = {
                            selectedSeverity = option
                            onSeveritySelected(option)
                        },
                        role = Role.RadioButton
                    )
                    .padding(horizontal = 16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                RadioButton(
                    selected = option == selectedSeverity,
                    onClick = null // null because we're handling the click above
                )
                Text(
                    text = option,
                    style = MaterialTheme.typography.bodyLarge,
                    modifier = Modifier.padding(start = 16.dp)
                )
            }
        }
    }

    Spacer(modifier = Modifier.height(24.dp))

    // Duration slider
    Text(
        text = "How long have you had these symptoms?",
        style = MaterialTheme.typography.bodyMedium
    )

    Spacer(modifier = Modifier.height(8.dp))

    Text(
        text = "$duration days",
        style = MaterialTheme.typography.bodyLarge
    )

    Slider(
        value = duration.toFloat(),
        onValueChange = {
            duration = it.toInt()
            onDurationChanged(it.toInt())
        },
        valueRange = 1f..14f,
        steps = 12
    )

    Spacer(modifier = Modifier.height(24.dp))

    Button(
        onClick = {
            onSeveritySelected(selectedSeverity)
            onDurationChanged(duration)
            onNext()
        },
        enabled = selectedSeverity.isNotEmpty(),
        modifier = Modifier.fillMaxWidth()
    ) {
        Text("Get Assessment")
    }
}

@Composable
fun TriageResults(
    selectedSymptoms: List<String>,
    severityLevel: String,
    durationDays: Int,
    onRestart: () -> Unit
) {
    // Determine recommendation based on symptoms, severity and duration
    val (recommendation, color, advice) = when {
        severityLevel == "Very Severe" ||
                selectedSymptoms.any { it == "Chest Pain" || it == "Shortness of Breath" } && severityLevel != "Mild" ->
            Triple("Seek immediate emergency care", Color(0xFFB71C1C),
                "Your symptoms may indicate a serious condition that requires immediate medical attention. " +
                        "Please go to the nearest emergency room or call emergency services.")

        severityLevel == "Severe" || durationDays > 7 ->
            Triple("Schedule an appointment with a doctor", Color(0xFFE65100),
                "Your symptoms are concerning and should be evaluated by a healthcare professional within 24-48 hours.")

        severityLevel == "Moderate" ->
            Triple("Consider a telehealth consultation", Color(0xFFFFB300),
                "Your symptoms warrant medical attention, but may not need an in-person visit. " +
                        "A telehealth consultation could help determine next steps.")

        else ->
            Triple("Self-care at home", Color(0xFF33691E),
                "Your symptoms appear to be mild. Rest, stay hydrated, and take over-the-counter " +
                        "medications as appropriate. If symptoms worsen or persist beyond 7 days, consult a healthcare provider.")
    }

    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = "Assessment Result",
            style = MaterialTheme.typography.headlineSmall,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(16.dp))

        Card(
            modifier = Modifier.fillMaxWidth(),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = "Based on your symptoms:",
                    style = MaterialTheme.typography.bodyMedium
                )

                Text(
                    text = selectedSymptoms.joinToString(", "),
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.Medium
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = "Severity: $severityLevel",
                    style = MaterialTheme.typography.bodyMedium
                )

                Text(
                    text = "Duration: $durationDays days",
                    style = MaterialTheme.typography.bodyMedium
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        Surface(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            color = color.copy(alpha = 0.2f),
            shape = MaterialTheme.shapes.medium
        ) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text(
                    text = recommendation,
                    style = MaterialTheme.typography.titleLarge,
                    color = color,
                    fontWeight = FontWeight.Bold
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = advice,
                    style = MaterialTheme.typography.bodyMedium
                )
            }
        }

        Spacer(modifier = Modifier.height(24.dp))

        Button(
            onClick = onRestart,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text("Start New Assessment")
        }
    }
}