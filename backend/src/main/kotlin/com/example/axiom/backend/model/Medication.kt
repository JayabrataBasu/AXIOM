// Medication.kt
package com.example.axiom.backend.model

import jakarta.persistence.*
import java.time.LocalTime

@Entity
@Table(name = "medications")
data class Medication(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne
    @JoinColumn(name = "user_id")
    val user: User? = null,

    val medicationName: String,
    val dosage: String,
    val reminderTime: LocalTime,
    val isActive: Boolean = true
)