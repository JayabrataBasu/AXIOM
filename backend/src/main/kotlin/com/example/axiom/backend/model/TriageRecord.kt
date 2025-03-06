// TriageRecord.kt
package com.example.axiom.backend.model

import jakarta.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "triage_records")
data class TriageRecord(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne
    @JoinColumn(name = "user_id")
    val user: User? = null,

    val symptoms: String, // Store as comma-separated values
    val severityLevel: String,
    val durationDays: Int,
    val recommendation: String,
    val createdAt: LocalDateTime = LocalDateTime.now()
)