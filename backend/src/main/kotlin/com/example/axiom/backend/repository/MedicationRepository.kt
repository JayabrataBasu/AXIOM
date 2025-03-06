// MedicationRepository.kt
package com.example.axiom.backend.repository

import com.example.axiom.backend.model.Medication
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface MedicationRepository : JpaRepository<Medication, Long> {
    fun findByUserId(userId: Long): List<Medication>
    fun findByUserIdAndIsActive(userId: Long, isActive: Boolean): List<Medication>
}