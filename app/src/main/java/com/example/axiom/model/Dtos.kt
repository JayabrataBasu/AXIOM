// Create file: app/src/main/java/com/example/axiom/model/Dtos.kt
package com.example.axiom.model

import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

data class UserDto(
    val id: Long? = null,
    val name: String,
    val email: String
)

data class InsuranceDto(
    val id: Long? = null,
    val policyNumber: String,
    val provider: String,
    val validFrom: String, // Date as ISO string "2023-01-01"
    val validUntil: String // Date as ISO string "2023-12-31"
)

data class AppointmentDto(
    val id: Long? = null,
    val doctorName: String,
    val department: String,
    val appointmentTime: String, // DateTime as ISO string "2023-07-15T10:30:00"
    val location: String,
    val notes: String = "",
    val isPast: Boolean = false
)

data class MedicationDto(
    val id: Long? = null,
    val medicationName: String,
    val dosage: String,
    val reminderTime: String, // Time as ISO string "10:30:00"
    val isActive: Boolean = true
)

data class TriageDto(
    val id: Long? = null,
    val symptoms: String,
    val severityLevel: String,
    val durationDays: Int,
    val recommendation: String = "",
    val createdAt: String? = null // DateTime as ISO string, generated on backend
)