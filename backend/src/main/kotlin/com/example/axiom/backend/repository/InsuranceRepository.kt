// InsuranceRepository.kt
package com.example.axiom.backend.repository

import com.example.axiom.backend.model.Insurance
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface InsuranceRepository : JpaRepository<Insurance, Long> {
    fun findByUserId(userId: Long): List<Insurance>
    fun findTopByUserIdOrderByIdDesc(userId: Long): Insurance?
}