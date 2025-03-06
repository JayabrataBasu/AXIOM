// TriageController.kt
package com.example.axiom.backend.controller

import com.example.axiom.backend.model.TriageRecord
import com.example.axiom.backend.repository.TriageRepository
import com.example.axiom.backend.repository.UserRepository
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/triage")
class TriageController(
    private val triageRepository: TriageRepository,
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getUserTriageRecords(@PathVariable userId: Long): List<TriageRecord> {
        return triageRepository.findByUserIdOrderByCreatedAtDesc(userId)
    }

    @PostMapping("/{userId}")
    fun createTriageRecord(
        @PathVariable userId: Long,
        @RequestBody triageRecord: TriageRecord
    ): ResponseEntity<TriageRecord> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            val savedRecord = triageRepository.save(triageRecord.copy(user = user.get()))
            ResponseEntity.status(HttpStatus.CREATED).body(savedRecord)
        } else {
            ResponseEntity.notFound().build()
        }
    }
}