// Appointment.kt
package com.example.axiom.backend.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "appointments")
data class Appointment(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne
    @JoinColumn(name = "user_id")
    val user: User? = null,

    val doctorName: String,
    val department: String,
    val appointmentTime: LocalDateTime,
    val location: String,
    val notes: String = "",
    val isPast: Boolean = false
)