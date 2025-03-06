// TriageRepository.kt
package com.example.axiom.backend.repository

import com.example.axiom.backend.model.TriageRecord
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.time.LocalDateTime

@Repository
interface TriageRepository : JpaRepository<TriageRecord, Long> {
    fun findByUserId(userId: Long): List<TriageRecord>
    fun findByUserIdOrderByCreatedAtDesc(userId: Long): List<TriageRecord>
}