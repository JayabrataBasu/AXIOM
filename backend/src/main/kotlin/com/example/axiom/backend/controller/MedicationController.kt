// MedicationController.kt
package com.example.axiom.backend.controller

import com.example.axiom.backend.model.Medication
import com.example.axiom.backend.repository.MedicationRepository
import com.example.axiom.backend.repository.UserRepository
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/medications")
class MedicationController(
    private val medicationRepository: MedicationRepository,
    private val userRepository: UserRepository
) {

    @GetMapping("/{userId}")
    fun getUserMedications(@PathVariable userId: Long): List<Medication> {
        return medicationRepository.findByUserId(userId)
    }

    @GetMapping("/{userId}/active")
    fun getActiveMedications(@PathVariable userId: Long): List<Medication> {
        return medicationRepository.findByUserIdAndIsActive(userId, true)
    }

    @PostMapping("/{userId}")
    fun createMedication(
        @PathVariable userId: Long,
        @RequestBody medication: Medication
    ): ResponseEntity<Medication> {
        val user = userRepository.findById(userId)
        return if (user.isPresent) {
            val savedMedication = medicationRepository.save(medication.copy(user = user.get()))
            ResponseEntity.status(HttpStatus.CREATED).body(savedMedication)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @PutMapping("/{id}")
    fun updateMedication(
        @PathVariable id: Long,
        @RequestBody medication: Medication
    ): ResponseEntity<Medication> {
        return if (medicationRepository.existsById(id)) {
            val updatedMedication = medicationRepository.save(medication.copy(id = id))
            ResponseEntity.ok(updatedMedication)
        } else {
            ResponseEntity.notFound().build()
        }
    }

    @DeleteMapping("/{id}")
    fun deleteMedication(@PathVariable id: Long): ResponseEntity<Void> {
        return if (medicationRepository.existsById(id)) {
            medicationRepository.deleteById(id)
            ResponseEntity.noContent().build()
        } else {
            ResponseEntity.notFound().build()
        }
    }
}