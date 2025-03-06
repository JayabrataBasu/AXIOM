// Insurance.kt
package com.example.axiom.backend.model

import jakarta.persistence.*
import java.time.LocalDate

@Entity
@Table(name = "insurance")
data class Insurance(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne
    @JoinColumn(name = "user_id")
    val user: User? = null,

    val policyNumber: String,
    val provider: String,
    val validFrom: LocalDate,
    val validUntil: LocalDate
)